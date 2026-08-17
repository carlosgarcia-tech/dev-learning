# 02 — Functions

## Goals

- [ ] Declare functions with declarations, expressions, and arrow functions
- [ ] Use parameters, default parameters, and rest parameters
- [ ] Return values and understand what happens with no `return`
- [ ] Explain scope (global, function, block) and variable shadowing
- [ ] Create closures and explain why they are useful
- [ ] Explain hoisting and why `var`/function declarations are hoisted

## Notes

### Declaration vs expression vs arrow

```javascript
// Declaration — hoisted, can be called before its line
function add(a, b) {
  return a + b;
}

// Expression — assigned to a variable, NOT hoisted
const subtract = function (a, b) {
  return a - b;
};

// Arrow — concise, inherits `this`, cannot be used as constructor
const multiply = (a, b) => a * b;
```

An arrow with a single expression returns it implicitly. With a body block `{ }` you must write `return` yourself.

### Parameters

- Default parameters: `function greet(name = "friend")`.
- Rest parameters collect extras into an array: `function sum(...nums)`.
- Functions receive all arguments you pass, even if you didn't declare them.

### Return

- `return` ends the function immediately.
- A function without `return` (or with a bare `return`) yields `undefined`.

### Scope

- **Global**: declared at the top level, visible everywhere.
- **Function scope**: `var` and function declarations live here.
- **Block scope**: `let` and `const` live inside `{ }`.
- **Shadowing**: an inner variable with the same name hides the outer one.

### Closures

A closure is a function that "remembers" the variables of the scope where it was created, even after that scope has finished running. They enable private state and factories.

```javascript
function counter(start = 0) {
  let value = start;
  return () => ++value; // closure over `value`
}
const next = counter();
next(); // 1
next(); // 2
```

### Hoisting

- Function declarations are fully hoisted (callable before definition).
- `var` is hoisted but initialized to `undefined` (a source of bugs).
- `let` and `const` are hoisted to the top of their block but in a "temporal dead zone" until their line executes — referencing them early throws `ReferenceError`.

## Code examples

```javascript
function max(a, b) {
  return a > b ? a : b;
}
console.log(max(3, 7)); // 7

const greet = (name = "world") => `Hello, ${name}!`;
console.log(greet());        // Hello, world!
console.log(greet("Ada"));   // Hello, Ada!

function sum(...nums) {
  return nums.reduce((acc, n) => acc + n, 0);
}
console.log(sum(1, 2, 3, 4)); // 10

function makeMultiplier(factor) {
  return (n) => n * factor; // closure
}
const double = makeMultiplier(2);
console.log(double(21)); // 42
```

## Related exercises

- [nivel-02-basico/exercise-01-functions.md](ejercicios/nivel-02-basico/exercise-01-functions.md)
- [nivel-02-basico/exercise-02-arrow-functions.md](ejercicios/nivel-02-basico/exercise-02-arrow-functions.md)
- [nivel-02-basico/exercise-06-closures.md](ejercicios/nivel-02-basico/exercise-06-closures.md)

## Common mistakes

- Forgetting `return` in a block-bodied arrow (or in any function) — you get `undefined`.
- Using an arrow function where you need `arguments` or your own `this` (arrows inherit both).
- Assuming `let`/`const` are hoisted usable values — they're in the temporal dead zone.
- Creating closures inside loops and capturing the loop variable by reference.
- Naming a parameter the same as a function you want to call (`Math.max` shadowing).

## Resources

- [MDN: Functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions)
- [JavaScript.info: Functions](https://javascript.info/function-basics)
- [JavaScript.info: Closures](https://javascript.info/closure)
- [MDN: Arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)