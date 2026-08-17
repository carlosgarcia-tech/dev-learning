# 03 — Arrays and Objects

## Goals

- [ ] Create and mutate arrays with `push`, `pop`, `shift`, `unshift`, and `splice`
- [ ] Transform arrays with `map`, `filter`, `reduce`, and `find`
- [ ] Create and read objects, and iterate over their properties
- [ ] Use destructuring for arrays and objects
- [ ] Use spread and rest operators
- [ ] Serialize and parse data with `JSON.stringify` and `JSON.parse`

## Notes

### Arrays

Arrays are ordered, zero-indexed lists. They are objects, so `typeof [] === "object"`.

Mutating methods:

| Method | Action | Returns |
|--------|--------|---------|
| `push(x)` | add to the end | new length |
| `pop()` | remove from the end | removed element |
| `unshift(x)` | add to the front | new length |
| `shift()` | remove from the front | removed element |
| `splice(i, n, ...items)` | remove/replace at index | removed elements |

Transforming methods (return a new array, don't mutate):

| Method | Purpose | Example result |
|--------|---------|----------------|
| `map(fn)` | transform every element | `[1,2,3].map(x => x * 2)` → `[2,4,6]` |
| `filter(fn)` | keep elements that pass | `[1,2,3,4].filter(x => x % 2 === 0)` → `[2,4]` |
| `find(fn)` | first element that passes | `[1,2,3].find(x => x > 1)` → `2` |
| `reduce(fn, init)` | fold to a single value | `[1,2,3].reduce((a,b) => a+b, 0)` → `6` |

Also useful: `slice` (copy, non-mutating), `includes`, `indexOf`, `join`, `length`.

### Objects

Objects store `key: value` pairs. Access with dot notation or bracket notation (needed for dynamic keys or keys with special characters). You can reassign properties even on `const` objects — only the binding is fixed.

```javascript
const user = { name: "Ada", age: 36 };
user.age = 37;          // OK
user["country"] = "UK"; // adds a new property
delete user.country;    // removes it
```

### Destructuring

Unpacks values into variables:

```javascript
const { name, age } = user;            // object
const [first, second] = [1, 2, 3];     // array
const { name: title } = user;          // rename
```

### Spread and rest

- `...` in a call or literal **spreads**: copies values.
- `...` in a parameter list **rests**: collects values.

```javascript
const a = [1, 2];
const b = [...a, 3];              // [1, 2, 3]
const merged = { ...user, age: 40 }; // shallow copy with override
function f(...args) { return args; }
```

### JSON

JSON is a text format. `JSON.stringify` converts a value to a string; `JSON.parse` converts it back. JSON keys must be quoted, and it only stores plain data (no functions, no `undefined`, no `NaN`).

## Code examples

```javascript
const prices = [10, 25, 50, 8];

const withTax = prices.map((p) => p * 1.21);
const affordable = prices.filter((p) => p <= 25);
const firstCheap = prices.find((p) => p < 10);
const total = prices.reduce((acc, p) => acc + p, 0);

console.log(withTax);   // [12.1, 30.25, 60.5, 9.68]
console.log(affordable); // [10, 25, 8]
console.log(firstCheap); // 8
console.log(total);      // 93

const cart = { items: ["milk"], total: 3.5 };
const text = JSON.stringify(cart);
const parsed = JSON.parse(text);
console.log(parsed.total); // 3.5

const [first, second, ...rest] = [1, 2, 3, 4];
console.log(first, second, rest); // 1 2 [3, 4]
```

## Related exercises

- [nivel-01-fundamentos/exercise-04-basic-arrays.md](ejercicios/nivel-01-fundamentos/exercise-04-basic-arrays.md)
- [nivel-01-fundamentos/exercise-06-basic-objects.md](ejercicios/nivel-01-fundamentos/exercise-06-basic-objects.md)
- [nivel-02-basico/exercise-03-array-methods.md](ejercicios/nivel-02-basico/exercise-03-array-methods.md)
- [nivel-02-basico/exercise-04-destructuring-and-spread.md](ejercicios/nivel-02-basico/exercise-04-destructuring-and-spread.md)
- [nivel-03-intermedio/exercise-03-reduce-and-sort.md](ejercicios/nivel-03-intermedio/exercise-03-reduce-and-sort.md)

## Common mistakes

- Using `map`/`filter` for side effects or ignoring their return value — they create new arrays.
- Forgetting that `find` returns `undefined` when nothing matches.
- Mutating an array while iterating it with `for...of`.
- Confusing `splice` (mutates) with `slice` (copies).
- Spreading an object into a new object still shares nested objects (shallow copy).
- `JSON.stringify` failing silently on `undefined`, functions, or circular references.

## Resources

- [MDN: Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN: Object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)
- [MDN: Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [MDN: Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
- [MDN: JSON](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON)