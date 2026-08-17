# Capstone Projects — JavaScript

Three projects that combine everything from the five levels. They are meant to be built from scratch — the phases below are your roadmap, not a copy-paste checklist. Use **only the Node.js standard library** (`node:fs`, `node:http`, `node:path`, `node:assert`, `fetch`).

Order matters: project 1 is the easiest, project 3 the hardest. Each project builds on the previous one.

---

## Project 1 — Task Manager CLI

A full command-line application that manages tasks and persists them to a JSON file.

### Phase 1 — Core

- [ ] Commands: `add`, `list`, `done`, `remove`, `clear`, `help`
- [ ] Persistent storage in `tasks.json` (`load`/`save` helpers wrapping `fs`)
- [ ] Task shape: `{ id, title, done, createdAt }`
- [ ] Monotonic `nextId` so ids are never reused
- [ ] Friendly messages and correct exit codes (0 success, 1 error)

### Phase 2 — Sorting and filtering

- [ ] `list --all|--done|--pending` flag
- [ ] `list --sort title|date` flag
- [ ] `stats` command: totals, done count, pending count, percentage done

### Phase 3 — Robustness

- [ ] Recover from a corrupt `tasks.json` (back it up as `tasks.json.bak` and start fresh)
- [ ] Validate arguments; print usage on misuse
- [ ] `search <text>` finds tasks by substring (case-insensitive)

### Acceptance

- [ ] Running every command leaves a valid, readable `tasks.json`
- [ ] A full session works: add 3 tasks, mark 2 done, remove 1, verify with `list`

---

## Project 2 — REST API with File Storage

A small HTTP API (only `node:http`) with a JSON-file database, plus a basic authentication layer.

### Phase 1 — CRUD

- [ ] `GET /tasks`, `GET /tasks/:id`, `POST /tasks`, `PUT /tasks/:id`, `DELETE /tasks/:id`
- [ ] Persistence in `db.json` (tasks keyed by id)
- [ ] Proper status codes: 200, 201, 204, 400, 404
- [ ] JSON `Content-Type` on every response

### Phase 2 — Validation and search

- [ ] Validate `title` is a non-empty string on create/update (400 otherwise)
- [ ] `GET /tasks?done=true|false` filter
- [ ] `GET /tasks?q=<text>` substring search in titles

### Phase 3 — Auth and rate limiting

- [ ] `POST /login` with a fixed admin user returns a token (a random hex string)
- [ ] Protected routes require `Authorization: Bearer <token>` (401 otherwise)
- [ ] Naive rate limit: max 20 requests per minute per IP (429 when exceeded)

### Acceptance

- [ ] A full CRUD cycle works via `curl`
- [ ] Unauthenticated requests to protected routes return 401
- [ ] The server survives a corrupt `db.json` (returns 500 with a JSON error, not a crash)

---

## Project 3 — Simulated Full-Stack App

A "frontend" (HTML + JS run in the browser) that talks to your Node API. Everything runs locally on `localhost`.

### Phase 1 — Server + static files

- [ ] Server serves static files (`public/` folder) with the right `Content-Type` (`text/html`, `application/javascript`, `text/css`)
- [ ] Reuse your Project 2 API (tasks CRUD) on a port you choose

### Phase 2 — Frontend

- [ ] `index.html` renders the task list from `GET /tasks`
- [ ] Add a task via a form (POST) and re-render
- [ ] Toggle done / delete tasks (PUT / DELETE) with a confirm dialog on delete
- [ ] Show loading state and error messages in the UI

### Phase 3 — Real-time and polish

- [ ] Poll `GET /tasks` every 2 seconds and update the UI
- [ ] Client-side search box that filters without a server request
- [ ] Empty state ("No tasks yet") and a clear-all button
- [ ] Basic CSS so the layout is usable on mobile and desktop

### Acceptance

- [ ] Open `http://localhost:<port>/` in a browser and complete a full add → toggle → delete session
- [ ] Two browser tabs stay in sync (thanks to polling)
- [ ] Network or server errors show a friendly message, not a blank page

---

## General rubric

| Aspect | Check |
|--------|-------|
| Works with plain `node` | No external dependencies in `package.json` |
| Errors handled | `try`/`catch`, clear messages, no silent crashes |
| Code organization | Small functions/classes with a single responsibility |
| Readability | Meaningful names; consistent style |
| Runs on Node 18+ | Uses modern syntax (`const`/`let`, arrow functions, async/await) |

Good luck — and commit your work at the end of every phase.