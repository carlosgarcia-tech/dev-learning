# Exercise 04 — Subqueries

- **Level:** 2/5
- **Topic:** Subqueries in WHERE
- **Estimated time:** 20 min

## Statement

The database has `employees` with `salary` and `department`. Write queries
that:

1. Return the name and salary of the employee(s) with the **highest salary**.
2. Return the name of every employee who earns **more than the average
   salary**.

Expected result for (1): Nadia (4200). Expected result for (2): Carla (3300),
Marta (3800), Nadia (4200) — all three earn more than the average of 3200.

## Initial schema

```sql
CREATE TABLE employees (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  department TEXT NOT NULL,
  salary REAL NOT NULL
);

INSERT INTO employees (name, department, salary) VALUES
  ('Ana', 'Sales', 2500.0),
  ('Bruno', 'IT', 2900.0),
  ('Carla', 'IT', 3300.0),
  ('Marta', 'Marketing', 3800.0),
  ('Nadia', 'Engineering', 4200.0),
  ('Otto', 'Support', 2500.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Use a subquery with `MAX(salary)` inside the `WHERE`.
- Hint 2: For (2), compare `salary > (SELECT AVG(salary) FROM employees)`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

SELECT name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
````

</details>