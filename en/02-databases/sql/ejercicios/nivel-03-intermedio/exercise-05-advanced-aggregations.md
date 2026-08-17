# Exercise 05 — Advanced Aggregations

- **Level:** 3/5
- **Topic:** GROUP BY with multiple functions, filters, and order
- **Estimated time:** 25 min

## Statement

The `orders` table records sales per product and per month (as text `'YYYY-MM'`).
Write a single query that, grouped by `month`, returns:

1. The month.
2. Number of orders (`COUNT`).
3. Total revenue (`SUM(amount)`).
4. The best-selling product of that month — use the product with the highest
   total amount via a window function or subquery.

Expected result for the sample data:
- `2024-01`: 2 orders, revenue 300, best product `Keyboard` (250)
- `2024-02`: 2 orders, revenue 380, best product `Keyboard` (200)

## Initial schema

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  product TEXT NOT NULL,
  month TEXT NOT NULL,
  amount REAL NOT NULL
);

INSERT INTO orders (product, month, amount) VALUES
  ('Mouse',    '2024-01', 50.0),
  ('Keyboard', '2024-01', 250.0),
  ('Monitor',  '2024-02', 180.0),
  ('Keyboard', '2024-02', 200.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Aggregate the basics with `GROUP BY month`.
- Hint 2: Use a window function `ROW_NUMBER() OVER (PARTITION BY month ORDER BY amount DESC)` in a CTE to pick the best product per month.
- Hint 3: Join the aggregated totals with the ranked rows.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
WITH ranked AS (
  SELECT month, product, amount,
         ROW_NUMBER() OVER (PARTITION BY month ORDER BY amount DESC) AS rn
  FROM orders
)
SELECT r.month,
       COUNT(o.id) AS num_orders,
       SUM(o.amount) AS total_revenue,
       r.product AS best_product
FROM orders o
JOIN ranked r ON r.month = o.month AND r.rn = 1
GROUP BY r.month, r.product;
````

</details>