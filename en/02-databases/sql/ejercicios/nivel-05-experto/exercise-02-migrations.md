# Exercise 02 — Migrations

- **Level:** 5/5
- **Topic:** ALTER TABLE, schema evolution
- **Estimated time:** 25 min

## Statement

A `users` table already exists in production. You must evolve it without
dropping it. Perform these migrations in order:

1. Add a column `last_login TEXT` (nullable).
2. Add a column `email TEXT` and then enforce it as `UNIQUE`
   (the `UNIQUE` needs the column to exist and to not contain duplicates).
3. Rename the column `username` to `nickname`.
4. Verify the final structure with `PRAGMA table_info(users)` (SQLite) or
   `\d users` (PostgreSQL).

> Note: SQLite has limited support for `ALTER TABLE ... RENAME COLUMN`
> (supported from 3.25) and cannot add a `UNIQUE` constraint directly with
> `ALTER`; recreate the table or use a `UNIQUE` index instead.

## Initial schema

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT
);

INSERT INTO users (username, email) VALUES
  ('ana', 'ana@x.com'),
  ('bruno', 'bruno@x.com');
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `ALTER TABLE users ADD COLUMN last_login TEXT;`
- Hint 2: `ALTER TABLE users RENAME COLUMN username TO nickname;`
- Hint 3: For uniqueness on `email`, use `CREATE UNIQUE INDEX`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
ALTER TABLE users ADD COLUMN last_login TEXT;

ALTER TABLE users RENAME COLUMN username TO nickname;

CREATE UNIQUE INDEX idx_users_email ON users (email);

SELECT * FROM users;
````

The `email` column already existed in the sample; if it did not, first run
`ALTER TABLE users ADD COLUMN email TEXT;`. The `UNIQUE INDEX` guarantees
uniqueness, which is the portable approach in SQLite.

</details>