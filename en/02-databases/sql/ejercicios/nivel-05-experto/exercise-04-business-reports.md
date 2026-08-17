# Exercise 04 — Business Reports

- **Level:** 5/5
- **Topic:** Reporting queries with window functions and CTEs
- **Estimated time:** 40 min

## Statement

The `sales` table records one row per sale: date, product, and amount. As a
business analyst, produce three reports:

1. **Daily revenue** for each date (sum of amounts grouped by date).
2. **Cumulative revenue** over time: for each date, the running total of all
   sales up to and including that date (use a window function with
   `ORDER BY` inside the `SUM(...) OVER (...)`).
3. **Product rank within each day**: number each product sale per day from
   highest to lowest amount using `RANK()` partitioned by date.

Expected results:
(1) `2024-01-01`: 300, `2024-01-02`: 210, `2024-01-03`: 90.
(2) cumulative: 300, 510, 600.
(3) ranks per date as computed by the window.

## Initial schema

```sql
CREATE TABLE sales (
  id INTEGER PRIMARY KEY,
  sale_date TEXT NOT NULL,
  product TEXT NOT NULL,
  amount REAL NOT NULL
);

INSERT INTO sales (sale_date, product, amount) VALUES
  ('2024-01-01', 'Keyboard', 200.0),
  ('2024-01-01', 'Mouse',    100.0),
  ('2024-01-02', 'Monitor',  180.0),
  ('2024-01-02', 'Keyboard',  30.0),
  ('2024-01-03', 'Mouse',     90.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Report 1: `SELECT sale_date, SUM(amount) FROM sales GROUP BY sale_date;`
- Hint 2: Report 2: `SUM(amount) OVER (ORDER BY sale_date)` gives a running total.
- Hint 3: Report 3: `RANK() OVER (PARTITION BY sale_date ORDER BY amount DESC)`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
-- 1. Daily revenue
SELECT sale_date, SUM(amount) AS daily_revenue
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- 2. Cumulative revenue
SELECT DISTINCT sale_date,
       SUM(amount) OVER (ORDER BY sale_date) AS cumulative_revenue
FROM sales;

-- 3. Rank of each sale within its day
SELECT sale_date, product, amount,
       RANK() OVER (PARTITION BY sale_date ORDER BY amount DESC) AS daily_rank
FROM sales;
````

</details>