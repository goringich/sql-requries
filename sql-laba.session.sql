-- Deleting existing tables, if any
DROP TABLE IF EXISTS "ЗАКУПКИ" CASCADE;
DROP TABLE IF EXISTS "ТОВАР" CASCADE;
DROP TABLE IF EXISTS "ПОТРЕБИТЕЛЬ" CASCADE;
DROP TABLE IF EXISTS "ОТДЕЛЕНИЕ__КООП" CASCADE;

-- Creating the table DEPARTMENT__COOP
CREATE TABLE "ОТДЕЛЕНИЕ__КООП" (
  "ИДЕНТИФИКАТОР" CHAR(3) PRIMARY KEY,
  "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО" VARCHAR(50) NOT NULL,
  "АДРЕС" VARCHAR(100) NOT NULL,
  "КОМИССИОННЫЕ" DECIMAL(3,1) NOT NULL CHECK ("КОМИССИОННЫЕ" >= 0 AND "КОМИССИОННЫЕ" <= 100)
);

-- Creating the Consumer table
CREATE TABLE "ПОТРЕБИТЕЛЬ" (
  "ИДЕНТИФИКАТОР" CHAR(3) PRIMARY KEY,
  "ФАМИЛИЯ" VARCHAR(50) NOT NULL,
  "АДРЕС" VARCHAR(100) NOT NULL,
  "КРЕДИТ" DECIMAL(3,1) NOT NULL CHECK ("КРЕДИТ" >= 0 AND "КРЕДИТ" <= 100)
);

-- Creating the Commodity table
CREATE TABLE "ТОВАР" (
  "ИДЕНТИФИКАТОР" CHAR(3) PRIMARY KEY,
  "НАИМЕНОВАНИЕ" VARCHAR(100) NOT NULL,
  "ЦЕНА_1_ОЙ_ЕДИНИЦЫ" DECIMAL(10,2) NOT NULL CHECK ("ЦЕНА_1_ОЙ_ЕДИНИЦЫ" >= 0),
  "СКЛАД" VARCHAR(100) NOT NULL,
  "МАКС_ЗАКАЗ" INTEGER NOT NULL CHECK ("МАКС_ЗАКАЗ" > 0)
);

-- Creating the REQUIREMENTS table with foreign keys
CREATE TABLE "ЗАКУПКИ" (
  "НОМЕР_ДОГОВОРА" INTEGER PRIMARY KEY,
  "ДАТА" DATE NOT NULL,
  "ОТДЕЛЕНИЕ__КООП" CHAR(3) NOT NULL,
  "ПОТРЕБИТЕЛЬ" CHAR(3) NOT NULL,
  "ТОВАР" CHAR(3) NOT NULL,
  "КОЛ_ВО" INTEGER NOT NULL CHECK ("КОЛ_ВО" > 0),
  "ИТОГО_RUB" DECIMAL(12,2) NOT NULL CHECK ("ИТОГО_RUB" >= 0),
  FOREIGN KEY ("ОТДЕЛЕНИЕ__КООП") REFERENCES "ОТДЕЛЕНИЕ__КООП"("ИДЕНТИФИКАТОР"),
  FOREIGN KEY ("ПОТРЕБИТЕЛЬ") REFERENCES "ПОТРЕБИТЕЛЬ"("ИДЕНТИФИКАТОР"),
  FOREIGN KEY ("ТОВАР") REFERENCES "ТОВАР"("ИДЕНТИФИКАТОР")
);

-- Inserting data into the table DEPARTMENT__COOP
INSERT INTO "ОТДЕЛЕНИЕ__КООП" ("ИДЕНТИФИКАТОР", "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", "АДРЕС", "КОМИССИОННЫЕ")
VALUES 
('001', 'Рыбников', 'Н.Новгород', 5),
('002', 'Ильин', 'Заволжье', 4),
('003', 'Горошина', 'Моховые горы', 3),
('004', 'Саленко', 'Тарасиха', 4),
('005', 'Трефилова', 'Ольховка', 4),
('006', 'Легков', 'Н.Новгород', 5);

-- Inserting data into the CLIENT table
INSERT INTO "ПОТРЕБИТЕЛЬ" ("ИДЕНТИФИКАТОР", "ФАМИЛИЯ", "АДРЕС", "КРЕДИТ")
VALUES 
('001', 'Жуков', 'Заволжье', 3),
('002', 'Денисов', 'Моховые горы', 3),
('003', 'Доманова', 'Ольховка', 0),
('004', 'Федорин', 'Заволжье', 0),
('005', 'Артамонов', 'Ольховка', 2);

-- Inserting data into the Commodity table
INSERT INTO "ТОВАР" ("ИДЕНТИФИКАТОР", "НАИМЕНОВАНИЕ", "ЦЕНА_1_ОЙ_ЕДИНИЦЫ", "СКЛАД", "МАКС_ЗАКАЗ")
VALUES 
('001', 'Гвозди', 100, 'Заволжье', 120000),
('002', 'Ведро оцинкованное', 1200, 'Заволжье', 400),
('003', 'Пила ручная', 3000, 'Ольховка', 320),
('004', 'Топор', 2200, 'Тарасиха', 500),
('005', 'Масло машинное', 5000, 'Н.Новгород', 1000),
('006', 'Иглы швейные', 7500, 'Н.Новгород', 120),
('007', 'Нитки', 8000, 'Н.Новгород', 300);

