# Ejercicio 06 — Estructuras de datos

- **Nivel:** 3/5
- **Tema:** Stack y queue desde cero
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `estructuras.js` que implemente dos estructuras de datos desde cero con arrays:

1. **Stack (pila):** clase `Stack` con métodos `push(valor)`, `pop()`, `peek()` y `isEmpty()`. LIFO (Last In, First Out).
2. **Queue (cola):** clase `Queue` con métodos `enqueue(valor)`, `dequeue()`, `front()` y `isEmpty()`. FIFO (First In, First Out).
3. En el programa principal:
   - En un `Stack`, haz `push` de `["a", "b", "c"]`, haz `pop` dos veces e imprime cada valor sacado y el `peek` resultante.
   - En una `Queue`, haz `enqueue` de `[1, 2, 3]`, haz `dequeue` dos veces e imprime cada valor y el `front` resultante.

Salida esperada:

```
Stack: saca "c"
Stack: saca "b"
Stack: peek -> "a"
Queue: saca 1
Queue: saca 2
Queue: front -> 3
```

## Requisitos

- [ ] Implementar `Stack` y `Queue` como clases con sus métodos.
- [ ] Verificar el comportamiento LIFO del stack y FIFO de la queue.
- [ ] Manejar el caso de `pop`/`dequeue` sobre una estructura vacía (devolver `undefined` o lanzar error definido).
- [ ] Ejecutarlo localmente con `node estructuras.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Stack: usa `push`/`pop` de array (operan al final).
- Queue: `push` para encolar y `shift` para sacar el primero (o mantén un índice si buscas eficiencia).
- `peek()` debe devolver el elemento sin quitarlo: `this.items[this.items.length - 1]`.
- `front()` devuelve el primero sin quitarlo: `this.items[0]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
class Stack {
  constructor() {
    this.items = [];
  }

  push(valor) {
    this.items.push(valor);
  }

  pop() {
    return this.items.pop();
  }

  peek() {
    return this.items[this.items.length - 1];
  }

  isEmpty() {
    return this.items.length === 0;
  }
}

class Queue {
  constructor() {
    this.items = [];
  }

  enqueue(valor) {
    this.items.push(valor);
  }

  dequeue() {
    return this.items.shift();
  }

  front() {
    return this.items[0];
  }

  isEmpty() {
    return this.items.length === 0;
  }
}

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
````

</details>