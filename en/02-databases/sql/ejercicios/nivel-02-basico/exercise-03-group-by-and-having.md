# Exercise 03 — GROUP BY and HAVING

- **Level:** 2/5
- **Topic:** Aggregating by group
- **Estimated time:** 20 min

## Statement

The `sales` table records one row per sale, with the product and its price.
Write queries that:

1. Count how many sales each product has and the total revenue per product.
2. Using `HAVING`, show only products with **total revenue greater than 60**.

Expected result for (2): Keyboard (110), Mouse (70), Headset (95).
`Monitor` is excluded (total 50).

## Initial schema

```sql
CREATE TABLE sales (
  id INTEGER PRIMARY KEY,
  product TEXT NOT NULL,
  amount REAL NOT NULL
);

INSERT INTO sales (product, amount) VALUES
  ('Keyboard', 60.0),
  ('Mouse', 40.0),
  ('Keyboard', 50.0),
  ('Headset', 95.0),
  ('Mouse', 30.0),
  ('Monitor', 50.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `SELECT product, COUNT(*), SUM(amount) FROM sales GROUP BY product;`
- Hint 2: Filter groups with `HAVING SUM(amount) > 60`, not `WHERE`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT product, COUNT(*) AS num_sales, SUM(amount) AS total_revenue
FROM sales
GROUP BY product;

SELECT product, SUM(amount) AS total_revenue
FROM sales
GROUP BY product
HAVING SUM(amount) > 60;
````

</details>