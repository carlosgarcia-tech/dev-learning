# Exercise 01 — Task Manager CLI

- **Level:** 5/5
- **Topic:** Mini CLI app with JSON file persistence
- **Estimated time:** 40 min

## Statement

Build a task manager CLI that persists tasks to a JSON file using `node:fs`.

Usage:

```text
node tasks.js add "Buy milk"
node tasks.js list
node tasks.js done 1
node tasks.js remove 1
node tasks.js clear
```

Behavior:

1. Store tasks in `tasks.json` (next to the script). Structure: `{ "nextId": 3, "tasks": [{ "id": 1, "title": "Buy milk", "done": false }] }`.
2. `add <title>` — creates the file if missing, appends a task, prints `Added: Buy milk (id 1)`.
3. `list` — prints each task as `1. [ ] Buy milk` or `1. [x] Buy milk`; if empty, prints `No tasks.`.
4. `done <id>` — marks the task done, prints `Done: <title>`; unknown id prints `Task <id> not found`.
5. `remove <id>` — deletes the task, prints `Removed: <title>`.
6. `clear` — empties the task list, prints `Cleared.`.
7. Write helper functions `loadTasks()` / `saveTasks(data)` that wrap `fs.readFileSync`/`fs.writeFileSync` in `try`/`catch` (JSON errors → return a fresh empty structure).

## Requirements

- [ ] Reads and writes `tasks.json` with `fs.readFileSync`/`fs.writeFileSync`
- [ ] Handles a missing or corrupt file (returns an empty structure, does not crash)
- [ ] Implements `add`, `list`, `done`, `remove`, `clear`
- [ ] Uses a monotonic `nextId` counter so ids are never reused
- [ ] `done`/`remove` report a clear error for unknown ids
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `fs.existsSync("tasks.json")` tells you whether to start fresh.
- Use `JSON.stringify(data, null, 2)` so the file is human-readable.
- `JSON.parse` throws on bad content — catch it and return `{ nextId: 1, tasks: [] }`.
- Print unknown-id errors to `console.error` and exit with code 1.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const fs = require("node:fs");
const path = require("node:path");

const FILE = path.join(__dirname, "tasks.json");
const EMPTY = { nextId: 1, tasks: [] };

function loadTasks() {
  try {
    if (!fs.existsSync(FILE)) return { ...EMPTY };
    const data = JSON.parse(fs.readFileSync(FILE, "utf8"));
    if (!Array.isArray(data.tasks)) return { ...EMPTY };
    return data;
  } catch {
    return { ...EMPTY };
  }
}

function saveTasks(data) {
  fs.writeFileSync(FILE, JSON.stringify(data, null, 2));
}

function add(title) {
  const data = loadTasks();
  const task = { id: data.nextId, title, done: false };
  data.tasks.push(task);
  data.nextId++;
  saveTasks(data);
  console.log(`Added: ${title} (id ${task.id})`);
}

function list() {
  const data = loadTasks();
  if (data.tasks.length === 0) {
    console.log("No tasks.");
    return;
  }
  for (const t of data.tasks) {
    console.log(`${t.id}. [${t.done ? "x" : " "}] ${t.title}`);
  }
}

function markDone(id) {
  const data = loadTasks();
  const task = data.tasks.find((t) => t.id === id);
  if (!task) {
    console.error(`Task ${id} not found`);
    process.exit(1);
  }
  task.done = true;
  saveTasks(data);
  console.log(`Done: ${task.title}`);
}

function remove(id) {
  const data = loadTasks();
  const index = data.tasks.findIndex((t) => t.id === id);
  if (index === -1) {
    console.error(`Task ${id} not found`);
    process.exit(1);
  }
  const [removed] = data.tasks.splice(index, 1);
  saveTasks(data);
  console.log(`Removed: ${removed.title}`);
}

function clear() {
  saveTasks({ ...EMPTY });
  console.log("Cleared.");
}

const command = process.argv[2];
const arg = process.argv.slice(3).join(" ");

switch (command) {
  case "add":
    if (!arg) {
      console.error("Usage: node tasks.js add <title>");
      process.exit(1);
    }
    add(arg);
    break;
  case "list":
    list();
    break;
  case "done":
    markDone(Number(arg));
    break;
  case "remove":
    remove(Number(arg));
    break;
  case "clear":
    clear();
    break;
  default:
    console.log(`Usage:
  node tasks.js add <title>
  node tasks.js list
  node tasks.js done <id>
  node tasks.js remove <id>
  node tasks.js clear`);
}
````

</details>