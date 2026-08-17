# SQL Indexes

## Goals

- [ ] Understand what an index is and why it exists
- [ ] Create indexes with `CREATE INDEX`
- [ ] Know when to create an index and when to avoid it
- [ ] Read an execution plan with `EXPLAIN`
- [ ] Recognize composite indexes and their ordering caveats

## Notes

### What is an index?

An index is a data structure (typically a **B-tree**) that lets the database
find rows quickly without scanning the whole table. Think of it like the
alphabetical index at the back of a book: you jump straight to the page
instead of reading every page.

### Without an index

Without an index, a `WHERE` on a non-key column forces a **full table scan**:
the database reads every row to find matches. That is fine on 100 rows and
painful on 10 million.

### How to create an index

```sql
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
```

- The index name is optional in most databases but recommended.
- A `UNIQUE` index additionally enforces that values do not repeat:

```sql
CREATE UNIQUE INDEX idx_users_email ON users (email);
```

- An index is used automatically; you do not write it into the query.

### When to create an index

Good candidates — columns that appear often in:

- `WHERE` filters
- `JOIN` conditions (especially foreign keys)
- `ORDER BY` and `GROUP BY`
- `UNIQUE` constraints (the constraint itself creates an index)

Bad candidates:

- Low-cardinality columns (e.g. a boolean `is_active`) — an index that
  matches 50% of rows is usually ignored.
- Tables that are written to far more than they are read (every `INSERT`,
  `UPDATE`, and `DELETE` must also maintain the index).
- Tiny tables, where a full scan is faster.

### Composite indexes

An index on multiple columns, `(a, b)`, helps queries that use `a` alone or
`a AND b`, but not `b` alone — the leftmost prefix rule.

### EXPLAIN

`EXPLAIN` (and `EXPLAIN QUERY PLAN` in SQLite) shows how the database plans
to execute the query, revealing whether it uses an index or scans the table.

```sql
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE customer_id = 7;
```

A scan line like `SEARCH orders USING INDEX idx_orders_customer_id (...)` means
the index is being used. `SCAN TABLE orders` means it is not.

## Code examples

```sql
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  total REAL NOT NULL,
  created_at TEXT NOT NULL
);

-- Index for the foreign key
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- Index for sorting by date
CREATE INDEX idx_orders_created_at ON orders (created_at);

-- Composite index: customer + date
CREATE INDEX idx_orders_customer_date ON orders (customer_id, created_at);

-- Check whether the index is used
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE customer_id = 42;

-- Remove an index you no longer need
DROP INDEX idx_orders_created_at;
```

## Related exercises

- [exercise-02-indexes](ejercicios/nivel-04-avanzado/exercise-02-indexes.md)
- [exercise-06-query-optimization](ejercicios/nivel-04-avanzado/exercise-06-query-optimization.md)

## Common mistakes

- Creating an index "just in case" on every column — each one slows down writes
  and consumes disk space.
- Expecting an index on `(a, b)` to help a query filtered only on `b`.
- Creating indexes on columns with very few distinct values.
- Forgetting that `UNIQUE` constraints already create an index.
- Indexing expressions blindly without first checking `EXPLAIN`.
- Using `LIKE '%text'` and expecting a normal B-tree index to help — a leading
  wildcard defeats the index.

## Resources

- [SQLite indexes](https://www.sqlite.org/optoverview.html)
- [PostgreSQL indexes](https://www.postgresql.org/docs/current/indexes.html)
- [Use the index, Luke](https://use-the-index-luke.com/)