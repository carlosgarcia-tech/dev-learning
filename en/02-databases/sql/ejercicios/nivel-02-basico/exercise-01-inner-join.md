# Exercise 01 — INNER JOIN

- **Level:** 2/5
- **Topic:** Joining two tables
- **Estimated time:** 15 min

## Statement

The database has `authors` and `books`. Each book references its author via
`books.author_id`. Write a query that returns, for every book, the book title
and the author's name. Books without a matching author must **not** appear.

Expected result: 3 rows — `Dune / Frank Herbert`, `1984 / George Orwell`,
`The Hobbit / J.R.R. Tolkien`.

## Initial schema

```sql
CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  author_id INTEGER REFERENCES authors(id)
);

INSERT INTO authors (name) VALUES
  ('Frank Herbert'),
  ('George Orwell'),
  ('J.R.R. Tolkien');

INSERT INTO books (title, author_id) VALUES
  ('Dune', 1),
  ('1984', 2),
  ('The Hobbit', 3),
  ('Untitled', NULL);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `SELECT b.title, a.name FROM books b INNER JOIN authors a ON b.author_id = a.id;`
- Hint 2: `INNER JOIN` automatically excludes the book with `author_id = NULL`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT b.title, a.name
FROM books b
INNER JOIN authors a ON b.author_id = a.id;
````

</details>