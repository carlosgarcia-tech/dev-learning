class Stack {
  constructor() {
    // TODO: this.items = [].
    throw new Error("TODO: implementar el constructor de Stack");
  }

  push(valor) {
    // TODO: añade al final (LIFO).
    throw new Error("TODO: implementar Stack.push(valor)");
  }

  pop() {
    // TODO: quita y devuelve el último.
    throw new Error("TODO: implementar Stack.pop()");
  }

  peek() {
    // TODO: devuelve el último sin quitarlo.
    throw new Error("TODO: implementar Stack.peek()");
  }

  isEmpty() {
    // TODO: true si no hay elementos.
    throw new Error("TODO: implementar Stack.isEmpty()");
  }
}

class Queue {
  constructor() {
    // TODO: this.items = [].
    throw new Error("TODO: implementar el constructor de Queue");
  }

  enqueue(valor) {
    // TODO: encola al final (FIFO).
    throw new Error("TODO: implementar Queue.enqueue(valor)");
  }

  dequeue() {
    // TODO: quita y devuelve el primero.
    throw new Error("TODO: implementar Queue.dequeue()");
  }

  front() {
    // TODO: devuelve el primero sin quitarlo.
    throw new Error("TODO: implementar Queue.front()");
  }

  isEmpty() {
    // TODO: true si no hay elementos.
    throw new Error("TODO: implementar Queue.isEmpty()");
  }
}

if (require.main === module) {
  const pila = new Stack();
  for (const letra of ["a", "b", "c"]) pila.push(letra);
  console.log(`Stack: saca "${pila.pop()}"`);
  console.log(`Stack: saca "${pila.pop()}"`);
  console.log(`Stack: peek -> "${pila.peek()}"`);

  const cola = new Queue();
  for (const n of [1, 2, 3]) cola.enqueue(n);
  console.log(`Queue: saca ${cola.dequeue()}`);
  console.log(`Queue: saca ${cola.dequeue()}`);
  console.log(`Queue: front -> ${cola.front()}`);
}

module.exports = { Stack, Queue };
