# Exercise 01 — Schema Modeling

- **Level:** 5/5
- **Topic:** Designing a normalized relational schema
- **Estimated time:** 35 min

## Statement

Design and create a complete schema for a small **library**. Requirements:

- A **book** has a title, an ISBN (unique), a publication year, and belongs to
  a **genre**.
- An **author** has a name; a book can have several authors, and an author can
  write several books (many-to-many).
- A **member** has a name and an email (unique).
- A **loan** records which member borrowed which book and on what date; a book
  is loaned at most once at a time (track a return date).

Create all tables with proper primary keys, foreign keys, unique constraints,
and a junction table for book–author. Then insert sample data and write one
query that lists all books with their authors and genre.

## Initial schema

```sql
-- Design the tables yourself.
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `genres`, `authors`, `books`, `book_authors` (junction), `members`, `loans`.
- Hint 2: The junction table has a composite `PRIMARY KEY (book_id, author_id)`.
- Hint 3: Rebuild the list with three joins.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE TABLE genres (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  isbn TEXT NOT NULL UNIQUE,
  year INTEGER,
  genre_id INTEGER REFERENCES genres(id)
);

CREATE TABLE book_authors (
  book_id INTEGER REFERENCES books(id),
  author_id INTEGER REFERENCES authors(id),
  PRIMARY KEY (book_id, author_id)
);

CREATE TABLE members (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE
);

CREATE TABLE loans (
  id INTEGER PRIMARY KEY,
  book_id INTEGER REFERENCES books(id),
  member_id INTEGER REFERENCES members(id),
  loan_date TEXT NOT NULL,
  return_date TEXT
);

INSERT INTO genres (name) VALUES ('Fantasy'), ('History');
INSERT INTO authors (name) VALUES ('J.R.R. Tolkien'), ('Yuval Noah Harari');
INSERT INTO books (title, isbn, year, genre_id) VALUES
  ('The Hobbit', '978-0-00-000001-1', 1937, 1),
  ('Sapiens',    '978-0-00-000002-8', 2011, 2);
INSERT INTO book_authors (book_id, author_id) VALUES (1, 1), (2, 2);
INSERT INTO members (name, email) VALUES ('Ana', 'ana@x.com');
INSERT INTO loans (book_id, member_id, loan_date) VALUES (1, 1, '2024-03-01');

SELECT b.title, g.name AS genre, a.name AS author
FROM books b
JOIN genres g ON g.id = b.genre_id
JOIN book_authors ba ON ba.book_id = b.id
JOIN authors a ON a.id = ba.author_id;
````

</details>