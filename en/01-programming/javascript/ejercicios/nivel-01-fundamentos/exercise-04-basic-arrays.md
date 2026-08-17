# Exercise 04 — Basic Arrays

- **Level:** 1/5
- **Topic:** Create, index, `push`/`pop`/`shift`/`unshift`
- **Estimated time:** 15 min

## Statement

Write a program that manages a simple queue of tasks.

1. Create an array `tasks` with the initial values `["login", "load", "render"]`.
2. Print the array and its `length`.
3. Print the first element (index 0) and the last element (index `length - 1`).
4. Add `"save"` to the end with `push`, then print the array.
5. Remove and print the last element with `pop`.
6. Add `"init"` to the front with `unshift`, then print the array.
7. Remove and print the first element with `shift`.
8. Verify the final array equals `["login", "load", "render"]`.

Expected output:

```text
Initial: [ 'login', 'load', 'render' ] length 3
first: login
last: render
after push: [ 'login', 'load', 'render', 'save' ]
popped: save
after unshift: [ 'init', 'login', 'load', 'render' ]
shifted: init
final: [ 'login', 'load', 'render' ]
```

## Requirements

- [ ] Uses `push`, `pop`, `shift`, and `unshift` each exactly once
- [ ] Accesses elements by index
- [ ] Uses `tasks.length` to get the last element
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `push` and `unshift` return the new length; `pop` and `shift` return the removed element.
- The last element is `tasks[tasks.length - 1]`.
- Remember arrays are 0-indexed.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const tasks = ["login", "load", "render"];
console.log(`Initial: ${JSON.stringify(tasks)} length ${tasks.length}`);

console.log(`first: ${tasks[0]}`);
console.log(`last: ${tasks[tasks.length - 1]}`);

tasks.push("save");
console.log(`after push: ${JSON.stringify(tasks)}`);

const popped = tasks.pop();
console.log(`popped: ${popped}`);

tasks.unshift("init");
console.log(`after unshift: ${JSON.stringify(tasks)}`);

const shifted = tasks.shift();
console.log(`shifted: ${shifted}`);

console.log(`final: ${JSON.stringify(tasks)}`);
````

</details>