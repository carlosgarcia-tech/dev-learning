# Exercise 04 — Event Emitter

- **Level:** 5/5
- **Topic:** Own `EventEmitter` class
- **Estimated time:** 35 min

## Statement

Implement your own `EventEmitter` class (the same idea as `node:events` but from scratch). Do not import `node:events`.

`class EventEmitter`:

- `on(event, listener)` — registers a listener; returns the emitter (chainable). If `event` already has listeners, append.
- `once(event, listener)` — registers a listener that is removed after being called once.
- `off(event, listener)` — removes a specific listener.
- `emit(event, ...args)` — calls every listener with the args, in registration order. Returns `false` if the event had no listeners, `true` otherwise. An exception in one listener should not stop the others (wrap each call in `try`/`catch`).
- `listenerCount(event)` — number of listeners for an event.

Test:

1. Register two `on` listeners for `"tick"`; emit `tick(1)` and `tick(2)` — both fire each time.
2. Register a `once` listener for `"one"`; emit `one()` twice — fires only once.
3. `off` removes a listener — verify it no longer fires.
4. Emit an event with no listeners → returns `false`.
5. A listener that throws must not prevent the next listener from running.

## Requirements

- [ ] Implements `on`, `once`, `off`, `emit`, `listenerCount`
- [ ] `on` returns `this` for chaining
- [ ] `once` removes itself after the first emit
- [ ] `emit` catches exceptions per listener
- [ ] `emit` returns a boolean indicating whether listeners existed
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Store listeners in a `Map` of event name → array of functions.
- For `once`, wrap the user function: call it, then remove itself via `off`.
- To avoid mutation during iteration, iterate over a copy: `[...listeners]`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
class EventEmitter {
  #listeners = new Map();

  on(event, listener) {
    if (!this.#listeners.has(event)) this.#listeners.set(event, []);
    this.#listeners.get(event).push(listener);
    return this;
  }

  once(event, listener) {
    const wrapper = (...args) => {
      this.off(event, wrapper);
      listener(...args);
    };
    return this.on(event, wrapper);
  }

  off(event, listener) {
    const listeners = this.#listeners.get(event);
    if (!listeners) return this;
    const index = listeners.indexOf(listener);
    if (index !== -1) listeners.splice(index, 1);
    return this;
  }

  emit(event, ...args) {
    const listeners = this.#listeners.get(event);
    if (!listeners || listeners.length === 0) return false;
    for (const listener of [...listeners]) {
      try {
        listener(...args);
      } catch (err) {
        console.error(`listener error: ${err.message}`);
      }
    }
    return true;
  }

  listenerCount(event) {
    const listeners = this.#listeners.get(event);
    return listeners ? listeners.length : 0;
  }
}

const emitter = new EventEmitter();

const logA = (n) => console.log(`A tick ${n}`);
const logB = (n) => console.log(`B tick ${n}`);

emitter.on("tick", logA).on("tick", logB);
emitter.emit("tick", 1);
emitter.emit("tick", 2);

emitter.once("one", () => console.log("once fired"));
emitter.emit("one");
emitter.emit("one"); // does nothing

emitter.off("tick", logB);
emitter.emit("tick", 3); // only A

console.log(`emit with no listeners -> ${emitter.emit("missing")}`);

emitter.on("noisy", () => {
  throw new Error("boom");
});
emitter.on("noisy", () => console.log("still runs after error"));
emitter.emit("noisy");

console.log(`listenerCount('tick') -> ${emitter.listenerCount("tick")}`);
````

</details>