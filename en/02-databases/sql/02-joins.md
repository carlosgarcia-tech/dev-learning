# SQL Joins

## Goals

- [ ] Understand the role of primary and foreign keys in relationships
- [ ] Combine data from two tables with `INNER JOIN`
- [ ] Keep unmatched rows with `LEFT JOIN` and `RIGHT JOIN`
- [ ] Know what a `CROSS JOIN` produces
- [ ] Read a join as: `FROM table_a JOIN table_b ON condition`

## Notes

### Why join?

Relational databases store data in separate tables to avoid duplication
(normalization). A **join** reconstructs the full picture by linking rows
that share a related value — usually the foreign key column of one table and
the primary key column of another.

### Primary and foreign keys

- **Primary key (PK):** a column (or set of columns) that uniquely identifies
  each row. Example: `products.id`.
- **Foreign key (FK):** a column that references the PK of another table to
  express a relationship. Example: `orders.product_id` referencing
  `products.id`.

### INNER JOIN

Returns only rows where the join condition matches on **both** sides.

```sql
SELECT orders.id, products.name
FROM orders
INNER JOIN products ON orders.product_id = products.id;
```

If a product has no orders, or an order has no product, that row is excluded.

### LEFT JOIN

Returns all rows from the **left** table, plus the matching rows from the
right table. When there is no match, the right-side columns are `NULL`.

```sql
SELECT customers.name, orders.total
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.id;
```

Every customer appears; customers without orders show `NULL`.

### RIGHT JOIN

The mirror image of `LEFT JOIN`: all rows from the **right** table are kept,
with `NULL` on the left side when there is no match. SQLite does not support
`RIGHT JOIN` natively (as of version 3.39, it is accepted but unsupported);
PostgreSQL does. The recommended, portable practice is to reverse the tables
and use `LEFT JOIN`.

```sql
SELECT customers.name, orders.total
FROM orders
RIGHT JOIN customers ON orders.customer_id = customers.id;
```

### CROSS JOIN

Combines **every** row of the first table with **every** row of the second
(no condition). Useful for cartesian products, e.g. generating combinations.

```sql
SELECT a.color, b.size
FROM colors a
CROSS JOIN sizes b;
```

### Aliases

Use aliases (`AS` or implicit) to shorten names and disambiguate columns that
exist in both tables.

```sql
SELECT c.name, o.total
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.id;
```

## Code examples

```sql
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(id),
  total REAL NOT NULL
);

INSERT INTO customers (name) VALUES ('Ana'), ('Bruno'), ('Carla');
INSERT INTO orders (customer_id, total) VALUES (1, 25.0), (1, 9.5), (3, 40.0);

-- Only customers with orders
SELECT c.name, o.total
FROM customers c
INNER JOIN orders o ON o.customer_id = c.id;

-- All customers, with or without orders
SELECT c.name, o.total
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id;
```

## Related exercises

- [exercise-01-inner-join](ejercicios/nivel-02-basico/exercise-01-inner-join.md)
- [exercise-02-left-and-right-join](ejercicios/nivel-02-basico/exercise-02-left-and-right-join.md)
- [exercise-01-multiple-joins](ejercicios/nivel-03-intermedio/exercise-01-multiple-joins.md)

## Common mistakes

- Forgetting the `ON` condition and accidentally producing a `CROSS JOIN`.
- Confusing `LEFT JOIN` and `INNER JOIN`: with `INNER` you silently lose
  unmatched rows; with `LEFT` you keep them.
- Referring to a column without a table alias when both tables have the same
  column name (`id`, `name`, `created_at`...).
- Using `RIGHT JOIN` in SQLite and getting wrong results or errors.
- Joining on the wrong column (e.g. FK-to-FK instead of FK-to-PK), causing
  duplicated or missing rows.

## Resources

- [SQLite joins](https://www.sqlite.org/lang_select.html)
- [PostgreSQL joins](https://www.postgresql.org/docs/current/tutorial-join.html)
- [Visual guide to SQL joins](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)