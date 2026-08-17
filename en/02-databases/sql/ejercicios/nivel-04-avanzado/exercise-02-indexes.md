# Exercise 02 — Indexes

- **Level:** 4/5
- **Topic:** CREATE INDEX, UNIQUE INDEX, EXPLAIN QUERY PLAN
- **Estimated time:** 25 min

## Statement

The `orders` table is large and queried frequently by `customer_id`. Your
tasks:

1. Create an index on `orders.customer_id`.
2. Create a `UNIQUE` index on `orders.order_reference`.
3. Insert a duplicate `order_reference` and observe the failure
   (write it commented out).
4. Use `EXPLAIN QUERY PLAN` to check that a query filtering by
   `customer_id = 2` now uses the index instead of a full table scan.

Expected result: step 4 shows `SEARCH orders USING INDEX idx_orders_customer_id`.

## Initial schema

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  order_reference TEXT NOT NULL,
  customer_id INTEGER NOT NULL,
  total REAL NOT NULL
);

INSERT INTO orders (order_reference, customer_id, total) VALUES
  ('REF-001', 1, 25.0),
  ('REF-002', 2, 9.5),
  ('REF-003', 1, 40.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `CREATE INDEX idx_orders_customer_id ON orders (customer_id);`
- Hint 2: `CREATE UNIQUE INDEX idx_orders_reference ON orders (order_reference);`
- Hint 3: `EXPLAIN QUERY PLAN SELECT * FROM orders WHERE customer_id = 2;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

CREATE UNIQUE INDEX idx_orders_reference ON orders (order_reference);

-- This fails: duplicate value in a UNIQUE index
-- INSERT INTO orders (order_reference, customer_id, total)
-- VALUES ('REF-002', 3, 10.0);

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE customer_id = 2;
````

</details>