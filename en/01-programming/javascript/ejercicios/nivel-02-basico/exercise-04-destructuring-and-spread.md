# Exercise 04 — Destructuring and Spread

- **Level:** 2/5
- **Topic:** Destructuring, spread/rest
- **Estimated time:** 15 min

## Statement

Work with the following data:

```javascript
const user = { id: 1, name: "Ada", email: "ada@example.com", role: "admin" };
const scores = [85, 92, 78, 90];
```

1. Destructure `name` and `email` from `user` and print them.
2. Destructure the remaining properties into a `rest` object using the rest syntax.
3. Destructure `first` and `second` from `scores`, and collect the rest into `restScores`.
4. Destructure `role` from `user` with a default value, but do it from a variable that lacks it (test the default by destructuring `{ role = "user" }` from `user`).
5. Create `user2` by spreading `user` and overriding `name` to `"Grace"`.
6. Create `allScores` by spreading `scores` and appending `100` at the end.
7. Write a function `logAll(...args)` that uses rest to log every argument.

Print each result.

## Requirements

- [ ] Uses object destructuring with and without rest
- [ ] Uses array destructuring with rest
- [ ] Uses a default value in destructuring
- [ ] Uses spread to copy/merge objects and arrays
- [ ] Uses rest parameters in a function
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Rest always goes last in a destructuring pattern: `const { a, ...rest } = obj;`
- Spread `...user` makes a shallow copy; later keys override earlier ones.
- For arrays: `const [x, ...xs] = scores;`

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const user = { id: 1, name: "Ada", email: "ada@example.com", role: "admin" };
const scores = [85, 92, 78, 90];

const { name, email } = user;
console.log("name:", name, "email:", email);

const { id, ...rest } = user;
console.log("rest object:", rest);

const [first, second, ...restScores] = scores;
console.log("first:", first, "second:", second, "restScores:", restScores);

const { role = "user" } = user;
console.log("role:", role);

const user2 = { ...user, name: "Grace" };
console.log("user2:", user2);

const allScores = [...scores, 100];
console.log("allScores:", allScores);

function logAll(...args) {
  console.log("args:", args);
}
logAll(1, "two", [3]);
````

</details>