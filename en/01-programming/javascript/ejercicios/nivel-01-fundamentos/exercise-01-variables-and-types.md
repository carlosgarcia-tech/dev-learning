# Exercise 01 — Variables and Types

- **Level:** 1/5
- **Topic:** Variables, `typeof`, template literals
- **Estimated time:** 15 min

## Statement

Create a small "user profile" program that:

1. Declares a constant `firstName` and `lastName` (strings).
2. Declares a `let` variable `age` (number) and reassign it once to a new value.
3. Uses a template literal to print: `Name: Ada Lovelace (age 36)`.
4. Prints the `typeof` of each variable.
5. Explains the result of `typeof null` in a printed comment-line message.

Example expected output:

```text
Name: Ada Lovelace (age 36)
typeof firstName: string
typeof lastName: string
typeof age: number
typeof nothing: undefined
typeof empty: object
```

Use a variable named `nothing` that is declared but never assigned, and a variable named `empty` set to `null`. Do not use `var` anywhere.

## Requirements

- [ ] Uses `const` for names and `let` for the age
- [ ] Reassigns `age` at least once
- [ ] Prints the profile with a template literal
- [ ] Prints the `typeof` of every variable
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Declaring without assigning gives `undefined`: `let nothing;`
- `typeof` is an operator: `typeof nothing` returns the string `"undefined"`.
- `typeof null` is `"object"` — a known historical quirk of JavaScript.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const firstName = "Ada";
const lastName = "Lovelace";

let age = 36;
age = 37; // reassigning a `let`

let nothing; // undefined
const empty = null;

console.log(`Name: ${firstName} ${lastName} (age ${age})`);

console.log(`typeof firstName: ${typeof firstName}`);
console.log(`typeof lastName: ${typeof lastName}`);
console.log(`typeof age: ${typeof age}`);
console.log(`typeof nothing: ${typeof nothing}`);
console.log(`typeof empty: ${typeof empty}`);
console.log("Note: typeof null returns 'object' because of a historical bug in the language.");
````

</details>