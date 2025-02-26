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
  "ДАТА" VARCHAR(20) NOT NULL,
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
(29052, 'Июль', '001', '003', '002', 4, 4800),
(29053, 'Июль', '001', '004', '002', 1, 4800);

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



-- SECOND PART 

-- Which superintendents have the same commission as Ileen's:
SELECT "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", "КОМИССИОННЫЕ"
FROM "ОТДЕЛЕНИЕ__КООП"
WHERE "КОМИССИОННЫЕ" IN (
  SELECT "КОМИССИОННЫЕ"
  FROM "ОТДЕЛЕНИЕ__КООП"
  WHERE "ФАМИЛИЯ_ЗАВЕДУЮЩЕГО" = 'Ильин'
);

-- (with in/no in) contract number, date, name of consumers who bought buckets or placed an order for a total amount of at least 20000rub.
SELECT З."НОМЕР_ДОГОВОРА", З."ДАТА", П."ФАМИЛИЯ"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
WHERE З."ТОВАР" IN (
  SELECT Т."ИДЕНТИФИКАТОР"
  FROM "ТОВАР" Т
  WHERE Т."НАИМЕНОВАНИЕ" = 'Ведро оцинкованное'
) 
OR З."ИТОГО_RUB" >= 20000;

SELECT DISTINCT О."ИДЕНТИФИКАТОР", О."АДРЕС", О."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" О ON З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
WHERE П."КРЕДИТ" > 2
  AND З."ДАТА" > 'Январь'
  AND О."ИДЕНТИФИКАТОР" IN (
    SELECT З1."ОТДЕЛЕНИЕ__КООП"
    FROM "ЗАКУПКИ" З1
    WHERE З1."ДАТА" > 'Январь'
  );

-- which purchases have not been made since March.
SELECT *
FROM "ЗАКУПКИ"
WHERE "ДАТА" NOT IN ('Март', 'Апрель', 'Май', 'Июнь', 'Июль');

-- Find consumers who do not live in Tarasikha, who bought goods at branches with a commission of > 4%
SELECT DISTINCT П."ФАМИЛИЯ"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" О ON О."ИДЕНТИФИКАТОР" = З."ОТДЕЛЕНИЕ__КООП"
WHERE П."АДРЕС" != 'Тарасиха' 
  AND О."КОМИССИОННЫЕ" > 4;

-- Find among the goods bought by the consumers from Tarasikha the remaining one in the smallest quantity
-- WITH ALL
SELECT Т."НАИМЕНОВАНИЕ" AS "check_bags", З."КОЛ_ВО"
FROM "ЗАКУПКИ" З
JOIN "ТОВАР" Т ON З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
WHERE П."АДРЕС" = 'Тарасиха'
  AND З."КОЛ_ВО" <= ALL (
    SELECT З2."КОЛ_ВО"
    FROM "ЗАКУПКИ" З2
    JOIN "ПОТРЕБИТЕЛЬ" П2 ON З2."ПОТРЕБИТЕЛЬ" = П2."ИДЕНТИФИКАТОР"
    WHERE П2."АДРЕС" = 'Тарасиха'
  );


-- Are there purchases that have the highest total with the least amount purchased
SELECT *
FROM "ЗАКУПКИ"
WHERE "ИТОГО_RUB" = ALL (
    SELECT "ИТОГО_RUB"
    FROM "ЗАКУПКИ"
)
AND "КОЛ_ВО" = ANY (
    SELECT "КОЛ_ВО"
    FROM "ЗАКУПКИ"
);

-- Using ALL-ANY operations, implement the following queries: query task 7.d;
SELECT 
  З."НОМЕР_ДОГОВОРА",
  З."ДАТА",
  О."АДРЕС" AS "РАЙОН_ПОКУПКИ",
  Т."НАИМЕНОВАНИЕ",
  Т."СКЛАД" AS "РАЙОН_СКЛАДИРОВАНИЯ",
  З."КОЛ_ВО",
  З."ИТОГО_RUB" AS "СТОИМОСТЬ"
