# Exercise 01 — Constraints

- **Level:** 4/5
- **Topic:** PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL
- **Estimated time:** 25 min

## Statement

Create a `users` table and an `orders` table that enforce the following rules:

- `users.id`: `PRIMARY KEY`.
- `users.email`: `NOT NULL` and `UNIQUE`.
- `users.age`: `CHECK (age >= 18)`.
- `orders.id`: `PRIMARY KEY`.
- `orders.user_id`: `FOREIGN KEY` referencing `users(id)`, `NOT NULL`.
- `orders.amount`: `NOT NULL` and `CHECK (amount > 0)`.

Then verify each constraint by inserting **two valid rows**, and confirm that
the invalid inserts below are rejected (write them commented out, or run them
and observe the error).

```sql
-- Must fail:
-- INSERT INTO users (email, age) VALUES (NULL, 20);              -- NOT NULL
-- INSERT INTO users (email, age) VALUES ('a@x.com', 15);         -- CHECK age
-- INSERT INTO orders (user_id, amount) VALUES (999, 10.0);       -- FK missing
-- INSERT INTO orders (user_id, amount) VALUES (1, 0);            -- CHECK amount
```

## Initial schema

```sql
-- Create the tables yourself following the rules above.
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Inline constraints: `email TEXT NOT NULL UNIQUE`.
- Hint 2: Table-level FK: `user_id INTEGER REFERENCES users(id)`.
- Hint 3: `CHECK` goes inline after the column type.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  age INTEGER CHECK (age >= 18)
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  amount REAL NOT NULL CHECK (amount > 0)
);

INSERT INTO users (email, age) VALUES ('ana@x.com', 25), ('bruno@x.com', 30);
INSERT INTO orders (user_id, amount) VALUES (1, 50.0), (2, 12.5);
````

All four invalid inserts are rejected by the database engine.

</details>