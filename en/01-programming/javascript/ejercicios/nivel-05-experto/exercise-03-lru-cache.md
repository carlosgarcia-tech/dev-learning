# Exercise 03 — LRU Cache

- **Level:** 5/5
- **Topic:** Implement an LRU cache
- **Estimated time:** 35 min

## Statement

Implement an LRU (Least Recently Used) cache with a fixed capacity. When the cache is full and a new key is inserted, evict the *least recently used* entry.

`class LRUCache`:

- `constructor(capacity)` — positive integer capacity; throw on invalid values.
- `get(key)` — returns the value, or `-1` if missing. Accessing a key marks it as recently used (moves it to the most-recent position).
- `put(key, value)` — inserts or updates a key, marking it most-recent. If the cache is full, evicts the least recently used key first.
- `size()` — number of entries currently stored.

Data structures: use a `Map` (which preserves insertion order) plus internal bookkeeping, or a doubly linked list. If you use a `Map`, remember that `map.delete(key); map.set(key, value)` re-inserts to refresh order. Implement a manual linked list version too and be able to explain the O(1) claim.

Test:

```text
put(1, "a"), put(2, "b"), put(3, "c")   capacity 3
get(1) -> a        (now 1 is most recent)
put(4, "d")        (capacity full -> evicts 2)
get(2) -> -1
get(3) -> c
get(4) -> d
get(1) -> a
```

## Requirements

- [ ] Has a fixed capacity and rejects invalid capacity values
- [ ] `get` returns `-1` for missing keys
- [ ] `put` evicts the least recently used entry when full
- [ ] Every operation runs in O(1) amortized time (using `Map` ordering or a linked list)
- [ ] Prints the expected test output above
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- With a `Map`, "most recent" = last inserted. On `get`, do `delete` + `set` to move it to the end.
- On eviction, `map.keys().next().value` gives the oldest key — the first inserted one.
- For a linked-list version, keep a map of `key -> node` plus `head`/`tail` sentinels.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
class LRUCache {
  #capacity;
  #map;

  constructor(capacity) {
    if (!Number.isInteger(capacity) || capacity <= 0) {
      throw new Error("capacity must be a positive integer");
    }
    this.#capacity = capacity;
    this.#map = new Map();
  }

  get(key) {
    if (!this.#map.has(key)) return -1;
    const value = this.#map.get(key);
    this.#map.delete(key);
    this.#map.set(key, value); // move to most-recent (end)
    return value;
  }

  put(key, value) {
    if (this.#map.has(key)) {
      this.#map.delete(key);
    }
    this.#map.set(key, value);
    if (this.#map.size > this.#capacity) {
      const oldest = this.#map.keys().next().value;
      this.#map.delete(oldest);
    }
  }

  size() {
    return this.#map.size;
  }
}

const cache = new LRUCache(3);
cache.put(1, "a");
cache.put(2, "b");
cache.put(3, "c");
console.log(`get(1) -> ${cache.get(1)}`); // a, now 1 is most recent
cache.put(4, "d"); // full -> evicts 2
console.log(`get(2) -> ${cache.get(2)}`); // -1
console.log(`get(3) -> ${cache.get(3)}`); // c
console.log(`get(4) -> ${cache.get(4)}`); // d
console.log(`get(1) -> ${cache.get(1)}`); // a
console.log(`size -> ${cache.size()}`);
````

</details>