-- Inserting data into the PURCHASING table
INSERT INTO "ЗАКУПКИ" ("НОМЕР_ДОГОВОРА", "ДАТА", "ОТДЕЛЕНИЕ__КООП", "ПОТРЕБИТЕЛЬ", "ТОВАР", "КОЛ_ВО", "ИТОГО_RUB")
VALUES 
(29036, 'Январь', '005', '001', '007', 10, 80000),
(29037, 'Январь', '002', '002', '006', 1, 7500),
(29038, 'Январь', '004', '002', '004', 2, 4400),
(29039, 'Январь', '006', '005', '003', 1, 3000),
(29040, 'Февраль', '003', '003', '005', 4, 20000),
(29041, 'Апрель', '005', '005', '005', 4, 20000),
(29042, 'Май', '005', '002', '001', 100, 10000),
(29043, 'Май', '003', '004', '004', 1, 2200),
(29044, 'Июнь', '003', '002', '001', 200, 20000),
(29045, 'Июнь', '001', '005', '004', 1, 2200),
(29046, 'Июнь', '006', '005', '003', 2, 6000),
(29047, 'Июль', '004', '002', '004', 2, 4400),
(29048, 'Июль', '002', '003', '005', 5, 25000),
(29049, 'Июль', '002', '003', '007', 4, 32000),
(29050, 'Июль', '004', '003', '006', 1, 7500),
(29051, 'Июль', '006', '004', '006', 1, 7500),
(29052, 'Июль', '001', '003', '002', 4, 4800);

-- Проверка данных
SELECT * FROM "ОТДЕЛЕНИЕ__КООП";
SELECT * FROM "ПОТРЕБИТЕЛЬ";
SELECT * FROM "ТОВАР";
SELECT * FROM "ЗАКУПКИ";

-- Names of all COOP department heads along with address, sorted by address:
SELECT "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", "АДРЕС"
FROM "ОТДЕЛЕНИЕ__КООП"
ORDER BY "АДРЕС";

-- All product names:
SELECT DISTINCT "НАИМЕНОВАНИЕ"
FROM "ТОВАР";

--  All the different consumer addresses along with the size of the loan:
SELECT DISTINCT "АДРЕС", "КРЕДИТ"
FROM "ПОТРЕБИТЕЛЬ";


-- addresses and names of consumers with credit amounts greater than 2%
SELECT "ФАМИЛИЯ", "АДРЕС"
FROM "ПОТРЕБИТЕЛЬ"
WHERE "КРЕДИТ" > 2;

-- Names and stocking locations of goods with prices from 1000 to 5000 rubles:
SELECT "НАИМЕНОВАНИЕ", "СКЛАД" 
FROM "ТОВАР" 
WHERE "ЦЕНА_1_ОЙ_ЕДИНИЦЫ" BETWEEN 1000 AND 5000;

-- Names of managers and addresses of COOP branches outside N.Novgorod with commissions less than 4%:
SELECT "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", "АДРЕС", "КОМИССИОННЫЕ"
FROM "ОТДЕЛЕНИЕ__КООП"
WHERE "АДРЕС" != 'Н.Новгород' AND "КОМИССИОННЫЕ" < 4
ORDER BY "АДРЕС", "КОМИССИОННЫЕ";

-- Name of the consumer, date and name of the item: 
SELECT "ПОТРЕБИТЕЛЬ"."ФАМИЛИЯ", "ЗАКУПКИ"."ДАТА", "ТОВАР"."НАИМЕНОВАНИЕ"
FROM "ЗАКУПКИ"
JOIN "ПОТРЕБИТЕЛЬ" ON "ЗАКУПКИ"."ПОТРЕБИТЕЛЬ" = "ПОТРЕБИТЕЛЬ"."ИДЕНТИФИКАТОР"
JOIN "ТОВАР" ON "ЗАКУПКИ"."ТОВАР" = "ТОВАР"."ИДЕНТИФИКАТОР";

-- Date, name of COOP superintendent, name and quantity of goods:
SELECT "ЗАКУПКИ"."ДАТА", "ОТДЕЛЕНИЕ__КООП"."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", "ТОВАР"."НАИМЕНОВАНИЕ", "ЗАКУПКИ"."КОЛ_ВО"
FROM "ЗАКУПКИ"
JOIN "ОТДЕЛЕНИЕ__КООП" ON "ЗАКУПКИ"."ОТДЕЛЕНИЕ__КООП" = "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР"
JOIN "ТОВАР" ON "ЗАКУПКИ"."ТОВАР" = "ТОВАР"."ИДЕНТИФИКАТОР";

