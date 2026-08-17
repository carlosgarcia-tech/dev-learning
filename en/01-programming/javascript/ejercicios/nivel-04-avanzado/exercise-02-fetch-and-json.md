# Exercise 02 — Fetch and JSON

- **Level:** 4/5
- **Topic:** `fetch`, JSON processing
- **Estimated time:** 20 min

## Statement

Use the public API `https://jsonplaceholder.typicode.com/users` (a free, well-known test API) to practice `fetch` and JSON.

1. `fetchUsers()` — `async` function that fetches the users list, checks `res.ok`, parses JSON, and returns the array.
2. Print the number of users and the `name` of the first user.
3. `topUsers(users)` — given the array, filter users whose `address.city` starts with a letter you pick (e.g. `"S"`), then map to `{ id, name, city }`, then sort by `name`. Print the result.
4. `createUser()` — POST a new user to `https://jsonplaceholder.typicode.com/users` with `fetch(url, { method: "POST", headers, body })`, print the returned `id`.
5. Print the email of the user whose `id` is `1` using `Array.find` on the fetched data.

Handle network/parse errors with `try`/`catch` in each async function, printing `Error: ...`.

## Requirements

- [ ] Uses `fetch` with GET and POST
- [ ] Checks `res.ok` before parsing
- [ ] Uses `Array.filter`/`map`/`sort`/`find` on fetched JSON
- [ ] Sends JSON in the POST body with the correct `Content-Type` header
- [ ] Catches errors with `try`/`catch`
- [ ] Run it locally with `node` and verify the output (needs internet)

## Hints

<details>
<summary>Show hints</summary>

- `res.ok` is `false` for 4xx/5xx responses; `fetch` only rejects on network failure.
- For POST: `headers: { "Content-Type": "application/json" }` and `body: JSON.stringify(data)`.
- `.find((u) => u.id === 1)` returns the user object.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const USERS_URL = "https://jsonplaceholder.typicode.com/users";

async function fetchUsers() {
  try {
    const res = await fetch(USERS_URL);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
  } catch (err) {
    console.log(`Error: ${err.message}`);
    return [];
  }
}

async function topUsers(users, letter) {
  return users
    .filter((u) => u.address.city.startsWith(letter))
    .map((u) => ({ id: u.id, name: u.name, city: u.address.city }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

async function createUser() {
  try {
    const res = await fetch(USERS_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Ada", username: "ada" }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const created = await res.json();
    console.log(`created id: ${created.id}`);
  } catch (err) {
    console.log(`Error: ${err.message}`);
  }
}

async function main() {
  const users = await fetchUsers();
  if (users.length === 0) return;

  console.log(`total users: ${users.length}`);
  console.log(`first user: ${users[0].name}`);
  console.log(`user id 1 email: ${users.find((u) => u.id === 1).email}`);

  const top = await topUsers(users, "S");
  console.log("top users:", JSON.stringify(top, null, 2));

  await createUser();
}

main();
````

</details>