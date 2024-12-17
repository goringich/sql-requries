

# COOP Branch Database

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

## Key SQL Queries

### Example Query: COOP Branches with High Commissions

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

## Instructions for Use

1. Run the SQL script in a **PostgreSQL** environment.
2. Use table queries for validation:
    ```sql
    SELECT * FROM "ОТДЕЛЕНИЕ__КООП";
    SELECT * FROM "ПОТРЕБИТЕЛЬ";
    SELECT * FROM "ТОВАР";
    SELECT * FROM "ЗАКУПКИ";
    ```

3. Verify the structure and data integrity using `SELECT` queries provided.
