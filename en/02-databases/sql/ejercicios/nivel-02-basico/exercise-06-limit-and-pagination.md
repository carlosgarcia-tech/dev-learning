# Exercise 06 — LIMIT and Pagination

- **Level:** 2/5
- **Topic:** LIMIT, OFFSET, pagination
- **Estimated time:** 15 min

## Statement

The `articles` table contains 10 articles. Your tasks:

1. Return the 4 most recent articles (`created_at` descending).
2. Return the **next** 4 articles after those (i.e. page 2 of the list).
3. Return the last 2 articles (page 3).

Expected result: page 1 = articles 10, 9, 8, 7; page 2 = 6, 5, 4, 3;
page 3 = 2, 1.

## Initial schema

```sql
CREATE TABLE articles (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  created_at TEXT NOT NULL
);

INSERT INTO articles (title, created_at) VALUES
  ('Article 1',  '2024-01-01'),
  ('Article 2',  '2024-01-02'),
  ('Article 3',  '2024-01-03'),
  ('Article 4',  '2024-01-04'),
  ('Article 5',  '2024-01-05'),
  ('Article 6',  '2024-01-06'),
  ('Article 7',  '2024-01-07'),
  ('Article 8',  '2024-01-08'),
  ('Article 9',  '2024-01-09'),
  ('Article 10', '2024-01-10');
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Page 1: `ORDER BY created_at DESC LIMIT 4`.
- Hint 2: Page 2: add `OFFSET 4`; page 3: `OFFSET 8`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
-- Page 1
SELECT title, created_at
FROM articles
ORDER BY created_at DESC
LIMIT 4;

-- Page 2
SELECT title, created_at
FROM articles
ORDER BY created_at DESC
LIMIT 4 OFFSET 4;

-- Page 3
SELECT title, created_at
FROM articles
ORDER BY created_at DESC
LIMIT 4 OFFSET 8;
````

</details>