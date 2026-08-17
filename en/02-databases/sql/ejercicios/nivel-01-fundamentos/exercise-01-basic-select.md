# Exercise 01 — Basic SELECT

- **Level:** 1/5
- **Topic:** SELECT, basic queries
- **Estimated time:** 15 min

## Statement

You have a `students` table. Write a query that:

1. Returns the **name** and **final_grade** of all students.
2. Then write a second query that returns **only the names**, showing each
   student exactly once (no duplicates).

Expected result (first query): three rows, each with a name and a grade.
Expected result (second query): three rows, each with just a name.

## Initial schema

```sql
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  final_grade REAL
);

INSERT INTO students (name, final_grade) VALUES
  ('Ana', 8.5),
  ('Bruno', 7.0),
  ('Carla', 9.2);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Use `SELECT name, final_grade FROM students;`
- Hint 2: Use `SELECT DISTINCT name FROM students;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT name, final_grade FROM students;

SELECT DISTINCT name FROM students;
````

</details>