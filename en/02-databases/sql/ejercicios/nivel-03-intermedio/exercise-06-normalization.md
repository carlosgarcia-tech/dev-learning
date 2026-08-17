# Exercise 06 — Normalization

- **Level:** 3/5
- **Topic:** Design a 3NF schema
- **Estimated time:** 30 min

## Statement

The following table is **not normalized**. It stores a student and their
courses in a single row, repeating the course name for each student:

```sql
CREATE TABLE bad_enrollments (
  student_id INTEGER,
  student_name TEXT,
  course_id INTEGER,
  course_name TEXT,
  semester TEXT
);

INSERT INTO bad_enrollments VALUES
  (1, 'Ana', 101, 'Databases', '2024-01'),
  (2, 'Bruno', 102, 'Algebra', '2024-01'),
  (1, 'Ana', 102, 'Algebra', '2024-02');
```

Your task: **design and create** a normalized schema in **Third Normal Form
(3NF)** with tables `students`, `courses`, and `enrollments`, including the
appropriate primary and foreign keys. Then insert the same data split across
the three tables, and write a join that rebuilds the original list
(student name, course name, semester).

## Initial schema

```sql
-- Start from the "bad" table above; replace it with your normalized design.
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Students, courses, and enrollments are three separate entities.
- Hint 2: The enrollment is the link between a student and a course in a given semester.
- Hint 3: Rebuild with two joins.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
CREATE TABLE students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE courses (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE enrollments (
  student_id INTEGER REFERENCES students(id),
  course_id INTEGER REFERENCES courses(id),
  semester TEXT NOT NULL,
  PRIMARY KEY (student_id, course_id, semester)
);

INSERT INTO students (id, name) VALUES (1, 'Ana'), (2, 'Bruno');
INSERT INTO courses (id, name) VALUES (101, 'Databases'), (102, 'Algebra');
INSERT INTO enrollments (student_id, course_id, semester) VALUES
  (1, 101, '2024-01'),
  (2, 102, '2024-01'),
  (1, 102, '2024-02');

SELECT s.name, c.name, e.semester
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses c ON c.id = e.course_id;
````

</details>