# Exercise 05 — Aggregate Functions

- **Level:** 1/5
- **Topic:** COUNT, SUM, AVG, MIN, MAX
- **Estimated time:** 20 min

## Statement

Using the `sales` table, write five queries (one per function):

1. Total number of sales (`COUNT`).
2. Sum of all `amount` values (`SUM`).
3. Average `amount` (`AVG`).
4. Minimum `amount` (`MIN`).
5. Maximum `amount` (`MAX`).

Expected results with the sample data: 4 sales, total 1570, average 392.5,
minimum 120, maximum 650.

## Initial schema

```sql
CREATE TABLE sales (
  id INTEGER PRIMARY KEY,
  product TEXT NOT NULL,
  amount REAL NOT NULL
);

INSERT INTO sales (product, amount) VALUES
  ('Keyboard', 250.0),
  ('Mouse', 120.0),
  ('Monitor', 550.0),
  ('Headset', 650.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `SELECT COUNT(*) FROM sales;`
- Hint 2: `SUM(amount)` sums, `AVG(amount)` averages, `MIN`/`MAX` find extremes.
- Hint 3: Combine them: `SELECT COUNT(*), SUM(amount), AVG(amount), MIN(amount), MAX(amount) FROM sales;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT COUNT(*) FROM sales;
SELECT SUM(amount) FROM sales;
SELECT AVG(amount) FROM sales;
SELECT MIN(amount) FROM sales;
SELECT MAX(amount) FROM sales;

-- Or all at once:
SELECT COUNT(*), SUM(amount), AVG(amount), MIN(amount), MAX(amount)
FROM sales;
````

</details>