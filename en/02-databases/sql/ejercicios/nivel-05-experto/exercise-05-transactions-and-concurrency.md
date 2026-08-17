# Exercise 05 — Transactions and Concurrency

- **Level:** 5/5
- **Topic:** Isolation, locking, avoiding race conditions
- **Estimated time:** 40 min

## Statement

Two sessions try to decrement a shared stock counter. The naive query is:

```sql
-- Session A and Session B both run something like:
UPDATE stock SET units = units - 1 WHERE product_id = 1;
```

1. Explain why this is safe: row-level locking (in PostgreSQL) makes the two
   updates serialize.
2. Simulate a scenario that **is** dangerous: a "read then write" pattern
   without protection:

```sql
-- 1. SELECT units FROM stock WHERE product_id = 1;   -- both read 5
-- 2. then later UPDATE ... SET units = 3 (the stale value)
```

3. Write the corrected version using a transaction with a pessimistic lock
   (`SELECT ... FOR UPDATE` in PostgreSQL), so the second session waits.

**Goal:** describe in the file comments what is happening and provide the
correct transactional SQL.

## Initial schema

```sql
CREATE TABLE stock (
  id INTEGER PRIMARY KEY,
  product_id INTEGER NOT NULL,
  units INTEGER NOT NULL
);

INSERT INTO stock (product_id, units) VALUES (1, 5);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `SELECT ... FOR UPDATE` locks the row until the transaction ends.
- Hint 2: Begin a transaction, lock, re-read, update, commit.
- Hint 3: SQLite serializes writes automatically; this exercise focuses on PostgreSQL semantics.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
-- Dangerous pattern (lost update):
-- Session A: SELECT units FROM stock WHERE product_id = 1;  -- 5
-- Session B: SELECT units FROM stock WHERE product_id = 1;  -- 5
-- Session A: UPDATE stock SET units = 4 WHERE product_id = 1;
-- Session B: UPDATE stock SET units = 4 WHERE product_id = 1;  -- lost update!

-- Correct version (PostgreSQL): pessimistic row lock
BEGIN;

SELECT units
FROM stock
WHERE product_id = 1
FOR UPDATE;                       -- other sessions wait here

-- Session A computes 5 - 1 = 4
UPDATE stock SET units = 4 WHERE product_id = 1;

COMMIT;

-- Session B can now proceed, seeing the committed value 4.
````

For SQLite, a single `UPDATE stock SET units = units - 1` is atomic because
SQLite serializes writers; the "read then write" pattern is the one to avoid.

</details>