FROM "ЗАКУПКИ" З
JOIN "ТОВАР" Т ON З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" О ON З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
WHERE О."АДРЕС" = Т."СКЛАД"
  AND З."ИТОГО_RUB" <= ALL (
    SELECT З2."ИТОГО_RUB"
    FROM "ЗАКУПКИ" З2
    WHERE З2."ТОВАР" = Т."ИДЕНТИФИКАТОР"
  )
ORDER BY З."ИТОГО_RUB" ASC;



-- To find the consumer with the highest creditworthiness among those who bought goods in Nizhny Novgorod branches of COOP
SELECT "ФАМИЛИЯ", "КРЕДИТ"
FROM "ПОТРЕБИТЕЛЬ"
WHERE "ИДЕНТИФИКАТОР" IN (
    SELECT "ПОТРЕБИТЕЛЬ"
    FROM "ЗАКУПКИ" З
    JOIN "ОТДЕЛЕНИЕ__КООП" О ON З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
    WHERE О."АДРЕС" = 'Н.Новгород'
)
ORDER BY "КРЕДИТ" DESC
LIMIT 1;

-- Using the UNION operation. Get residential addresses of consumers and storage locations of goods
SELECT "АДРЕС" AS "МЕСТО"
FROM "ПОТРЕБИТЕЛЬ"

UNION

SELECT "СКЛАД" AS "МЕСТО"
FROM "ТОВАР";


-- Using EXISTS and NOT EXISTS operations
-- 1. Find those COOP offices that supplied all consumers from Zavolzhye region
SELECT О1."ИДЕНТИФИКАТОР", О1."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", О1."АДРЕС"
FROM "ОТДЕЛЕНИЕ__КООП" О1
WHERE NOT EXISTS (
    SELECT П."ИДЕНТИФИКАТОР"
    FROM "ПОТРЕБИТЕЛЬ" П
    WHERE П."АДРЕС" = 'Заволжье'
    AND NOT EXISTS (
        SELECT З."НОМЕР_ДОГОВОРА"
        FROM "ЗАКУПКИ" З
        WHERE З."ОТДЕЛЕНИЕ__КООП" = О1."ИДЕНТИФИКАТОР"
        AND З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
    )
);

-- 2. What goods did all consumers buy more than once
SELECT Т."НАИМЕНОВАНИЕ"
FROM "ТОВАР" Т
WHERE NOT EXISTS (
    SELECT П."ИДЕНТИФИКАТОР"
    FROM "ПОТРЕБИТЕЛЬ" П
    WHERE NOT EXISTS (
        SELECT З."НОМЕР_ДОГОВОРА"
        FROM "ЗАКУПКИ" З
        WHERE З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
        AND З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
        AND З."КОЛ_ВО" > 1
    )
);

-- 3. find consumers who did not buy goods with a price of more than 4000 rubles.
SELECT П."ФАМИЛИЯ", П."АДРЕС"
FROM "ПОТРЕБИТЕЛЬ" П
WHERE NOT EXISTS (
    SELECT З."НОМЕР_ДОГОВОРА"
    FROM "ЗАКУПКИ" З
    JOIN "ТОВАР" ТОВ ON З."ТОВАР" = ТОВ."ИДЕНТИФИКАТОР"
    WHERE З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
    AND ТОВ."ЦЕНА_1_ОЙ_ЕДИНИЦЫ" > 4000
);

-- 4. Find the goods that all COOP offices sold to all consumers with credit greater than 2%
SELECT Т."НАИМЕНОВАНИЕ"
FROM "ТОВАР" Т
WHERE NOT EXISTS (
    SELECT О."ИДЕНТИФИКАТОР"
    FROM "ОТДЕЛЕНИЕ__КООП" О
    WHERE NOT EXISTS (
        SELECT З."НОМЕР_ДОГОВОРА"
        FROM "ЗАКУПКИ" З
        JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
        WHERE З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
        AND З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
        AND П."КРЕДИТ" > 2
    )
);


