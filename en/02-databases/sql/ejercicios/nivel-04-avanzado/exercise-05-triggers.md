# Exercise 05 — Triggers

- **Level:** 4/5
- **Topic:** CREATE TRIGGER (SQLite and PostgreSQL syntax)
- **Estimated time:** 30 min

## Statement

The `orders` table records sales. Whenever a new order is inserted, you want to
automatically log it into the `order_log` table with the current timestamp.

1. Create a `orders_audit` table with columns `order_id`, `action`,
   `logged_at`.
2. Create a trigger on `orders` that fires **after insert** and inserts a row
   into `orders_audit` with the new order id and the action `'INSERTED'`.
3. Insert an order and verify that the audit row appears automatically.

## Initial schema

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  product TEXT NOT NULL,
  amount REAL NOT NULL
);

CREATE TABLE orders_audit (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  logged_at TEXT NOT NULL
);

INSERT INTO orders (product, amount) VALUES ('Keyboard', 25.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: SQLite: `CREATE TRIGGER trg_orders_insert AFTER INSERT ON orders BEGIN INSERT INTO orders_audit (...) VALUES (...); END;`
- Hint 2: PostgreSQL: use `CREATE OR REPLACE FUNCTION` + `CREATE TRIGGER ... AFTER INSERT ... FOR EACH ROW EXECUTE FUNCTION ...`
- Hint 3: In PostgreSQL, use `datetime('now')` analog: `now()`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
-- SQLite
CREATE TRIGGER trg_orders_insert
AFTER INSERT ON orders
BEGIN
  INSERT INTO orders_audit (order_id, action, logged_at)
  VALUES (NEW.id, 'INSERTED', datetime('now'));
END;

INSERT INTO orders (product, amount) VALUES ('Mouse', 15.0);

SELECT * FROM orders_audit;
````

````sql
-- PostgreSQL
CREATE OR REPLACE FUNCTION log_order_insert()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO orders_audit (order_id, action, logged_at)
  VALUES (NEW.id, 'INSERTED', now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_orders_insert
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION log_order_insert();

INSERT INTO orders (product, amount) VALUES ('Mouse', 15.0);

SELECT * FROM orders_audit;
````

</details>