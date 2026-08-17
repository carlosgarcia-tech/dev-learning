# Exercise 02 — LEFT and RIGHT JOIN

- **Level:** 2/5
- **Topic:** LEFT JOIN, RIGHT JOIN, unmatched rows
- **Estimated time:** 15 min

## Statement

The database has `departments` and `employees`. Every employee belongs to one
department, but some departments have no employees yet.

1. Write a query using `LEFT JOIN` that returns every department name with the
   names of its employees. Departments without employees must appear with
   `NULL`.
2. Explain which departments show `NULL` in the result.

Expected result: 4 department rows — HR with Ana, Engineering with Bruno and
Carla, Marketing with NULL (no employees), and Finance with NULL.

## Initial schema

```sql
CREATE TABLE departments (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  department_id INTEGER REFERENCES departments(id)
);

INSERT INTO departments (name) VALUES
  ('HR'),
  ('Engineering'),
  ('Marketing'),
  ('Finance');

INSERT INTO employees (name, department_id) VALUES
  ('Ana', 1),
  ('Bruno', 2),
  ('Carla', 2);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `SELECT d.name, e.name FROM departments d LEFT JOIN employees e ON e.department_id = d.id;`
- Hint 2: Marketing and Finance have no employees, so the employee column is `NULL`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT d.name AS department, e.name AS employee
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id;
````

Marketing and Finance appear with `NULL` in the employee column because no
employee references them. The equivalent with `RIGHT JOIN` would swap the
tables: `FROM employees e RIGHT JOIN departments d ON e.department_id = d.id;`

</details>