-- Use of aggregate functions
-- 1. Find among the COOP offices that sold goods to all consumers from Zavolzhye those that have commissions higher than average
SELECT О."ИДЕНТИФИКАТОР", О."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", О."КОМИССИОННЫЕ"
FROM "ОТДЕЛЕНИЕ__КООП" О
WHERE О."ИДЕНТИФИКАТОР" IN (
    SELECT З."ОТДЕЛЕНИЕ__КООП"
    FROM "ЗАКУПКИ" З
    JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
    WHERE П."АДРЕС" = 'Заволжье'
    GROUP BY З."ОТДЕЛЕНИЕ__КООП"
    HAVING COUNT(DISTINCT З."ПОТРЕБИТЕЛЬ") = (SELECT COUNT(*) FROM "ПОТРЕБИТЕЛЬ" WHERE "АДРЕС" = 'Заволжье')
)
AND О."КОМИССИОННЫЕ" > (SELECT AVG("КОМИССИОННЫЕ") FROM "ОТДЕЛЕНИЕ__КООП");

-- 2. How many different products were ordered by consumers with minimal credit
SELECT COUNT(DISTINCT З."ТОВАР") AS "Количество_товаров"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
WHERE П."КРЕДИТ" = (SELECT MIN("КРЕДИТ") FROM "ПОТРЕБИТЕЛЬ");

-- 3. Find the total value of all items sold in May
-- Assuming that the 'DATE' is stored in the format 'Year-Month-Day', e.g. '2024-05-15'.
SELECT SUM("ИТОГО_RUB") AS "Общая_стоимость_мая"
FROM "ЗАКУПКИ"
WHERE "ДАТА" = 'Май';


-- 4. How many total saws were sold during the spring period
-- Assuming that the spring period is March, April, May.
SELECT SUM(З."КОЛ_ВО") AS "Всего_продано_пил"
FROM "ЗАКУПКИ" З
JOIN "ТОВАР" Т ON З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
WHERE Т."НАИМЕНОВАНИЕ" = 'Пила ручная'
AND З."ДАТА" IN ('Март', 'Апрель', 'Май');

-- Utilization of constellation facilities
-- 1. Determine for each item of goods the average amount of credit of consumers who borrowed this product in COOP branches in N.Novgorod.
SELECT Т."НАИМЕНОВАНИЕ", AVG(П."КРЕДИТ") AS "Средний_кредит"
FROM "ЗАКУПКИ" З
JOIN "ТОВАР" Т ON З."ТОВАР" = Т."ИДЕНТИФИКАТОР"
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" О ON З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
WHERE О."АДРЕС" = 'Н.Новгород'
GROUP BY Т."НАИМЕНОВАНИЕ";

-- 2. For all COOP offices, determine the total number of orders carried out
SELECT О."ИДЕНТИФИКАТОР", О."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", COUNT(З."НОМЕР_ДОГОВОРА") AS "Общее_число_заказов"
FROM "ОТДЕЛЕНИЕ__КООП" О
LEFT JOIN "ЗАКУПКИ" З ON О."ИДЕНТИФИКАТОР" = З."ОТДЕЛЕНИЕ__КООП"
GROUP BY О."ИДЕНТИФИКАТОР", О."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО";

-- 3. find customers who purchased more than 80000 worth of goods in May at COOP branches with commissions of more than 3%
SELECT П."ФАМИЛИЯ"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
JOIN "ОТДЕЛЕНИЕ__КООП" О ON З."ОТДЕЛЕНИЕ__КООП" = О."ИДЕНТИФИКАТОР"
WHERE З."ДАТА" = 'Май' 
  AND О."КОМИССИОННЫЕ" > 3
GROUP BY П."ФАМИЛИЯ"
HAVING SUM(З."ИТОГО_RUB") > 80000; 


-- 4. In which months did the total number of orders exceed four
SELECT D."ИДЕНТИФИКАТОР", D."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", COUNT(P."НОМЕР_ДОГОВОРА") AS "Total_Orders"
FROM "ОТДЕЛЕНИЕ__КООП" D
LEFT JOIN "ЗАКУПКИ" P ON D."ИДЕНТИФИКАТОР" = P."ОТДЕЛЕНИЕ__КООП"
GROUP BY D."ИДЕНТИФИКАТОР", D."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО";