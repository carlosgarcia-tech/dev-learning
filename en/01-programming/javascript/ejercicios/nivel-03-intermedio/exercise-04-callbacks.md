# Exercise 04 — Callbacks

- **Level:** 3/5
- **Topic:** Callbacks, higher-order functions
- **Estimated time:** 15 min

## Statement

Implement a small asynchronous utilities module using callbacks:

1. `doTask(name, ms, callback)` — waits `ms` milliseconds with `setTimeout`, then calls `callback` with a message `` `done: ${name}` ``. Simulate a failure: if `name` starts with `"fail"`, call the callback with an `Error` as its first argument (error-first style).
2. `runSequentially(tasks, callback)` — runs an array of `{ name, ms }` tasks one after another using `doTask`, collecting results, and finally calls `callback` with the results array.
3. Demonstrate the error-first convention: the callback signature is `(err, result)`. If `err` is truthy, print `"ERROR: ..."`, otherwise print the result.

Test with:
- `doTask("A", 50, ...)`
- `doTask("failB", 50, ...)`
- `runSequentially([{name:"X",ms:10},{name:"Y",ms:20}], ...)`

Expected output order (approximately):

```text
result: done: A
ERROR: failB has failed
result: [ 'done: X', 'done: Y' ]
```

## Requirements

- [ ] Uses error-first callbacks `(err, result)`
- [ ] Implements `runSequentially` by chaining callbacks (no promises allowed)
- [ ] Handles the error case in the consumer
- [ ] Uses `setTimeout`
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- In `doTask`, decide success/failure *after* the timeout so it is truly async.
- `runSequentially` is recursion: process the first task, then call itself with the rest.
- Always call the callback exactly once.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function doTask(name, ms, callback) {
  setTimeout(() => {
    if (name.startsWith("fail")) {
      callback(new Error(`${name} has failed`));
      return;
    }
    callback(null, `done: ${name}`);
  }, ms);
}

function runSequentially(tasks, callback) {
  const results = [];
  let index = 0;

  function next() {
    if (index >= tasks.length) {
      callback(null, results);
      return;
    }
    const task = tasks[index++];
    doTask(task.name, task.ms, (err, result) => {
      if (err) {
        callback(err);
        return;
      }
      results.push(result);
      next();
    });
  }

  next();
}

doTask("A", 50, (err, result) => {
  if (err) return console.log(`ERROR: ${err.message}`);
  console.log(`result: ${result}`);
});

doTask("failB", 50, (err, result) => {
  if (err) return console.log(`ERROR: ${err.message}`);
  console.log(`result: ${result}`);
});

runSequentially(
  [
    { name: "X", ms: 10 },
    { name: "Y", ms: 20 },
  ],
  (err, result) => {
    if (err) return console.log(`ERROR: ${err.message}`);
    console.log(`result: ${JSON.stringify(result)}`);
  }
);
````

</details>