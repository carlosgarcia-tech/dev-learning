# Exercise 01 — Multiple Joins

- **Level:** 3/5
- **Topic:** Joining three or more tables
- **Estimated time:** 20 min

## Statement

The database has `orders`, `customers`, and `products`. An order belongs to a
customer (`customer_id`) and contains a product (`product_id`). Write a query
that returns, for each order: the order id, the customer's name, the product
name, and the quantity.

Expected result: 4 rows, one per order.

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

INSERT INTO customers (name) VALUES ('Ana'), ('Bruno'), ('Carla');

INSERT INTO products (name, price) VALUES
  ('Keyboard', 25.0),
  ('Mouse', 15.0),
  ('Monitor', 180.0);

INSERT INTO orders (customer_id, product_id, quantity) VALUES
  (1, 1, 2),
  (1, 3, 1),
  (2, 2, 5),
  (3, 1, 1);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Chain two joins: `FROM orders o JOIN customers c ON ... JOIN products p ON ...`
- Hint 2: Use aliases (`o`, `c`, `p`) to keep the query readable.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT o.id AS order_id, c.name AS customer, p.name AS product, o.quantity
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN products p ON p.id = o.product_id;
````

</details>