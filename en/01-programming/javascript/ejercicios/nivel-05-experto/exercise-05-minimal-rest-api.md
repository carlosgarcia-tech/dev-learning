# Exercise 05 — Minimal REST API

- **Level:** 5/5
- **Topic:** GET/POST API in pure Node
- **Estimated time:** 45 min

## Statement

Build a minimal REST API for a "notes" resource using only `node:http` and `node:fs`, persisting to `notes.json`.

Routes:

- `GET /notes` → `200` with JSON array of all notes.
- `GET /notes/:id` → `200` with that note, or `404` `{"error":"not found"}`.
- `POST /notes` → read the JSON body `{ "title": "...", "content": "..." }`, create a note with `id`, `createdAt`, save, and respond `201` with the new note.
- Any other route → `404` `{"error":"not found"}`.

Details:

1. Load/save with `fs.readFileSync`/`fs.writeFileSync` on `notes.json`, handling a missing file as an empty list.
2. Read the POST body with `req.on("data", ...)` and `req.on("end", ...)` accumulated into a buffer; parse JSON in `try`/`catch` and respond `400` `{"error":"invalid JSON"}` on failure.
3. Route the URL with `URL(req.url, ...)` and match `pathname` with a regex like `/^\/notes\/(\d+)$/`.
4. Send JSON responses with the `Content-Type: application/json` header and `res.end(JSON.stringify(...))`.
5. Test with `curl`:

```text
curl -X POST localhost:3000/notes -H "Content-Type: application/json" -d '{"title":"hello","content":"world"}'
curl localhost:3000/notes
curl localhost:3000/notes/1
curl localhost:3000/notes/999
```

## Requirements

- [ ] Handles GET list, GET by id, POST create, and 404 fallback
- [ ] Reads the request body with stream events (`data`/`end`)
- [ ] Returns proper status codes (200/201/400/404)
- [ ] Persists to `notes.json` between requests
- [ ] Responds with `application/json` content type on all API routes
- [ ] Run it locally with `node` and verify with `curl`

## Hints

<details>
<summary>Show hints</summary>

- Match the id route before the fallback: `const match = url.pathname.match(/^\/notes\/(\d+)$/);`
- Body reading: `req.on("data", (chunk) => chunks.push(chunk)); req.on("end", () => { const body = JSON.parse(Buffer.concat(chunks).toString()); ... });`
- For `POST`, return `201` and `Location` header optionally.
- `notes.json` stores `{ "nextId": 1, "notes": [] }`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");

const FILE = path.join(__dirname, "notes.json");

function load() {
  try {
    if (!fs.existsSync(FILE)) return { nextId: 1, notes: [] };
    const data = JSON.parse(fs.readFileSync(FILE, "utf8"));
    if (!Array.isArray(data.notes)) return { nextId: 1, notes: [] };
    return data;
  } catch {
    return { nextId: 1, notes: [] };
  }
}

function save(data) {
  fs.writeFileSync(FILE, JSON.stringify(data, null, 2));
}

function send(res, status, body) {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(body));
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on("data", (chunk) => chunks.push(chunk));
    req.on("end", () => {
      try {
        resolve(JSON.parse(Buffer.concat(chunks).toString() || "{}"));
      } catch {
        reject(new Error("invalid JSON"));
      }
    });
  });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, "http://localhost");
  const pathname = url.pathname;
  const idMatch = pathname.match(/^\/notes\/(\d+)$/);

  if (req.method === "GET" && pathname === "/notes") {
    send(res, 200, load().notes);
    return;
  }

  if (req.method === "GET" && idMatch) {
    const note = load().notes.find((n) => n.id === Number(idMatch[1]));
    if (!note) return send(res, 404, { error: "not found" });
    send(res, 200, note);
    return;
  }

  if (req.method === "POST" && pathname === "/notes") {
    try {
      const body = await readBody(req);
      if (!body.title) return send(res, 400, { error: "title is required" });
      const data = load();
      const note = {
        id: data.nextId++,
        title: body.title,
        content: body.content ?? "",
        createdAt: new Date().toISOString(),
      };
      data.notes.push(note);
      save(data);
      send(res, 201, note);
    } catch {
      send(res, 400, { error: "invalid JSON" });
    }
    return;
  }

  send(res, 404, { error: "not found" });
});

server.listen(3000, () => {
  console.log("Notes API listening on http://localhost:3000");
});
````

</details>