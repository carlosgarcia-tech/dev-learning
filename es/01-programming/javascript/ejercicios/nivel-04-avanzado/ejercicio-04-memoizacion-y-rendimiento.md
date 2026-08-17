# Ejercicio 04 — Memoización y rendimiento

- **Nivel:** 4/5
- **Tema:** Debounce y throttle
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `perf.js` que implemente las dos técnicas de control de frecuencia:

1. `debounce(fn, espera)` — devuelve una función que **retrasa** la ejecución de `fn` hasta que pasen `espera` ms sin nuevas llamadas. Solo se ejecuta una vez tras la "ráfaga" de llamadas.
2. `throttle(fn, limite)` — devuelve una función que ejecuta `fn` **como máximo una vez** cada `limite` ms, incluso si se llama más seguido.
3. Usa `setTimeout` y `setInterval` para probar: llama al debounced 5 veces rápido (debe ejecutarse una sola vez al final) y llama al throttled cada 100 ms durante 1 segundo con límite de 250 ms (debe ejecutarse unas 4 veces).

Salida esperada (aproximada):

```
Debounce: llamada número 1 (la única que se ejecuta al final)
Throttle: ejecución 1
Throttle: ejecución 2
Throttle: ejecución 3
Throttle: ejecución 4
```

## Requisitos

- [ ] Implementar `debounce` con `clearTimeout`/`setTimeout`.
- [ ] Implementar `throttle` usando marcas de tiempo o timer.
- [ ] La prueba con timers demuestra que el debounce ejecuta 1 vez y el throttle unas 4 en 1 segundo.
- [ ] Ejecutarlo localmente con `node perf.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Debounce: guarda `timerId` y haz `clearTimeout(timerId)` en cada llamada; reasigna `setTimeout(fn, espera)`.
- Throttle: compara `Date.now()` con la última ejecución; si ya pasó el límite, ejecuta y actualiza la marca.
- Para probar el throttle usa `setInterval(..., 100)` y detenlo con `clearInterval` después de 1 segundo.
- El debounce necesita que "esperes" más de `espera` ms sin llamar para que se ejecute.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function debounce(fn, espera) {
  let timerId;
  return function (...args) {
    clearTimeout(timerId);
    timerId = setTimeout(() => fn(...args), espera);
  };
}

function throttle(fn, limite) {
  let ultima = 0;
  return function (...args) {
    const ahora = Date.now();
    if (ahora - ultima >= limite) {
      ultima = ahora;
      fn(...args);
    }
  };
}

let conteoDebounce = 0;
const debounced = debounce(() => {
  conteoDebounce++;
  console.log(`Debounce: ejecución número ${conteoDebounce}`);
}, 300);

for (let i = 0; i < 5; i++) {
  debounced();
}
console.log("(5 llamadas rápidas al debounce; solo una debe ejecutarse al final)");

let ejecuciones = 0;
const throttled = throttle(() => {
  ejecuciones++;
  console.log(`Throttle: ejecución ${ejecuciones}`);
}, 250);

const intervalo = setInterval(() => throttled(), 100);
setTimeout(() => {
  clearInterval(intervalo);
  console.log("Fin de la prueba de throttle");
}, 1000);
````

</details>