-- Contract number, date and name of consumers who bought a bucket or order for ≥ 20000 rubles:
SELECT "НОМЕР_ДОГОВОРА", "ДАТА", "ПОТРЕБИТЕЛЬ"."ФАМИЛИЯ" 
FROM "ЗАКУПКИ"
JOIN "ПОТРЕБИТЕЛЬ" ON "ЗАКУПКИ"."ПОТРЕБИТЕЛЬ" = "ПОТРЕБИТЕЛЬ"."ИДЕНТИФИКАТОР"
JOIN "ТОВАР" ON "ЗАКУПКИ"."ТОВАР" = "ТОВАР"."ИДЕНТИФИКАТОР"
WHERE "ТОВАР"."НАИМЕНОВАНИЕ" = 'Ведро оцинкованное' OR "ИТОГО_RUB" >= 20000;

-- Identifiers and addresses of branches where consumers with credit > 2% after January shopped:
SELECT DISTINCT "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР", "ОТДЕЛЕНИЕ__КООП"."АДРЕС", "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО"
FROM "ЗАКУПКИ"
JOIN "ОТДЕЛЕНИЕ__КООП" ON "ЗАКУПКИ"."ОТДЕЛЕНИЕ__КООП" = "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР"
JOIN "ПОТРЕБИТЕЛЬ" ON "ЗАКУПКИ"."ПОТРЕБИТЕЛЬ" = "ПОТРЕБИТЕЛЬ"."ИДЕНТИФИКАТОР"
WHERE "ПОТРЕБИТЕЛЬ"."КРЕДИТ" > 2 AND "ЗАКУПКИ"."ДАТА" > '2024-01-31';

-- names of consumers who do not live in Tarasikha, who bought goods in those branches where the commission rate is more than 4%:
SELECT DISTINCT "ПОТРЕБИТЕЛЬ"."ФАМИЛИЯ"
FROM "ЗАКУПКИ"
JOIN "ПОТРЕБИТЕЛЬ" ON "ЗАКУПКИ"."ПОТРЕБИТЕЛЬ" = "ПОТРЕБИТЕЛЬ"."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" ON "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР" = "ЗАКУПКИ"."ОТДЕЛЕНИЕ__КООП"
WHERE "ПОТРЕБИТЕЛЬ"."АДРЕС" != 'Тарасиха' AND "ОТДЕЛЕНИЕ__КООП"."КОМИССИОННЫЕ" > 4;

-- purchase data for items that were warehoused and purchased in the same neighborhood. Include cost data and sort in ascending order. 
SELECT 
  "ЗАКУПКИ"."НОМЕР_ДОГОВОРА",
  "ЗАКУПКИ"."ДАТА",
  "ОТДЕЛЕНИЕ__КООП"."АДРЕС" AS "РАЙОН_ПОКУПКИ",
  "ТОВАР"."НАИМЕНОВАНИЕ",
  "ТОВАР"."СКЛАД" AS "РАЙОН_СКЛАДИРОВАНИЯ",
  "ЗАКУПКИ"."КОЛ_ВО",
  "ЗАКУПКИ"."ИТОГО_RUB" AS "СТОИМОСТЬ"
FROM "ЗАКУПКИ"
JOIN "ТОВАР" ON "ЗАКУПКИ"."ТОВАР" = "ТОВАР"."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" ON "ЗАКУПКИ"."ОТДЕЛЕНИЕ__КООП" = "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР"
WHERE "ОТДЕЛЕНИЕ__КООП"."АДРЕС" = "ТОВАР"."СКЛАД"
ORDER BY "ЗАКУПКИ"."ИТОГО_RUB" ASC;

-- Modification of the column with the total purchase value
UPDATE "ЗАКУПКИ"
SET "ИТОГО_RUB" = "ИТОГО_RUB" * (1 - "ПОТРЕБИТЕЛЬ"."КРЕДИТ" / 100)
FROM "ПОТРЕБИТЕЛЬ"
WHERE "ЗАКУПКИ"."ПОТРЕБИТЕЛЬ" = "ПОТРЕБИТЕЛЬ"."ИДЕНТИФИКАТОР";

SELECT "НОМЕР_ДОГОВОРА", "ИТОГО_RUB"
FROM "ЗАКУПКИ";

--  Expansion of the “PURCHASING” table with a column with commissions
ALTER TABLE "ЗАКУПКИ" ADD COLUMN "КОМИССИОННЫЕ" DECIMAL(3,1);

UPDATE "ЗАКУПКИ"
SET "КОМИССИОННЫЕ" = "ОТДЕЛЕНИЕ__КООП"."КОМИССИОННЫЕ"
FROM "ОТДЕЛЕНИЕ__КООП"
WHERE "ЗАКУПКИ"."ОТДЕЛЕНИЕ__КООП" = "ОТДЕЛЕНИЕ__КООП"."ИДЕНТИФИКАТОР";

SELECT "НОМЕР_ДОГОВОРА", "КОМИССИОННЫЕ"
FROM "ЗАКУПКИ";


