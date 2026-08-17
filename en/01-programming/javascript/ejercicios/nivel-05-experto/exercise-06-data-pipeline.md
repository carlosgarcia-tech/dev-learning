# Exercise 06 — Data Pipeline

- **Level:** 5/5
- **Topic:** Transform data in multiple stages
- **Estimated time:** 45 min

## Statement

Build a composable data-processing pipeline. Start from raw log lines and produce an aggregated report.

1. `parse(lines)` — takes the array of raw strings like `"GET /home 200 15ms"` and returns an array of records `{ method, path, status, ms }` (split each line by spaces; `ms` becomes a number, `status` a number).
2. `filterErrors(records)` — keeps only records with `status >= 400`.
3. `toSlow(records, threshold = 50)` — keeps records where `ms > threshold`.
4. `groupByPath(records)` — returns an object mapping `path` → array of records.
5. `summarize(grouped)` — for each path, returns `{ path, count, totalMs, avgMs }` (avg rounded to 1 decimal).
6. `pipeline(...stages)` — a function that takes any number of stage functions and returns a `run(data)` function that applies them **left to right** (`stage1(stage2(...))`? no — left to right means the output of stage 1 feeds stage 2).

Feed the raw array:

```javascript
const raw = [
  "GET /home 200 15ms",
  "GET /api 500 120ms",
  "GET /home 404 30ms",
  "POST /api 201 200ms",
  "GET /api 500 40ms",
];
```

Pipeline to run: `parse → toSlow(50) → filterErrors → groupByPath → summarize` and print the JSON result.

Expected: only slow *error* records pass (`GET /api 500 120ms`, `POST /api 201 200ms` is dropped because it is not an error; the other `500 40ms` is dropped for being fast).

## Requirements

- [ ] Each stage is a pure function (input → output, no side effects)
- [ ] `pipeline(...stages)` composes them left-to-right into a single `run`
- [ ] `groupByPath` returns a grouped object
- [ ] `summarize` computes count, totalMs, avgMs
- [ ] Filters chain correctly (only slow + error records survive)
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `pipeline` reduces the stages: `const run = (data) => stages.reduce((acc, stage) => stage(acc), data);`
- `toSlow`/`filterErrors` take the records array and return a filtered array.
- `groupByPath` returns object; `summarize` maps over `Object.entries(grouped)`.
- Round averages: `Math.round(x * 10) / 10`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const raw = [
  "GET /home 200 15ms",
  "GET /api 500 120ms",
  "GET /home 404 30ms",
  "POST /api 201 200ms",
  "GET /api 500 40ms",
];

function parse(lines) {
  return lines.map((line) => {
    const [method, path, status, ms] = line.split(" ");
    return { method, path, status: Number(status), ms: parseInt(ms, 10) };
  });
}

function filterErrors(records) {
  return records.filter((r) => r.status >= 400);
}

function toSlow(records, threshold = 50) {
  return records.filter((r) => r.ms > threshold);
}

function groupByPath(records) {
  return records.reduce((acc, r) => {
    (acc[r.path] ??= []).push(r);
    return acc;
  }, {});
}

function summarize(grouped) {
  return Object.entries(grouped).map(([path, records]) => {
    const totalMs = records.reduce((sum, r) => sum + r.ms, 0);
    return {
      path,
      count: records.length,
      totalMs,
      avgMs: Math.round((totalMs / records.length) * 10) / 10,
    };
  });
}

function pipeline(...stages) {
  return (data) => stages.reduce((acc, stage) => stage(acc), data);
}

const run = pipeline(parse, toSlow, filterErrors, groupByPath, summarize);

console.log(JSON.stringify(run(raw), null, 2));
````

</details>