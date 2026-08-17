# Exercise 01 — Async/Await

- **Level:** 4/5
- **Topic:** `async`/`await`, parallel execution
- **Estimated time:** 20 min

## Statement

Build a small async program that models reading data files with delays:

1. `delay(ms)` — promise-based helper (resolves after `ms` ms).
2. `readChunk(name, ms)` — `async` function that `await`s `delay(ms)` and returns `` `content of ${name}` ``.
3. `readAllSequential()` — `async` function that reads chunks `"a"`, `"b"`, `"c"` (30ms each) **one at a time** with `await`, collecting results into an array. Measure and print total time.
4. `readAllParallel()` — `async` function that reads the same three chunks in **parallel** with `Promise.all`, printing the results and the total time.
5. `tryChunks()` — `async` function that calls a failing reader `readChunk("fail", 10)` which, if the name starts with `"fail"`, rejects with `new Error("bad chunk")`. Wrap it in `try`/`catch` and print the error message.

Expected output (times are approximate — parallel must be much faster):

```text
sequential: [ 'content of a', 'content of b', 'content of c' ] in ~90ms
parallel: [ 'content of a', 'content of b', 'content of c' ] in ~30ms
caught: bad chunk
```

## Requirements

- [ ] Uses `async` function declarations and `await`
- [ ] Runs tasks sequentially and in parallel with `Promise.all`
- [ ] Measures elapsed time with `Date.now()`
- [ ] Catches an async rejection with `try`/`catch`
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Measure with `const start = Date.now();` and `Date.now() - start`.
- Parallel: `const results = await Promise.all([readChunk("a", 30), readChunk("b", 30), readChunk("c", 30)]);`
- An `async` function that rejects throws inside `await` in the caller's `try`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function readChunk(name, ms) {
  await delay(ms);
  if (name.startsWith("fail")) {
    throw new Error("bad chunk");
  }
  return `content of ${name}`;
}

async function readAllSequential() {
  const start = Date.now();
  const results = [];
  results.push(await readChunk("a", 30));
  results.push(await readChunk("b", 30));
  results.push(await readChunk("c", 30));
  console.log(`sequential: ${JSON.stringify(results)} in ~${Date.now() - start}ms`);
}

async function readAllParallel() {
  const start = Date.now();
  const results = await Promise.all([
    readChunk("a", 30),
    readChunk("b", 30),
    readChunk("c", 30),
  ]);
  console.log(`parallel: ${JSON.stringify(results)} in ~${Date.now() - start}ms`);
}

async function tryChunks() {
  try {
    await readChunk("fail", 10);
  } catch (err) {
    console.log(`caught: ${err.message}`);
  }
}

readAllSequential().then(() => readAllParallel().then(() => tryChunks()));
````

</details>