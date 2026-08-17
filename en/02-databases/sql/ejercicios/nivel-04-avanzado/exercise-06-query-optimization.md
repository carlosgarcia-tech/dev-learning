# Exercise 06 — Query Optimization

- **Level:** 4/5
- **Topic:** EXPLAIN, indexing strategy, avoiding full scans
- **Estimated time:** 30 min

## Statement

The `events` table holds log-like data and is queried in three ways:

1. `SELECT * FROM events WHERE user_id = 5;`
2. `SELECT * FROM events WHERE created_at > '2024-06-01';`
3. `SELECT * FROM events WHERE user_id = 5 AND created_at > '2024-06-01';`

Your tasks:

1. Run `EXPLAIN QUERY PLAN` on each query **before** creating indexes and note
   that all of them scan the whole table.
2. Create the indexes you think make all three queries efficient
   (think about a composite index).
3. Re-run `EXPLAIN QUERY PLAN` and verify that no query does a full scan.

## Initial schema

```sql
CREATE TABLE events (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  event_type TEXT NOT NULL,
  created_at TEXT NOT NULL
);

INSERT INTO events (user_id, event_type, created_at) VALUES
  (1, 'login',    '2024-05-01'),
  (2, 'purchase', '2024-06-15'),
  (5, 'login',    '2024-07-01'),
  (5, 'logout',   '2024-07-02'),
  (3, 'purchase', '2024-06-20');
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Create `idx_events_user` on `(user_id)` and `idx_events_user_date` on `(user_id, created_at)`.
- Hint 2: Query 2 is handled by an index on `(created_at)`.
- Hint 3: The composite `(user_id, created_at)` covers query 3 completely.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
EXPLAIN QUERY PLAN SELECT * FROM events WHERE user_id = 5;
EXPLAIN QUERY PLAN SELECT * FROM events WHERE created_at > '2024-06-01';
EXPLAIN QUERY PLAN SELECT * FROM events WHERE user_id = 5 AND created_at > '2024-06-01';

CREATE INDEX idx_events_user_id ON events (user_id);
CREATE INDEX idx_events_created_at ON events (created_at);
CREATE INDEX idx_events_user_date ON events (user_id, created_at);

EXPLAIN QUERY PLAN SELECT * FROM events WHERE user_id = 5;
EXPLAIN QUERY PLAN SELECT * FROM events WHERE created_at > '2024-06-01';
EXPLAIN QUERY PLAN SELECT * FROM events WHERE user_id = 5 AND created_at > '2024-06-01';
````

After the indexes, `EXPLAIN QUERY PLAN` reports `SEARCH ... USING INDEX ...`
for all three queries instead of `SCAN TABLE events`.

</details>