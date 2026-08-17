# Exercise 06 — Basic Objects

- **Level:** 1/5
- **Topic:** Object literal, access/modify properties
- **Estimated time:** 15 min

## Statement

Create an object literal that represents a book and manipulate it.

1. Create `book` with properties: `title: "Dune"`, `author: "Frank Herbert"`, `year: 1965`.
2. Print the title using dot notation and the author using bracket notation.
3. Modify the `year` to `1966` and print the updated object.
4. Add a new property `pages: 412` (use dot notation).
5. Add another property using a computed key: `book["inStock"] = true`.
6. Delete the `inStock` property.
7. Print the object three times: the initial one, after modification, and the final one using `console.log(book)`.

Expected output (final object):

```text
{ title: 'Dune', author: 'Frank Herbert', year: 1966, pages: 412 }
```

## Requirements

- [ ] Creates an object literal with at least 3 properties
- [ ] Reads properties with both dot and bracket notation
- [ ] Modifies, adds, and deletes properties
- [ ] Uses a computed (`[]`) key for at least one assignment
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `delete book.inStock` removes a property.
- Bracket notation is required for keys that are not valid identifiers, but works for any string key.
- `console.log(book)` prints the live object in Node.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const book = {
  title: "Dune",
  author: "Frank Herbert",
  year: 1965,
};

console.log(book.title);        // dot notation
console.log(book["author"]);    // bracket notation

book.year = 1966;               // modify
console.log(book);

book.pages = 412;               // add with dot notation
book["inStock"] = true;         // add with computed key

delete book.inStock;            // delete

console.log(book);
````

</details>