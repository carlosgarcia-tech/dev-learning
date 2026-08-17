# Exercise 03 — Design Patterns

- **Level:** 4/5
- **Topic:** Module, singleton, observer
- **Estimated time:** 25 min

## Statement

Implement three classic patterns in one file:

1. **Module pattern** — an IIFE returning an object. Expose `add`, `subtract`, and `getTotal`; keep `total` private inside the closure. `add(10)` then `add(5)` then `subtract(3)` → `getTotal()` returns `12`. Show that `total` is not accessible outside.
2. **Singleton pattern** — `getDatabase()` returns the *same* instance every time. The instance has a `connect(name)` method and a private `#name`. Print whether two calls return the same object.
3. **Observer pattern** — a `class Subject` with `subscribe(fn)`, `unsubscribe(fn)`, and `notify(data)`. Two subscribers log their received data; unsubscribe one and notify again to show only one receives.

Expected output:

```text
module total: 12
module total (outside): undefined
singleton same instance: true
subject: Subscriber A got { event: 'save' }
subject: Subscriber B got { event: 'save' }
after unsubscribe, only A: Subscriber A got { event: 'load' }
```

## Requirements

- [ ] Module pattern via IIFE with private state
- [ ] Singleton returns the same instance (check with `===`)
- [ ] Observer with subscribe/unsubscribe/notify
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Module: `const calc = (() => { let total = 0; return { add(n) {...} }; })();`
- Singleton: keep the instance in a closure variable and return it if already set.
- Observer: `#subscribers` as a `Set` so `unsubscribe` is easy.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
// 1. Module pattern
const calc = (() => {
  let total = 0;
  return {
    add(n) {
      total += n;
    },
    subtract(n) {
      total -= n;
    },
    getTotal() {
      return total;
    },
  };
})();

calc.add(10);
calc.add(5);
calc.subtract(3);
console.log(`module total: ${calc.getTotal()}`);
console.log(`module total (outside): ${typeof calc.total}`);

// 2. Singleton
const getDatabase = (() => {
  let instance = null;
  class Database {
    #name;
    connect(name) {
      this.#name = name;
    }
    getName() {
      return this.#name;
    }
  }
  return () => {
    if (!instance) instance = new Database();
    return instance;
  };
})();

const dbA = getDatabase();
const dbB = getDatabase();
console.log(`singleton same instance: ${dbA === dbB}`);

// 3. Observer
class Subject {
  #subscribers = new Set();

  subscribe(fn) {
    this.#subscribers.add(fn);
  }

  unsubscribe(fn) {
    this.#subscribers.delete(fn);
  }

  notify(data) {
    for (const fn of this.#subscribers) {
      fn(data);
    }
  }
}

const subject = new Subject();
const subA = (data) => console.log(`Subscriber A got ${JSON.stringify(data)}`);
const subB = (data) => console.log(`Subscriber B got ${JSON.stringify(data)}`);

subject.subscribe(subA);
subject.subscribe(subB);
subject.notify({ event: "save" });

subject.unsubscribe(subB);
subject.notify({ event: "load" });
````

</details>