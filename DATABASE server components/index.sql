-- Лабораторная работа по SQL - Вариант 12
-- Хранимые процедуры:
-- 1.	Реализовать хранимую процедуру, возвращающую текстовую строку, содержащую информацию о потребителе (идентификатор, фамилия, адрес, дата, место и стоимость последней закупки). Обработать ситуацию, когда ничего не покупал.
-- 2.	Добавить таблицу, содержащую списки товаров по каждому отделению КООП. При вводе закупки проверять товар относительно отделения.
-- 3.	Реализовать триггер такой, что при вводе строки в таблице закупок, если сумма не указана, то она вычисляется 
-- 4.	Создать представление (view), содержащее поля: номер договора, дата, фамилия и адрес потребителя, кредит, товар, количество, итого закупки. Обеспечить возможность изменения предоставленного кредита. При этом должна быть пересчитана итоговая стоимость.


-- 1. Создание таблиц

-- Таблица потребителей
CREATE TABLE Consumers (
  consumer_id INT PRIMARY KEY,
  last_name NVARCHAR(255),       
  address NVARCHAR(255)          
);

-- Таблица договоров
CREATE TABLE Contracts (
  contract_number INT PRIMARY KEY, 
  consumer_id INT,                 
  contract_date DATE,              
  credit DECIMAL(10,2),            
  CONSTRAINT FK_Contracts_Consumers FOREIGN KEY (consumer_id) REFERENCES Consumers(consumer_id)
);

-- Таблица списков товаров по отделениям (КООП)
CREATE TABLE DepartmentProducts (
  product_id INT PRIMARY KEY,      -
  department_id INT,               
  product_name NVARCHAR(255),    
  unit_price DECIMAL(10,2)        
);

-- Таблица закупок
CREATE TABLE Purchases (
  purchase_id INT IDENTITY(1,1) PRIMARY KEY, 
  contract_number INT,                      
  consumer_id INT,                          
  department_id INT,                         
  product_id INT,                         
  purchase_date DATE,                      
  location NVARCHAR(255),                  
  cost DECIMAL(10,2),                        
  quantity INT,                              
  CONSTRAINT FK_Purchases_Contracts FOREIGN KEY (contract_number) REFERENCES Contracts(contract_number)
);

-- Доп таблица для логирования зменений кредита
CREATE TABLE CreditChanges (
  change_id INT IDENTITY(1,1) PRIMARY KEY,
  contract_number INT,                    
  old_credit DECIMAL(10,2),               
  new_credit DECIMAL(10,2),               
  change_date DATETIME DEFAULT GETDATE()   
);


-- 2. Хранимая процедура для получения информации о потребителе
CREATE PROCEDURE sp_get_consumer_info 
  @consumer_id INT
AS
BEGIN
  -- Объявление переменных для хранения информации о потребителе и последней закупке
  DECLARE @last_name NVARCHAR(255), @address NVARCHAR(255);
  DECLARE @purchase_date DATE, @location NVARCHAR(255);
  DECLARE @cost DECIMAL(10,2);
  
  -- Проверка существования потребителя
  IF NOT EXISTS (SELECT 1 FROM Consumers WHERE consumer_id = @consumer_id)
  BEGIN
    SELECT 'Потребитель не найден' AS result;
    RETURN;
  END;
  
  -- Получение фамилии и адреса потребителя
  SELECT @last_name = last_name, @address = address
  FROM Consumers
  WHERE consumer_id = @consumer_id;
  
  -- Получение информации о последней закупке
  SELECT TOP 1 
    @purchase_date = purchase_date,
    @location = location,
    @cost = cost
  FROM Purchases
  WHERE consumer_id = @consumer_id
  ORDER BY purchase_date DESC;
  
  -- Формирование результата в зависимости от наличия закупок
  IF @purchase_date IS NULL
    SELECT CONCAT('Потребитель ', @consumer_id, ', ', @last_name, ', ', @address, ' - не совершал покупок') AS result;
  ELSE
    SELECT CONCAT('Потребитель ', @consumer_id, ', ', @last_name, ', ', @address, ' - Последняя покупка: ', CONVERT(VARCHAR, @purchase_date), ', ', @location, ', ', @cost) AS result;
END;
GO


