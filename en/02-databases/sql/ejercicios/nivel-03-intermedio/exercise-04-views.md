# Exercise 04 — Views

- **Level:** 3/5
- **Topic:** CREATE VIEW
- **Estimated time:** 20 min

## Statement

The `orders` table references products and customers. Your tasks:

1. Create a view named `order_summary` that shows, for every order:
   the order id, customer name, product name, quantity, and price,
   plus a computed `total` column (`price * quantity`).
2. Query the view to show the summary.
3. Drop the view afterward (to prove it is not a table).

Expected result: two rows with totals 500 and 600.

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
  customer_id INTEGER REFERENCES customers(id),
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL
);

INSERT INTO customers (name) VALUES ('Ana'), ('Bruno');
INSERT INTO products (name, price) VALUES ('Monitor', 500.0), ('Keyboard', 25.0);
INSERT INTO orders (customer_id, product_id, quantity) VALUES (1, 1, 1), (2, 2, 24);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `CREATE VIEW order_summary AS SELECT ...`
- Hint 2: Use `o.quantity * p.price AS total`.
- Hint 3: `SELECT * FROM order_summary;` then `DROP VIEW order_summary;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE VIEW order_summary AS
SELECT o.id AS order_id,
       c.name AS customer,
       p.name AS product,
       o.quantity,
       p.price,
       o.quantity * p.price AS total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN products p ON p.id = o.product_id;

SELECT * FROM order_summary;

DROP VIEW order_summary;
````

</details>