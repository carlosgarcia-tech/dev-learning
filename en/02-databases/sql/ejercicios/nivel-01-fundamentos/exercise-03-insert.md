# Exercise 03 — INSERT

- **Level:** 1/5
- **Topic:** Inserting data
- **Estimated time:** 15 min

## Statement

The `employees` table is empty. Your tasks:

1. Insert the row `('Luis', 'Sales', 3200)`.
2. Insert two more employees in a single statement:
   `('Marta', 'Marketing', 2800)` and `('Nico', 'Engineering', 4100)`.
3. Write a query that returns all rows to verify.

Expected result: three rows with columns name, department, and salary.

## Initial schema

```sql
CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  department TEXT NOT NULL,
  salary REAL NOT NULL
);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `INSERT INTO employees (name, department, salary) VALUES (...);`
- Hint 2: You can list several `VALUES` separated by commas in one statement.
- Hint 3: Verify with `SELECT * FROM employees;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
INSERT INTO employees (name, department, salary)
VALUES ('Luis', 'Sales', 3200);

INSERT INTO employees (name, department, salary)
VALUES
  ('Marta', 'Marketing', 2800),
  ('Nico', 'Engineering', 4100);

SELECT * FROM employees;
````

</details>