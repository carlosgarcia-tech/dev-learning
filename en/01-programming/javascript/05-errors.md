# 05 — Errors

## Goals

- [ ] Throw your own errors with `throw new Error(...)`
- [ ] Handle errors with `try` / `catch` / `finally`
- [ ] Distinguish the built-in error types and their properties
- [ ] Recognize the most common JavaScript errors and their causes
- [ ] Debug with `console`, stack traces, and `node --inspect`

## Notes

### Throwing errors

`throw` stops the current execution and hands control to the nearest matching `catch` (or crashes the process). Throw `Error` instances — never throw plain strings — so you get a stack trace and a `.message`.

```javascript
function divide(a, b) {
  if (b === 0) throw new Error("Division by zero");
  return a / b;
}
```

### try / catch / finally

- `try` — the code that may throw.
- `catch (err)` — runs only if the `try` block threw.
- `finally` — always runs, whether there was an error or not (ideal for cleanup like closing files).

A `throw` inside a `try` is caught by the `catch`; a `throw` in `catch` propagates out. `finally` runs *before* the error propagates.

### Error types

| Type | Meaning |
|------|---------|
| `Error` | Base class for all errors |
| `TypeError` | Wrong type of value (calling a non-function, reading a property of `null`) |
| `ReferenceError` | Using a variable that isn't defined |
| `SyntaxError` | Invalid JavaScript that can't be parsed |
| `RangeError` | A number is out of allowed range (e.g. `new Array(-1)`) |
| `URIError` | Invalid `encodeURI` / `decodeURI` argument |

Custom errors extend `Error` so you can distinguish your own failures.

### Common JavaScript errors and debugging

- **`ReferenceError: x is not defined`** — typo, or a `let`/`const` used before its declaration (temporal dead zone).
- **`TypeError: Cannot read properties of undefined (reading 'name')`** — you assumed something exists. Guard with `?.` or check first.
- **`TypeError: x is not a function`** — you called a value that isn't a function (often a forgotten `.map` result or a typo).
- **`NaN` (not an error)** — invalid numeric operation, e.g. `"abc" * 2`. `typeof NaN` is `"number"`.
- **Unhandled promise rejection** — an async error with no `.catch` or `try/catch`.
- **Stack overflow** — infinite recursion; look at the repeating frames.

Debugging workflow: log the value with `console.log`, then `console.dir(obj, { depth: null })` for deep objects, then check the stack trace line numbers, and finally use `node --inspect` + Chrome DevTools breakpoints.

## Code examples

```javascript
function parseUser(json) {
  const data = JSON.parse(json); // throws SyntaxError on bad input
  if (!data.name) throw new TypeError("User object needs a .name");
  return data;
}

try {
  const user = parseUser('{"name":"Ada"}');
  console.log(user.name);
} catch (err) {
  console.error(`${err.name}: ${err.message}`);
} finally {
  console.log("Attempt finished");
}

// Optional chaining avoids "Cannot read properties of undefined"
const address = undefined;
console.log(address?.city ?? "no address"); // no address
```

```javascript
// A custom error type
class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.name = "ValidationError";
  }
}

try {
  throw new ValidationError("Email is required");
} catch (err) {
  if (err instanceof ValidationError) {
    console.error("Validation failed:", err.message);
  } else {
    throw err;
  }
}
```

## Related exercises

- [nivel-02-basico/exercise-05-error-handling.md](ejercicios/nivel-02-basico/exercise-05-error-handling.md)
- [nivel-04-avanzado/exercise-05-testing-with-assert.md](ejercicios/nivel-04-avanzado/exercise-05-testing-with-assert.md)

## Common mistakes

- Throwing strings instead of `Error` objects (loses the stack trace).
- Swallowing errors with an empty `catch {}` and never logging them.
- Putting `return` before `finally` cleanup that still must run — `finally` is the right tool.
- Catching an error, then throwing a new one and losing the original (include `err` as `cause`).
- Confusing parse-time `SyntaxError` (your code won't even start) with runtime errors.
- Forgetting that `await` rejections behave like thrown errors inside `try`.

## Resources

- [MDN: Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error)
- [MDN: throw](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/throw)
- [MDN: try...catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch)
- [Node.js: debugger](https://nodejs.org/api/debugger.html)
- [JavaScript.info: Error handling](https://javascript.info/try-catch)