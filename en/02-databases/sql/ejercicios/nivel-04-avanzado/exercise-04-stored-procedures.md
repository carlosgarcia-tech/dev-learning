# Exercise 04 — Stored Procedures

- **Level:** 4/5
- **Topic:** Stored procedures / functions (PostgreSQL), portability note
- **Estimated time:** 30 min

## Statement

Stored procedures are **not** supported by SQLite. In PostgreSQL, create a
function `add_employee(p_name TEXT, p_department TEXT, p_salary REAL)` that
inserts a row into `employees` and returns the new employee's id. Then call it
twice to insert `('Rita', 'Sales', 3100)` and `('Sergio', 'IT', 3600)`, and
verify with a `SELECT`.

> Note for SQLite learners: skip the function creation and just do the
> `INSERT` statements; the goal is to understand how to encapsulate logic in
> the database.

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

- Hint 1: Use `CREATE OR REPLACE FUNCTION ... RETURNS INTEGER AS $$ ... $$ LANGUAGE plpgsql;`
- Hint 2: Inside, `INSERT ... RETURNING id;` is the idiomatic way to get the id.
- Hint 3: Call with `SELECT add_employee('Rita', 'Sales', 3100);`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE OR REPLACE FUNCTION add_employee(p_name TEXT, p_department TEXT, p_salary REAL)
RETURNS INTEGER AS $$
DECLARE new_id INTEGER;
BEGIN
  INSERT INTO employees (name, department, salary)
  VALUES (p_name, p_department, p_salary)
  RETURNING id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql;

SELECT add_employee('Rita', 'Sales', 3100);
SELECT add_employee('Sergio', 'IT', 3600);

SELECT * FROM employees;
````

For SQLite (no stored procedures), the equivalent is simply:

````sql
INSERT INTO employees (name, department, salary) VALUES
  ('Rita', 'Sales', 3100),
  ('Sergio', 'IT', 3600);
````

</details>