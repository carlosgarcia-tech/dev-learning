# Exercise 06 — LIKE and Filters

- **Level:** 1/5
- **Topic:** LIKE, BETWEEN, IN, NULL checks
- **Estimated time:** 20 min

## Statement

Using the `customers` table, write four queries:

1. Customers whose email contains `'@gmail.com'`.
2. Customers whose name **starts with** `'M'`.
3. Customers with an age **between 25 and 40** (inclusive).
4. Customers whose phone is **NULL**.

Expected results with the sample data: (1) Ana, (2) Marta and Marco,
(3) Marta and Joana, (4) Bruno.

## Initial schema

```sql
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  age INTEGER,
  phone TEXT
);

INSERT INTO customers (name, email, age, phone) VALUES
  ('Ana', 'ana@gmail.com', 22, '555-1000'),
  ('Bruno', 'bruno@outlook.com', 30, NULL),
  ('Marta', 'marta@gmail.com', 28, '555-2000'),
  ('Marco', 'marco@company.com', 41, '555-3000'),
  ('Joana', 'joana@yahoo.com', 37, NULL);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `WHERE email LIKE '%@gmail.com'`
- Hint 2: `WHERE name LIKE 'M%'`
- Hint 3: `WHERE age BETWEEN 25 AND 40`
- Hint 4: `WHERE phone IS NULL` — never `= NULL`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT * FROM customers WHERE email LIKE '%@gmail.com';
SELECT * FROM customers WHERE name LIKE 'M%';
SELECT * FROM customers WHERE age BETWEEN 25 AND 40;
SELECT * FROM customers WHERE phone IS NULL;
````

</details>