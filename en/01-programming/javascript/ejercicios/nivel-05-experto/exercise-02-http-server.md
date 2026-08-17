# Exercise 02 — HTTP Server

- **Level:** 5/5
- **Topic:** Server with `node:http`
- **Estimated time:** 40 min

## Statement

Build a minimal HTTP server with only `node:http` that serves a tiny API and static text.

1. Create a server on port `3000` with `http.createServer`.
2. Handle routes by checking `req.method` and `req.url`:
   - `GET /` → respond `200` with `Hello from Node!`.
   - `GET /time` → respond `200` with the current ISO time (`new Date().toISOString()`).
   - `GET /json` → respond `200` with `Content-Type: application/json` and body `{"status":"ok","version":1}`.
   - Any other route → respond `404` with `Not found`.
3. Set the `Content-Type` header appropriately for each route.
4. Print `Server listening on http://localhost:3000` and test with `curl` (see below).
5. Handle the `clientError` event so malformed requests don't crash the server.

Test commands:

```text
curl http://localhost:3000/
curl http://localhost:3000/time
curl http://localhost:3000/json
curl http://localhost:3000/nope
```

## Requirements

- [ ] Creates a server with `http.createServer`
- [ ] Routes at least 3 paths plus a 404 fallback
- [ ] Sets `Content-Type` (text and JSON)
- [ ] Listens on a port and logs a startup message
- [ ] Handles `clientError`
- [ ] Run it locally with `node` and verify with `curl`

## Hints

<details>
<summary>Show hints</summary>

- Parse the path: `const url = new URL(req.url, "http://localhost");` then use `url.pathname`.
- Always call `res.end()` exactly once per request.
- `server.on("clientError", (err, socket) => socket.end("HTTP/1.1 400 Bad Request\r\n\r\n"))`.
- `curl` shows headers with `-i` if you want to verify `Content-Type`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const http = require("node:http");

const server = http.createServer((req, res) => {
  const url = new URL(req.url, "http://localhost");
  const path = url.pathname;

  if (req.method === "GET" && path === "/") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("Hello from Node!");
    return;
  }

  if (req.method === "GET" && path === "/time") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end(new Date().toISOString());
    return;
  }

  if (req.method === "GET" && path === "/json") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok", version: 1 }));
    return;
  }

  res.writeHead(404, { "Content-Type": "text/plain" });
  res.end("Not found");
});

server.on("clientError", (err, socket) => {
  socket.end("HTTP/1.1 400 Bad Request\r\n\r\n");
});

server.listen(3000, () => {
  console.log("Server listening on http://localhost:3000");
});
````

</details>