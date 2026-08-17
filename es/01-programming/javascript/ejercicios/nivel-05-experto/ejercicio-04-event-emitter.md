# Ejercicio 04 — Event Emitter

- **Nivel:** 5/5
- **Tema:** Clase EventEmitter propia
- **Tiempo estimado:** 35 min

## Enunciado

Crea un archivo `event-emitter.js` que implemente tu propio `EventEmitter` (similar al módulo `node:events`) con:

1. Método `on(evento, listener)` — registra un listener para un evento.
2. Método `once(evento, listener)` — registra un listener que se ejecuta una sola vez y luego se auto-elimina.
3. Método `emit(evento, ...args)` — llama a todos los listeners del evento con los argumentos.
4. Método `off(evento, listener)` — elimina un listener concreto.
5. Método `listeners(evento)` — devuelve el array de listeners de un evento.

Prueba:

```javascript
const emisor = new EventEmitter();

const saludar = (nombre) => console.log(`Hola, ${nombre}!`);
const despedir = (nombre) => console.log(`Adiós, ${nombre}!`);

emisor.on("saludo", saludar);
emisor.once("saludo", despedir); // solo se ejecutará 1 vez

emisor.emit("saludo", "Ana"); // Hola, Ana! + Adiós, Ana!
emisor.emit("saludo", "Luis"); // solo Hola, Luis! (once ya se eliminó)

emisor.off("saludo", saludar);
emisor.emit("saludo", "Pedro"); // no imprime nada

console.log(emisor.listeners("saludo")); // []
```

## Requisitos

- [ ] Implementar los 5 métodos (`on`, `once`, `emit`, `off`, `listeners`).
- [ ] `once` debe ejecutarse una sola vez.
- [ ] `off` debe eliminar exactamente el listener indicado.
- [ ] `emit` debe pasar los argumentos a cada listener.
- [ ] Ejecutarlo localmente con `node event-emitter.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Guarda los listeners en un objeto `Map` donde cada clave es el nombre del evento y el valor es un array.
- Para `once`, envuelve el listener en una función que llame a `off` antes/después de ejecutarse.
- `emit` recorre `this.registros.get(evento) || []` llamando a cada uno con `(...args)`.
- Cuidado con modificar el array mientras iteras; `once` elimina durante el `emit`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
class EventEmitter {
  constructor() {
    this.registros = new Map();
  }

  on(evento, listener) {
    if (!this.registros.has(evento)) {
      this.registros.set(evento, []);
    }
    this.registros.get(evento).push(listener);
  }

  once(evento, listener) {
    const envoltorio = (...args) => {
      this.off(evento, envoltorio);
      listener(...args);
    };
    envoltorio.original = listener;
    this.on(evento, envoltorio);
  }

  off(evento, listener) {
    const lista = this.registros.get(evento);
    if (!lista) return;
    this.registros.set(
      evento,
      lista.filter((l) => l !== listener && l.original !== listener)
    );
  }

  emit(evento, ...args) {
    const lista = this.registros.get(evento) || [];
    for (const listener of [...lista]) {
      listener(...args);
    }
  }

  listeners(evento) {
    return this.registros.get(evento) || [];
  }
}

const emisor = new EventEmitter();

const saludar = (nombre) => console.log(`Hola, ${nombre}!`);
const despedir = (nombre) => console.log(`Adiós, ${nombre}!`);

emisor.on("saludo", saludar);
emisor.once("saludo", despedir);

emisor.emit("saludo", "Ana"); // Hola, Ana! + Adiós, Ana!
emisor.emit("saludo", "Luis"); // solo Hola, Luis!

emisor.off("saludo", saludar);
emisor.emit("saludo", "Pedro"); // nada

console.log(emisor.listeners("saludo")); // []
````

</details>