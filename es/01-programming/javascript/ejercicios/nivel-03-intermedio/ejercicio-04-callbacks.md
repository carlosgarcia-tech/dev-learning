# Ejercicio 04 — Callbacks

- **Nivel:** 3/5
- **Tema:** Callbacks, funciones de orden superior
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `callbacks.js` que:

1. Defina `operacion(a, b, callback)` que llame a `callback(a, b)` y devuelva su resultado.
2. Pase callbacks `suma`, `resta` y `multiplica` (definidas como funciones normales) a `operacion`.
3. Defina `procesarLista(lista, transformacion)` que use `map` internamente con el callback y devuelva el array transformado.
4. Simule una operación asíncrona `leerDato(callback)` que use `setTimeout` de 500 ms y llame a `callback("dato leído")`.
5. Imprima todos los resultados, mostrando que el último se imprime después de 500 ms.

Salida esperada:

```
operacion suma: 8
operacion resta: 2
operacion multiplica: 15
Lista transformada: [ 2, 4, 6, 8, 10 ]
(esperando 500 ms...)
Callback async: dato leído
```

## Requisitos

- [ ] Pasar funciones como argumentos (callbacks).
- [ ] Usar un callback dentro de `map`.
- [ ] Simular asincronía con `setTimeout`.
- [ ] Ejecutarlo localmente con `node callbacks.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-04-callbacks.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un callback es simplemente una función que se pasa como argumento.
- `operacion` debe llamar: `return callback(a, b);`.
- `setTimeout(callback, 500)` ejecuta el callback después de 500 ms.
- La salida del callback async aparece al final porque `setTimeout` no bloquea.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function operacion(a, b, callback) {
  return callback(a, b);
}

function suma(a, b) {
  return a + b;
}

function resta(a, b) {
  return a - b;
}

function multiplica(a, b) {
  return a * b;
}

function procesarLista(lista, transformacion) {
  return lista.map(transformacion);
}

function leerDato(callback) {
  setTimeout(() => callback("dato leído"), 500);
}

if (require.main === module) {
  console.log(`operacion suma: ${operacion(5, 3, suma)}`);
  console.log(`operacion resta: ${operacion(5, 3, resta)}`);
  console.log(`operacion multiplica: ${operacion(5, 3, multiplica)}`);
  console.log(`Lista transformada: ${procesarLista([1, 2, 3, 4, 5], (n) => n * 2)}`);
  console.log("(esperando 500 ms...)");
  leerDato((dato) => console.log(`Callback async: ${dato}`));
}

module.exports = { operacion, suma, resta, multiplica, procesarLista, leerDato };
````

</details>