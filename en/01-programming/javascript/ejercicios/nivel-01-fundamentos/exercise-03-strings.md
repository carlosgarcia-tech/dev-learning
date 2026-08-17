# Exercise 03 — Strings

- **Level:** 1/5
- **Topic:** String methods, `length`, concatenation
- **Estimated time:** 15 min

## Statement

Write a small "text analyzer" that processes a full name given as two strings `first` and `last` (e.g. `"ada"` and `"LOVELACE"`).

1. Combine them into a `fullName` using concatenation with `+` so it reads `"Ada LOVELACE"` (capitalize the first letter of the first name).
2. Also build `fullName2` with a template literal and note both give the same result.
3. Print the `length` of `fullName`.
4. Convert `fullName` to lowercase and to uppercase, printing both.
5. Print whether `fullName` includes the word `"ada"` (use `includes` with `toLowerCase`).
6. Print the first character and the last character of `fullName`.

Expected output for `first = "ada"`, `last = "LOVELACE"`:

```text
fullName: Ada LOVELACE
length: 12
lowercase: ada lovelace
uppercase: ADA LOVELACE
includes 'ada': true
first char: A
last char: E
```

## Requirements

- [ ] Uses `+` concatenation at least once
- [ ] Uses a template literal at least once
- [ ] Uses `length`, `toUpperCase`, `toLowerCase`, `includes`, `charAt` (or bracket access)
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `first[0]` gives the first character; `first[0].toUpperCase() + first.slice(1)` capitalizes.
- `.charAt(i)` returns the character at index `i`, or `""` if out of range.
- The last index is always `length - 1`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const first = "ada";
const last = "LOVELACE";

const capitalizedFirst = first[0].toUpperCase() + first.slice(1);
const fullName = capitalizedFirst + " " + last;
const fullName2 = `${capitalizedFirst} ${last}`;

console.log(`fullName: ${fullName}`);
console.log(`fullName2: ${fullName2}`);
console.log(`length: ${fullName.length}`);
console.log(`lowercase: ${fullName.toLowerCase()}`);
console.log(`uppercase: ${fullName.toUpperCase()}`);
console.log(`includes 'ada': ${fullName.toLowerCase().includes("ada")}`);
console.log(`first char: ${fullName.charAt(0)}`);
console.log(`last char: ${fullName.charAt(fullName.length - 1)}`);
````

</details>