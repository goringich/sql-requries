# COOP Branch Database

## Project Overview

This project implements a **PostgreSQL** relational database for **COOP branches**, their consumers, products, and purchases. The database supports complex analytical queries using **SQL** features such as:

- Aggregate functions  
- `JOIN` operations  
- `EXISTS` and `NOT EXISTS`  
- `ALL` and `ANY` operators  
- `UNION`  

The database is optimized for managing and analyzing branch commissions, consumer purchases, and product inventory.

---

## Database Schema

### ОТДЕЛЕНИЕ__КООП (COOP Branch Information)

| **Column**                | **Type**               | **Description**                      |
|---------------------------|------------------------|--------------------------------------|
| `ИДЕНТИФИКАТОР`          | CHAR(3), PRIMARY KEY   | Branch unique identifier             |
| `ФАМИЛИЯ_ЗАВЕДУЮЩЕГО`    | VARCHAR(50), NOT NULL  | Branch manager's surname             |
| `АДРЕС`                  | VARCHAR(100), NOT NULL | Branch location address              |
| `КОМИССИОННЫЕ`           | DECIMAL(3,1), NOT NULL | Commission percentage (0-100%)       |

---

### ПОТРЕБИТЕЛЬ (Consumer Information)

| **Column**                | **Type**               | **Description**                      |
|---------------------------|------------------------|--------------------------------------|
| `ИДЕНТИФИКАТОР`          | CHAR(3), PRIMARY KEY   | Consumer unique identifier           |
| `ФАМИЛИЯ`                | VARCHAR(50), NOT NULL  | Consumer's surname                   |
| `АДРЕС`                  | VARCHAR(100), NOT NULL | Consumer's address                   |
| `КРЕДИТ`                 | DECIMAL(3,1), NOT NULL | Consumer's credit percentage (0-100) |

---

### ТОВАР (Product Information)

| **Column**                | **Type**               | **Description**                      |
|---------------------------|------------------------|--------------------------------------|
| `ИДЕНТИФИКАТОР`          | CHAR(3), PRIMARY KEY   | Product unique identifier            |
| `НАИМЕНОВАНИЕ`           | VARCHAR(100), NOT NULL | Product name                         |
| `ЦЕНА_1_ОЙ_ЕДИНИЦЫ`      | DECIMAL(10,2), NOT NULL| Price per unit                       |
| `СКЛАД`                  | VARCHAR(100), NOT NULL | Storage location                     |
| `МАКС_ЗАКАЗ`             | INTEGER, NOT NULL      | Maximum order quantity               |

---

### ЗАКУПКИ (Purchases)

| **Column**                | **Type**               | **Description**                      |
|---------------------------|------------------------|--------------------------------------|
| `НОМЕР_ДОГОВОРА`         | INTEGER, PRIMARY KEY   | Contract number                      |
| `ДАТА`                   | VARCHAR(20), NOT NULL  | Date of purchase                     |
| `ОТДЕЛЕНИЕ__КООП`        | CHAR(3), FOREIGN KEY   | Reference to COOP branch             |
| `ПОТРЕБИТЕЛЬ`            | CHAR(3), FOREIGN KEY   | Reference to consumer                |
| `ТОВАР`                  | CHAR(3), FOREIGN KEY   | Reference to product                 |
| `КОЛ_ВО`                 | INTEGER, NOT NULL      | Quantity purchased                   |
| `ИТОГО_RUB`              | DECIMAL(12,2), NOT NULL| Total purchase value                 |
| `КОМИССИОННЫЕ`           | DECIMAL(3,1)           | Commission percentage                |

---

## Setup Instructions

1. **Database Setup**  
   Ensure **PostgreSQL** is installed and a database is created:
   ```sql
   CREATE DATABASE coop_branch_db;
   ```

2. **Run Script**  
   Execute the SQL script provided in order, ensuring proper table creation and data insertion.

3. **Validate Tables**  
   Verify the structure and inserted data:
   ```sql
   SELECT * FROM "ОТДЕЛЕНИЕ__КООП";
   SELECT * FROM "ПОТРЕБИТЕЛЬ";
   SELECT * FROM "ТОВАР";
   SELECT * FROM "ЗАКУПКИ";
   ```

---

## Key SQL Queries

### Example 1: COOP Branches with High Commissions

**Find COOP branches that sold goods to all consumers from "Заволжье" and have commissions above average**:
```sql
SELECT О."ИДЕНТИФИКАТОР", О."ФАМИЛИЯ_ЗАВЕДУЮЩЕГО", О."КОМИССИОННЫЕ"
FROM "ОТДЕЛЕНИЕ__КООП" О
WHERE О."ИДЕНТИФИКАТОР" IN (
    SELECT З."ОТДЕЛЕНИЕ__КООП"
    FROM "ЗАКУПКИ" З
    JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
    WHERE П."АДРЕС" = 'Заволжье'
    GROUP BY З."ОТДЕЛЕНИЕ__КООП"
    HAVING COUNT(DISTINCT З."ПОТРЕБИТЕЛЬ") = (
        SELECT COUNT(*) 
        FROM "ПОТРЕБИТЕЛЬ" 
        WHERE "АДРЕС" = 'Заволжье'
    )
)
AND О."КОМИССИОННЫЕ" > (SELECT AVG("КОМИССИОННЫЕ") FROM "ОТДЕЛЕНИЕ__КООП");
```

---

### Example 2: Products Ordered by Consumers with Minimal Credit

**Count the number of distinct products ordered by consumers with the lowest credit**:
```sql
SELECT COUNT(DISTINCT З."ТОВАР") AS "Количество_товаров"
FROM "ЗАКУПКИ" З
JOIN "ПОТРЕБИТЕЛЬ" П ON З."ПОТРЕБИТЕЛЬ" = П."ИДЕНТИФИКАТОР"
WHERE П."КРЕДИТ" = (SELECT MIN("КРЕДИТ") FROM "ПОТРЕБИТЕЛЬ");
```

---

## Testing and Debugging

To verify data correctness:

1. **Check Table Contents**  
   Run simple `SELECT` queries:
   ```sql
   SELECT * FROM "ОТДЕЛЕНИЕ__КООП";
   SELECT * FROM "ПОТРЕБИТЕЛЬ";
   SELECT * FROM "ТОВАР";
   SELECT * FROM "ЗАКУПКИ";
   ```

2. **Run Analytical Queries**  
   Execute provided SQL queries for testing aggregated results, conditions, and constraints.

3. **Check for Consistency**  
   - Ensure foreign key relationships between tables are intact.  
   - Validate calculated values, such as commissions and total purchase amounts.

---

## Tools Used

- **Database:** PostgreSQL  
- **Editor:** VS Code, SQL client tools (pgAdmin, DBeaver, or psql CLI)  

---

