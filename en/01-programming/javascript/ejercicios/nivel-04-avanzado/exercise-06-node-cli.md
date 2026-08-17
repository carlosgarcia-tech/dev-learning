# Exercise 06 — Node CLI

- **Level:** 4/5
- **Topic:** CLI script, `process.argv`
- **Estimated time:** 20 min

## Statement

Write a CLI script `cli.js` (in the exercises folder) that reads `process.argv` and behaves like a tiny "word tools" utility.

Usage:

```text
node cli.js count "hello world"
node cli.js upper "hello world"
node cli.js reverse "hello world"
node cli.js help
```

Behavior:

1. `count <text>` — prints `words: 2, chars: 11` (words split by whitespace, chars = `text.length`).
2. `upper <text>` — prints the text in uppercase.
3. `reverse <text>` — prints the text reversed.
4. `help` (or no/unknown args) — prints a usage message.
5. Extract arguments with `process.argv` — remember indexes `2` and `3` (after `node` and the script path).

Handle the case where the text argument is missing by printing an error message and the usage text.

Expected output for `node cli.js count "hello world"`:

```text
words: 2, chars: 11
```

## Requirements

- [ ] Reads `process.argv` directly
- [ ] Implements all four commands
- [ ] Handles a missing text argument gracefully
- [ ] Splits words by whitespace (`split(/\s+/)`) filtering empty strings
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `process.argv[0]` is `node`, `process.argv[1]` is the script path, arguments start at index 2.
- Reversing a string: `text.split("").reverse().join("")`.
- If `!text`, print an error and the usage.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const command = process.argv[2];
const text = process.argv.slice(3).join(" ");

const usage = `Usage:
  node cli.js count <text>
  node cli.js upper <text>
  node cli.js reverse <text>
  node cli.js help`;

if (command === "help" || command === undefined) {
  console.log(usage);
  process.exit(0);
}

if (!text) {
  console.error("Error: missing text argument");
  console.log(usage);
  process.exit(1);
}

switch (command) {
  case "count": {
    const words = text.split(/\s+/).filter(Boolean).length;
    console.log(`words: ${words}, chars: ${text.length}`);
    break;
  }
  case "upper":
    console.log(text.toUpperCase());
    break;
  case "reverse":
    console.log(text.split("").reverse().join(""));
    break;
  default:
    console.error(`Error: unknown command '${command}'`);
    console.log(usage);
    process.exit(1);
}
````

</details>