-- 3. Триггер для таблицы закупок
CREATE TRIGGER trg_before_insert_purchases
ON Purchases
INSTEAD OF INSERT
AS
BEGIN
  SET NOCOUNT ON;
  
  -- Проверка соответствия товара отделению
  IF EXISTS (
    SELECT 1 FROM inserted i
    LEFT JOIN DepartmentProducts dp ON i.product_id = dp.product_id AND i.department_id = dp.department_id
    WHERE dp.product_id IS NULL
  )
  BEGIN
    RAISERROR ('Неверный товар для данного отделения', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END;
  
  -- Вставка записей с вычислением стоимости, если она не указана
  INSERT INTO Purchases (contract_number, consumer_id, department_id, product_id, purchase_date, location, cost, quantity)
  SELECT 
    i.contract_number,
    i.consumer_id,
    i.department_id,
    i.product_id,
    i.purchase_date,
    i.location,
    CASE 
      WHEN i.cost IS NULL THEN i.quantity * dp.unit_price 
      ELSE i.cost 
    END,
    i.quantity
  FROM inserted i
  JOIN DepartmentProducts dp ON i.product_id = dp.product_id AND i.department_id = dp.department_id;
END;
GO


-- 4 Представление с возможностью обновления кредита
CREATE VIEW vw_contracts_info
AS
SELECT 
  c.contract_number,
  c.contract_date,
  cons.last_name,
  cons.address,
  c.credit,
  dp.product_name AS товар,
  p.quantity,
  (p.cost - c.credit) AS итого_закупки
FROM Contracts c
JOIN Consumers cons ON c.consumer_id = cons.consumer_id
JOIN Purchases p ON c.contract_number = p.contract_number
JOIN DepartmentProducts dp ON p.product_id = dp.product_id;
GO

-- Триггер для обеспечения возможности обновления кредита через представление
CREATE TRIGGER trg_instead_update_vw_contracts_info
ON vw_contracts_info
INSTEAD OF UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  
  UPDATE c
  SET credit = i.credit
  FROM Contracts c
  JOIN inserted i ON c.contract_number = i.contract_number;
END;
GO

-- Таблица CreditChanges логирует изменения кредита, фиксируя старое и новое значение с датой изменения.
-- Триггер выполняется после обновления таблицы Contracts.
CREATE TRIGGER trg_after_update_contract_credit
ON Contracts
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO CreditChanges (contract_number, old_credit, new_credit, change_date)
  SELECT d.contract_number, d.credit, i.credit, GETDATE()
  FROM deleted d
  JOIN inserted i ON d.contract_number = i.contract_number
  WHERE d.credit <> i.credit;
END;
GO

-- Пример 1: Вызов хранимой процедуры для потребителя, который совершал покупки
EXEC sp_get_consumer_info 101;
-- Потребитель 101, Иванов, ул. Ленина, 2025-02-25, Магазин "КООП", 1500.00

-- Пример 2: Вызов хранимой процедуры для потребителя, который не совершал покупок
EXEC sp_get_consumer_info 102;
-- Потребитель 102, Петров, ул. Победы - не совершал покупок

-- Пример 3: Вызов хранимой процедуры для несуществующего потребителя
EXEC sp_get_consumer_info 999;
-- Потребитель не найден

-- Пример 4: Вставка закупки без указания стоимости 
INSERT INTO Purchases (contract_number, consumer_id, department_id, product_id, purchase_date, location, cost, quantity)
VALUES (201, 101, 10, 501, '2025-02-25', 'Магазин "КООП"', NULL, 3);
-- В таблице Purchases вставлена строка с рассчитанной стоимостью: 1500.00

-- Пример 5: Обновление кредита через представление 
UPDATE vw_contracts_info
SET credit = 200.00
WHERE contract_number = 201;
-- Кредит в договоре обновлен до 200.00, итоговая закупка пересчитана (стоимость закупки минус 200.00)



-- 1. Создание таблицы для логирования высокозначимых закупок
CREATE TABLE HighValuePurchases (
  hvp_id INT IDENTITY(1,1) PRIMARY KEY,   
  purchase_id INT,                         
  contract_number INT,                      
  consumer_id INT,                          
  cost DECIMAL(10,2),                       
  purchase_date DATE,                       
  alert_message NVARCHAR(255)              
);
GO

-- 2. AFTER-триггер для логирования высокозначимых закупок
CREATE TRIGGER trg_log_high_value_purchase
ON Purchases
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;
  
  INSERT INTO HighValuePurchases (purchase_id, contract_number, consumer_id, cost, purchase_date, alert_message)
  SELECT 
    i.purchase_id,
    i.contract_number,
    i.consumer_id,
    i.cost,
    i.purchase_date,
    'Высокая стоимость закупки' 
  FROM inserted i
  WHERE i.cost > 10000;
END;
GO

-- 3. Хранимая процедура для формирования ежемесячного отчёта по закупкам
CREATE PROCEDURE sp_generate_monthly_report 
  @year INT,  
  @month INT  
AS
BEGIN
  SELECT 
    c.contract_number,               
    cons.consumer_id,                
    cons.last_name,                  
    SUM(p.cost) AS total_cost,       
    SUM(p.quantity) AS total_quantity, 
    COUNT(*) AS purchase_count       
  FROM Purchases p
  JOIN Contracts c ON p.contract_number = c.contract_number
  JOIN Consumers cons ON c.consumer_id = cons.consumer_id
  WHERE YEAR(p.purchase_date) = @year
    AND MONTH(p.purchase_date) = @month
  GROUP BY 
    c.contract_number, 
    cons.consumer_id, 
    cons.last_name;
END;
GO

-- Если вставленная закупка имеет стоимость более 10000, она будет залогирована в таблице HighValuePurchases.
INSERT INTO Purchases (contract_number, consumer_id, department_id, product_id, purchase_date, location, cost, quantity)
VALUES (202, 103, 12, 510, '2025-02-26', 'Магазин "КООП"', 15000.00, 2);
-- В таблице HighValuePurchases добавлена запись:
-- purchase_id, contract_number = 202, consumer_id = 103, cost = 15000.00, purchase_date = '2025-02-26', alert_message = 'Высокая стоимость закупки'


-- Пример: Генерация ежемесячного отчёта по закупкам за февраль 2025 года
EXEC sp_generate_monthly_report @year = 2025, @month = 2;
-- contract_number | consumer_id | last_name | total_cost | total_quantity | purchase_count
-- (пример значений, зависящих от данных за февраль 2025)