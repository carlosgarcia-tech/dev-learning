# Exercise 06 — Data Structures

- **Level:** 3/5
- **Topic:** Stack and queue from scratch
- **Estimated time:** 20 min

## Statement

Implement a `Stack` and a `Queue` class from scratch using a plain array as storage. Do not use the built-in `Array` mutators for the operations — use `length` and index arithmetic so you see what is really happening.

**Stack** (LIFO):
- `push(item)` — add to top.
- `pop()` — remove and return the top; return `null` if empty.
- `peek()` — return the top without removing.
- `isEmpty()` — boolean.
- `size()` — number of items.

**Queue** (FIFO):
- `enqueue(item)` — add to back.
- `dequeue()` — remove and return the front; return `null` if empty.
- `front()` — return the front without removing.
- `isEmpty()` — boolean.
- `size()` — number of items.

Test both:

```text
Stack: push 1,2,3 -> peek 3, pop 3, pop 2, size 1
Queue: enqueue a,b,c -> front a, dequeue a, dequeue b, size 1
```

Print the result of every operation.

## Requirements

- [ ] Implements `Stack` with all 5 methods
- [ ] Implements `Queue` with all 5 methods
- [ ] Uses only array length/index operations (no `push`/`pop`/`shift`/`unshift`)
- [ ] Handles empty structures by returning `null`
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Stack top = last element: `this.items[this.items.length - 1]`; push writes at `this.items[this.items.length] = item`; pop removes by shortening length.
- Queue back = last element too, but `dequeue` returns `this.items[0]` and then shifts everything left with a `for` loop.
- Keep an internal `#items` array; expose only the 5 methods.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
class Stack {
  #items = [];

  push(item) {
    this.#items[this.#items.length] = item;
  }

  pop() {
    if (this.isEmpty()) return null;
    const top = this.#items[this.#items.length - 1];
    this.#items.length--;
    return top;
  }

  peek() {
    return this.isEmpty() ? null : this.#items[this.#items.length - 1];
  }

  isEmpty() {
    return this.#items.length === 0;
  }

  size() {
    return this.#items.length;
  }
}

class Queue {
  #items = [];

  enqueue(item) {
    this.#items[this.#items.length] = item;
  }

  dequeue() {
    if (this.isEmpty()) return null;
    const front = this.#items[0];
    for (let i = 0; i < this.#items.length - 1; i++) {
      this.#items[i] = this.#items[i + 1];
    }
    this.#items.length--;
    return front;
  }

  front() {
    return this.isEmpty() ? null : this.#items[0];
  }

  isEmpty() {
    return this.#items.length === 0;
  }

  size() {
    return this.#items.length;
  }
}

const stack = new Stack();
stack.push(1);
stack.push(2);
stack.push(3);
console.log(`Stack peek: ${stack.peek()}`);
console.log(`Stack pop: ${stack.pop()}`);
console.log(`Stack pop: ${stack.pop()}`);
console.log(`Stack size: ${stack.size()}`);
console.log(`Stack empty: ${stack.isEmpty()}`);

const queue = new Queue();
queue.enqueue("a");
queue.enqueue("b");
queue.enqueue("c");
console.log(`Queue front: ${queue.front()}`);
console.log(`Queue dequeue: ${queue.dequeue()}`);
console.log(`Queue dequeue: ${queue.dequeue()}`);
console.log(`Queue size: ${queue.size()}`);
console.log(`Queue empty: ${queue.isEmpty()}`);
````

</details>