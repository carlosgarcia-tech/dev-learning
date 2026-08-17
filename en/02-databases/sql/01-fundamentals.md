# SQL Fundamentals

## Goals

- [ ] Understand what SQL is and how a relational database is organized
- [ ] Write `SELECT` queries to read data
- [ ] Filter rows with `WHERE` and logical operators
- [ ] Sort results with `ORDER BY`
- [ ] Limit the number of rows returned with `LIMIT`
- [ ] Insert new rows with `INSERT`
- [ ] Modify existing rows with `UPDATE`
- [ ] Delete rows with `DELETE`
- [ ] Know the main SQL data types

## Notes

### What is SQL?

SQL (Structured Query Language) is the standard language used to interact with
relational databases. It lets you **create** the structure of the data
(DDL — Data Definition Language), **manipulate** the data itself
(DML — Data Manipulation Language), and **query** it.

### The basic anatomy of a query

A typical `SELECT` looks like this:

```text
SELECT column1, column2
FROM table_name
WHERE condition
ORDER BY column
LIMIT n;
```

- `SELECT` chooses which columns appear.
- `FROM` says which table(s) to read.
- `WHERE` filters rows before they are returned.
- `ORDER BY` sorts the result set.
- `LIMIT` (SQLite/PostgreSQL) restricts how many rows are returned.

### Filtering with WHERE

`WHERE` accepts conditions combined with logical operators:

- Comparison: `=`, `<>` (or `!=`), `>`, `<`, `>=`, `<=`
- Logical: `AND`, `OR`, `NOT`
- Ranges: `BETWEEN x AND y`
- Sets: `IN (a, b, c)`
- Patterns: `LIKE` (`%` matches any sequence, `_` matches a single character)
- Null checks: `IS NULL`, `IS NOT NULL`

### Data types

| Category | Examples (SQLite) | Examples (PostgreSQL) |
|---|---|---|
| Text | `TEXT` | `VARCHAR(n)`, `TEXT` |
| Integers | `INTEGER` | `INTEGER`, `BIGINT`, `SMALLINT` |
| Decimals | `REAL` | `NUMERIC(p,s)`, `REAL`, `DOUBLE PRECISION` |
| Date/time | `TEXT` (ISO) | `DATE`, `TIMESTAMP`, `TIME` |
| Boolean | `INTEGER` (0/1) | `BOOLEAN` |
| Blob/other | `BLOB` | `BYTEA`, `UUID`, `JSONB` |

### Modifying data

- `INSERT INTO table (cols) VALUES (...)` adds new rows.
- `UPDATE table SET col = value WHERE condition` changes existing rows —
  **always** add a `WHERE` unless you really want to update every row.
- `DELETE FROM table WHERE condition` removes rows — **always** add a `WHERE`.

## Code examples

```sql
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  age INTEGER,
  grade REAL
);

INSERT INTO students (name, age, grade) VALUES
  ('Ana', 21, 8.5),
  ('Bruno', 22, 7.0),
  ('Carla', 20, 9.2);

SELECT name, grade
FROM students
WHERE age >= 21 AND grade > 7.0
ORDER BY grade DESC
LIMIT 5;

UPDATE students SET grade = 9.0 WHERE name = 'Bruno';

DELETE FROM students WHERE id = 3;
```

## Related exercises

- [exercise-01-basic-select](ejercicios/nivel-01-fundamentos/exercise-01-basic-select.md)
- [exercise-02-where-and-order](ejercicios/nivel-01-fundamentos/exercise-02-where-and-order.md)
- [exercise-03-insert](ejercicios/nivel-01-fundamentos/exercise-03-insert.md)
- [exercise-04-update-and-delete](ejercicios/nivel-01-fundamentos/exercise-04-update-and-delete.md)
- [exercise-05-aggregate-functions](ejercicios/nivel-01-fundamentos/exercise-05-aggregate-functions.md)
- [exercise-06-like-and-filters](ejercicios/nivel-01-fundamentos/exercise-06-like-and-filters.md)

## Common mistakes

- Forgetting the `WHERE` clause on `UPDATE` / `DELETE` and wiping the whole table.
- Mixing up `=` (comparison) with `==`; SQL uses `=`.
- Using `!=` or `<>` interchangeably is fine, but forget they both exist.
- Comparing with `NULL` using `=` — it never matches; use `IS NULL`.
- Ordering by a column not present in `SELECT` (works in most databases, but be aware).
- Using `LIMIT` before `ORDER BY` semantics wrongly: sorting happens first, then truncation.

## Resources

- [SQLite documentation](https://www.sqlite.org/docs.html)
- [PostgreSQL documentation](https://www.postgresql.org/docs/)
- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)