# Exercise 05 — Promises

- **Level:** 3/5
- **Topic:** `new Promise`, `.then`/`.catch`, `Promise.all`
- **Estimated time:** 20 min

## Statement

Work with promises without `async`/`await`.

1. `delay(ms)` — returns a promise that resolves after `ms` milliseconds with the string `"waited"`.
2. `getUser(id)` — returns a promise. If `id` is `0`, it *rejects* with `new Error("user not found")`. Otherwise it resolves after a short `delay` with `{ id, name: "User " + id }`.
3. Chain `getUser(1).then(...)` to fetch a user and print `User 1` from the resolved value.
4. Chain `getUser(0)` and use `.catch` to print `Error: user not found`.
5. Use `Promise.all` to fetch users `1`, `2`, and `3` at the same time and print the array of names.
6. Use `Promise.all` with a failing call (`getUser(0)` among others) and show it rejects fast, printing the first error.

Expected output:

```text
User 1
Error: user not found
all names: [ 'User 1', 'User 2', 'User 3' ]
all with failure: Error: user not found
```

## Requirements

- [ ] Creates a promise with `new Promise((resolve, reject) => ...)`
- [ ] Uses `.then` and `.catch`
- [ ] Uses `Promise.all` successfully and with a rejection
- [ ] Uses `.finally` at least once
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- A `.catch` at the end of a chain catches errors from any earlier `.then`.
- `Promise.all` rejects as soon as any single promise rejects — that is why the failure case prints immediately.
- Add `.finally(() => console.log("finished"))` to prove it runs in all cases.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function delay(ms) {
  return new Promise((resolve) => setTimeout(() => resolve("waited"), ms));
}

function getUser(id) {
  return new Promise((resolve, reject) => {
    if (id === 0) {
      reject(new Error("user not found"));
      return;
    }
    delay(20).then(() => resolve({ id, name: `User ${id}` }));
  });
}

getUser(1)
  .then((user) => console.log(user.name))
  .catch((err) => console.log(`Error: ${err.message}`))
  .finally(() => console.log("finished"));

getUser(0)
  .then((user) => console.log(user.name))
  .catch((err) => console.log(`Error: ${err.message}`))
  .finally(() => console.log("finished"));

Promise.all([getUser(1), getUser(2), getUser(3)])
  .then((users) => console.log(`all names: ${JSON.stringify(users.map((u) => u.name))}`))
  .catch((err) => console.log(`Error: ${err.message}`));

Promise.all([getUser(1), getUser(0), getUser(2)])
  .then((users) => console.log(`all names: ${JSON.stringify(users.map((u) => u.name))}`))
  .catch((err) => console.log(`all with failure: Error: ${err.message}`));
````

</details>