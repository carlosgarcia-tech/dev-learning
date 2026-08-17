# Exercise 06 — Mini CRM

- **Level:** 5/5
- **Topic:** Final project — full schema plus report queries
- **Estimated time:** 60 min

## Statement

Build a **mini CRM** for a small business. Requirements:

- **customers**: id, name, email (unique), joined_date.
- **products**: id, name, price, stock.
- **orders**: id, customer_id (FK), order_date, status
  (`'pending'`, `'paid'`, `'shipped'`, `'cancelled'`).
- **order_items**: order_id (FK), product_id (FK), quantity, unit_price.
- An order references a customer; items reference the order and a product.

After creating the schema and inserting sample data, write these reports:

1. Total revenue per status (sum of `quantity * unit_price`).
2. The 3 best customers by revenue (with a `LIMIT` and a join/aggregate).
3. Products that have **never been sold** (a `LEFT JOIN` with `WHERE ... IS NULL`).

## Initial schema

```sql
-- Design and create the schema yourself, then insert sample data.
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Report 1: join `orders` + `order_items`, `GROUP BY status`.
- Hint 2: Report 2: group by customer, sum, order desc, `LIMIT 3`.
- Hint 3: Report 3: `LEFT JOIN` products to items and filter `NULL`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  joined_date TEXT NOT NULL
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  stock INTEGER NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL REFERENCES customers(id),
  order_date TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'))
);

CREATE TABLE order_items (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  product_id INTEGER NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL
);

INSERT INTO customers (name, email, joined_date) VALUES
  ('Ana', 'ana@x.com', '2023-01-01'),
  ('Bruno', 'bruno@x.com', '2023-02-01'),
  ('Carla', 'carla@x.com', '2023-03-01');

INSERT INTO products (name, price, stock) VALUES
  ('Keyboard', 25.0, 10),
  ('Mouse', 15.0, 20),
  ('Monitor', 180.0, 5),
  ('Webcam', 40.0, 0);

INSERT INTO orders (customer_id, order_date, status) VALUES
  (1, '2024-01-10', 'paid'),
  (2, '2024-01-12', 'shipped'),
  (1, '2024-02-01', 'cancelled');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 2, 25.0),
  (1, 2, 1, 15.0),
  (2, 3, 1, 180.0),
  (3, 4, 1, 40.0);

-- 1. Revenue per status
SELECT o.status, SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.status;

-- 2. Top 3 customers by revenue
SELECT c.name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id, c.name
ORDER BY revenue DESC
LIMIT 3;

-- 3. Products never sold
SELECT p.name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.id
WHERE oi.id IS NULL;
````

</details>