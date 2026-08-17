# Exercise 01 — Classes

- **Level:** 3/5
- **Topic:** `class`, inheritance, getters/setters
- **Estimated time:** 15 min

## Statement

Build a small zoo system with classes:

1. `class Animal` — constructor takes `name` and `sound`. Has a method `speak()` that returns `` `${name} says ${sound}` ``.
2. `class Dog extends Animal` — fixed sound `"woof"`. Overrides `speak()` to return `` `${name} barks: ${sound}` ``.
3. `class Counter` — with a private field `#count`, a getter `value` that returns the count, a setter `value(n)` that only accepts non-negative integers (otherwise it throws an `Error`), and a method `increment()`.
4. Print everything and demonstrate the setter throwing.

Expected output:

```text
Generic: Rex says grrr
Dog: Fido barks: woof
counter.value = 0
counter.value = 5
counter.value = 3
Error: value must be a non-negative integer
```

## Requirements

- [ ] Defines a base class and a subclass with `extends`
- [ ] Uses `super` in the subclass constructor
- [ ] Overrides a method in the subclass
- [ ] Uses a private field (`#`)
- [ ] Uses a getter and a setter, with the setter validating input
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- In `Dog`, call `super(name, "woof")` then override `speak`.
- Private fields are declared in the class body: `#count = 0;`.
- The setter is `set value(n) { ... }` and must not have the same name as the field.
- Check non-negative integer with `Number.isInteger(n) && n >= 0`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
class Animal {
  constructor(name, sound) {
    this.name = name;
    this.sound = sound;
  }

  speak() {
    return `${this.name} says ${this.sound}`;
  }
}

class Dog extends Animal {
  constructor(name) {
    super(name, "woof");
  }

  speak() {
    return `${this.name} barks: ${this.sound}`;
  }
}

console.log(`Generic: ${new Animal("Rex", "grrr").speak()}`);
console.log(`Dog: ${new Dog("Fido").speak()}`);

class Counter {
  #count = 0;

  get value() {
    return this.#count;
  }

  set value(n) {
    if (!Number.isInteger(n) || n < 0) {
      throw new Error("value must be a non-negative integer");
    }
    this.#count = n;
  }

  increment() {
    this.#count++;
  }
}

const counter = new Counter();
console.log(`counter.value = ${counter.value}`);
counter.value = 5;
console.log(`counter.value = ${counter.value}`);
counter.increment();
console.log(`counter.value = ${counter.value}`);

try {
  counter.value = -1;
} catch (err) {
  console.log(`Error: ${err.message}`);
}
````

</details>