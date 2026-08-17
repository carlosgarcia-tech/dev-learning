# Exercise 05 — Aliases and CASE

- **Level:** 2/5
- **Topic:** AS aliases, CASE expressions
- **Estimated time:** 20 min

## Statement

The `students` table has names and final grades (0–10). Write a query that
returns three columns for each student:

1. `name` (keep the original column name).
2. `grade` (the `final_grade` column, aliased).
3. `result` — a computed column using `CASE`: `'Passed'` if the grade is
   **greater than or equal to 6**, otherwise `'Failed'`.

Expected result: Ana → Passed (8.5), Bruno → Failed (5.0), Carla → Passed (7.5).

## Initial schema

```sql
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  final_grade REAL NOT NULL
);

INSERT INTO students (name, final_grade) VALUES
  ('Ana', 8.5),
  ('Bruno', 5.0),
  ('Carla', 7.5);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Alias with `AS`: `final_grade AS grade`.
- Hint 2: `CASE WHEN final_grade >= 6 THEN 'Passed' ELSE 'Failed' END AS result`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT
  name,
  final_grade AS grade,
  CASE WHEN final_grade >= 6 THEN 'Passed' ELSE 'Failed' END AS result
FROM students;
````

</details>