# Exercise 02 — Window Functions

- **Level:** 3/5
- **Topic:** ROW_NUMBER, RANK, LAG, LEAD
- **Estimated time:** 30 min

## Statement

The `employee_sales` table records one row per employee and their sales for a
quarter. Write queries that:

1. Assign a `ROW_NUMBER` to employees ordered by sales **descending**.
2. Assign a `RANK` using the same ordering.
3. For each employee, show the sales of the **previous** employee in the same
   ranking (use `LAG`) and the **next** one (use `LEAD`).

Note how `ROW_NUMBER` and `RANK` differ when there are ties.

## Initial schema

```sql
CREATE TABLE employee_sales (
  id INTEGER PRIMARY KEY,
  employee TEXT NOT NULL,
  sales REAL NOT NULL
);

INSERT INTO employee_sales (employee, sales) VALUES
  ('Ana', 120.0),
  ('Bruno', 90.0),
  ('Carla', 90.0),
  ('Diego', 150.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `ROW_NUMBER() OVER (ORDER BY sales DESC)` numbers rows 1, 2, 3, 4.
- Hint 2: `RANK()` gives 1, 2, 2, 4 — ties share the same rank and skip.
- Hint 3: `LAG(sales) OVER (ORDER BY sales DESC)` reads the previous row; `LEAD` reads the next.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT employee, sales,
  ROW_NUMBER() OVER (ORDER BY sales DESC) AS row_num,
  RANK()       OVER (ORDER BY sales DESC) AS rank
FROM employee_sales;

SELECT employee, sales,
  LAG(sales)  OVER (ORDER BY sales DESC) AS previous_sales,
  LEAD(sales) OVER (ORDER BY sales DESC) AS next_sales
FROM employee_sales;
````

</details>