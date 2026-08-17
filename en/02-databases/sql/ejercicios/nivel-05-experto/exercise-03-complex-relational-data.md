# Exercise 03 — Complex Relational Data

- **Level:** 5/5
- **Topic:** Multi-table queries with aggregates and filters
- **Estimated time:** 35 min

## Statement

The database models **customers, orders, order_items, and products**. Write
queries that:

1. List each customer with the **total amount spent** (sum of
   `price * quantity` across their orders' items).
2. Show only customers who have spent **more than 100**.
3. List the **top product** by quantity sold.

Expected results:
(1) Ana spent 140, Bruno spent 85.
(2) Only Ana qualifies (total > 100).
(3) Top product by quantity: `Mouse` (5 units).

## Initial schema

```sql
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(id)
);

CREATE TABLE order_items (
  id INTEGER PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL
);

INSERT INTO customers (name) VALUES ('Ana'), ('Bruno');
INSERT INTO products (name, price) VALUES ('Keyboard', 25.0), ('Mouse', 30.0);
INSERT INTO orders (customer_id) VALUES (1), (1), (2);
INSERT INTO order_items (order_id, product_id, quantity) VALUES
  (1, 1, 2),
  (2, 2, 3),
  (3, 1, 1),
  (3, 2, 2);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Join all four tables, then `GROUP BY c.id, c.name`.
- Hint 2: Filter groups with `HAVING SUM(...) > 100`.
- Hint 3: Sum `quantity` grouped by product, order descending, take `LIMIT 1`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
-- 1. Total spent per customer
SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
GROUP BY c.id, c.name;

-- 2. Only customers who spent more than 100
SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
GROUP BY c.id, c.name
HAVING SUM(p.price * oi.quantity) > 100;

-- 3. Top product by quantity sold
SELECT p.name, SUM(oi.quantity) AS qty_sold
FROM order_items oi
JOIN products p ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY qty_sold DESC
LIMIT 1;
````

</details>