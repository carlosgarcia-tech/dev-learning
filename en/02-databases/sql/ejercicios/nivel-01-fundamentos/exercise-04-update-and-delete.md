# Exercise 04 — UPDATE and DELETE

- **Level:** 1/5
- **Topic:** Modifying and removing data
- **Estimated time:** 15 min

## Statement

Using the `tasks` table, perform these operations **in order**:

1. Update task `id = 2` and mark it as `status = 'done'`.
2. Give every task in the `'Pending'` status a `priority = 'High'`.
3. Delete the task with `id = 4`.
4. Show the resulting table with `SELECT * FROM tasks;`.

Expected result: three rows remain (ids 1, 2, 3), task 2 is `done`, and any
remaining `'Pending'` task has `priority = 'High'`.

## Initial schema

```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT NOT NULL,
  priority TEXT NOT NULL
);

INSERT INTO tasks (title, status, priority) VALUES
  ('Write report', 'Pending', 'Medium'),
  ('Fix bug', 'In progress', 'High'),
  ('Deploy app', 'Pending', 'Low'),
  ('Old task', 'Done', 'Low');
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `UPDATE tasks SET status = 'done' WHERE id = 2;`
- Hint 2: For multiple rows: `UPDATE tasks SET priority = 'High' WHERE status = 'Pending';`
- Hint 3: `DELETE FROM tasks WHERE id = 4;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
UPDATE tasks SET status = 'done' WHERE id = 2;

UPDATE tasks SET priority = 'High' WHERE status = 'Pending';

DELETE FROM tasks WHERE id = 4;

SELECT * FROM tasks;
````

</details>