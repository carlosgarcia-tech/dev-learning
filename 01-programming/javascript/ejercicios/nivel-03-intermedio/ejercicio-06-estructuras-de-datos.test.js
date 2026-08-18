const { test } = require("node:test");
const assert = require("node:assert/strict");
const { Stack, Queue } = require("./ejercicio-06-estructuras-de-datos");

test("Stack es LIFO", () => {
  const pila = new Stack();
  pila.push("a");
  pila.push("b");
  pila.push("c");
  assert.equal(pila.pop(), "c");
  assert.equal(pila.pop(), "b");
  assert.equal(pila.peek(), "a");
});

test("Stack.isEmpty y pop sobre vacío", () => {
  const pila = new Stack();
  assert.equal(pila.isEmpty(), true);
  assert.equal(pila.pop(), undefined);
  pila.push(1);
  assert.equal(pila.isEmpty(), false);
});

test("Queue es FIFO", () => {
  const cola = new Queue();
  cola.enqueue(1);
  cola.enqueue(2);
  cola.enqueue(3);
  assert.equal(cola.dequeue(), 1);
  assert.equal(cola.dequeue(), 2);
  assert.equal(cola.front(), 3);
});

test("Queue.isEmpty y dequeue sobre vacío", () => {
  const cola = new Queue();
  assert.equal(cola.isEmpty(), true);
  assert.equal(cola.dequeue(), undefined);
  cola.enqueue("x");
  assert.equal(cola.isEmpty(), false);
});
