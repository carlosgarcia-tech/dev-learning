# Ejercicio 01 — Async/Await

- **Nivel:** 4/5
- **Tema:** async/await, try/catch en asincronía
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `async-await.js` que:

1. Defina `simularPeticion(ms, fallar = false)` que devuelva una promesa que se resuelve tras `ms` con `"Respuesta lista"`, o se rechaza con `new Error("Error de red")` si `fallar` es `true`.
2. Defina una función `async` `obtenerDatos()` que con `await` espere la petición e imprima el resultado dentro de un try/catch.
3. Llame a `obtenerDatos()` dos veces: una exitosa y una que falla.
4. Defina `obtenerTodo()` que use `Promise.all` con `await` para ejecutar tres peticiones de 100/200/300 ms en paralelo e imprima los resultados.
5. Imprima `"Inicio"` y `"Fin"` fuera de las funciones async para demostrar que el programa no se bloquea.

Salida esperada:

```
Inicio
Respuesta lista
Error: Error de red
Todas: [ 'Respuesta lista', 'Respuesta lista', 'Respuesta lista' ]
Fin
```

## Requisitos

- [ ] Usar `async function` y `await`.
- [ ] Capturar errores de promesas con `try/catch`.
- [ ] Combinar `await` con `Promise.all`.
- [ ] Ejecutarlo localmente con `node async-await.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `await` solo funciona dentro de funciones `async`.
- Un rechazo dentro de un `await` se convierte en excepción capturada por `catch`.
- Para `Promise.all` con await: `const resultados = await Promise.all([...])`.
- `Inicio` y `Fin` se imprimen sincrónicamente; lo demás llega cuando resuelven las promesas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function simularPeticion(ms, fallar = false) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (fallar) {
        reject(new Error("Error de red"));
      } else {
        resolve("Respuesta lista");
      }
    }, ms);
  });
}

async function obtenerDatos(fallar) {
  try {
    const resultado = await simularPeticion(200, fallar);
    console.log(resultado);
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }
}

async function obtenerTodo() {
  const todas = await Promise.all([
    simularPeticion(100),
    simularPeticion(200),
    simularPeticion(300),
  ]);
  console.log(`Todas: ${todas}`);
}

console.log("Inicio");
obtenerDatos(false);
obtenerDatos(true);
obtenerTodo();
console.log("Fin");
````

</details>