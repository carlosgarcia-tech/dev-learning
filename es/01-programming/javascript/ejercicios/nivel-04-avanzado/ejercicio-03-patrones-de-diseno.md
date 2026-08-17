# Ejercicio 03 — Patrones de diseño

- **Nivel:** 4/5
- **Tema:** Module, Singleton, Observer
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `patrones.js` que implemente tres patrones:

1. **Module pattern:** un objeto `contadorModule` creado con una IIFE que exponga `incrementar()` y `obtener()`, manteniendo el estado `cuenta` **privado** (no accesible desde fuera).
2. **Singleton:** una clase `Configuracion` cuyo constructor devuelva siempre la **misma instancia** (guarda la instancia en una propiedad estática). Compruébalo con `===`.
3. **Observer:** una clase `Evento` con métodos `suscribir(fn)`, `desuscribir(fn)` y `emitir(...args)` que llame a todos los suscriptores. Crea dos suscriptores, emite un evento y luego desuscribe uno.

Salida esperada:

```
Module: cuenta 1, 2, 3
module.cuenta está oculto: undefined
Singleton: ¿misma instancia? true
Evento emitido con: Hola desde observer
Suscriptor 2 recibió: Hola desde observer
Tras desuscribir, solo responde un suscriptor
```

## Requisitos

- [ ] El estado del module pattern no debe ser accesible desde fuera.
- [ ] El singleton debe devolver siempre la misma referencia.
- [ ] El observer debe permitir suscribir, emitir y desuscribir.
- [ ] Ejecutarlo localmente con `node patrones.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- IIFE: `const mod = (() => { let privado = 0; return { ... }; })();`.
- Singleton: `constructor() { if (Configuracion.instancia) return Configuracion.instancia; Configuracion.instancia = this; }`.
- Observer: guarda los suscriptores en un array; `emitir` hace `for (const fn of this.suscritos) fn(...args)`.
- Para desuscribir, filtra por referencia de función.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const contadorModule = (() => {
  let cuenta = 0; // privado: solo accesible dentro del closure
  return {
    incrementar() {
      cuenta++;
      return cuenta;
    },
    obtener() {
      return cuenta;
    },
  };
})();

console.log(
  `Module: cuenta ${contadorModule.incrementar()}, ${contadorModule.incrementar()}, ${contadorModule.incrementar()}`
);
console.log(`module.cuenta está oculto: ${contadorModule.cuenta}`); // undefined

class Configuracion {
  constructor() {
    if (Configuracion.instancia) {
      return Configuracion.instancia;
    }
    this.tema = "claro";
    Configuracion.instancia = this;
  }
}

const conf1 = new Configuracion();
const conf2 = new Configuracion();
console.log(`Singleton: ¿misma instancia? ${conf1 === conf2}`); // true

class Evento {
  constructor() {
    this.suscritos = [];
  }

  suscribir(fn) {
    this.suscritos.push(fn);
  }

  desuscribir(fn) {
    this.suscritos = this.suscritos.filter((s) => s !== fn);
  }

  emitir(...args) {
    for (const fn of this.suscritos) {
      fn(...args);
    }
  }
}

const evento = new Evento();
const sus1 = (m) => console.log(`Suscriptor 1 recibió: ${m}`);
const sus2 = (m) => console.log(`Suscriptor 2 recibió: ${m}`);

evento.suscribir(sus1);
evento.suscribir(sus2);
evento.emitir("Hola desde observer");

evento.desuscribir(sus2);
evento.emitir("Tras desuscribir, solo responde un suscriptor");
````

</details>