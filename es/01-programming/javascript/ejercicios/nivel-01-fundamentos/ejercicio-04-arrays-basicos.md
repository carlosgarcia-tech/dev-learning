# Ejercicio 04 — Arrays básicos

- **Nivel:** 1/5
- **Tema:** Crear, indexar, push/pop/shift/unshift
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `arrays.js` que:

1. Cree un array `tareas = ["estudiar", "cocinar", "dormir"]`.
2. Imprima la longitud y el primer y último elemento (usa `tareas[tareas.length - 1]`).
3. Añada "leer" al final con `.push()` y muestre el array.
4. Quite el último con `.pop()` y muestre el elemento quitado y el array resultante.
5. Añada "correr" al inicio con `.unshift()` y muestre el array.
6. Quite el primero con `.shift()` y muestre el elemento quitado y el array resultante.

Salida esperada (ejemplo):

```
Longitud: 3
Primero: estudiar
Último: dormir
Después de push: [ 'estudiar', 'cocinar', 'dormir', 'leer' ]
pop() quita: leer -> [ 'estudiar', 'cocinar', 'dormir' ]
Después de unshift: [ 'correr', 'estudiar', 'cocinar', 'dormir' ]
shift() quita: correr -> [ 'estudiar', 'cocinar', 'dormir' ]
```

## Requisitos

- [ ] Crear el array y acceder por índice y por `.length`.
- [ ] Usar `push`, `pop`, `unshift` y `shift`.
- [ ] Imprimir el valor devuelto por `pop` y `shift` (devuelven el elemento quitado).
- [ ] Ejecutarlo localmente con `node arrays.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-04-arrays-basicos.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los índices empiezan en 0, así que el primer elemento es `arr[0]`.
- `push` y `unshift` devuelven la nueva longitud; `pop` y `shift` devuelven el elemento quitado.
- `console.log(arr)` muestra el array completo; `console.log(arr.join(", "))` lo muestra como texto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function primerElemento(arr) {
  return arr[0];
}

function ultimoElemento(arr) {
  return arr[arr.length - 1];
}

function agregarAlFinal(arr, item) {
  arr.push(item);
  return arr;
}

function quitarDelFinal(arr) {
  const quitado = arr.pop();
  return { quitado, array: arr };
}

function agregarAlInicio(arr, item) {
  arr.unshift(item);
  return arr;
}

function quitarDelInicio(arr) {
  const quitado = arr.shift();
  return { quitado, array: arr };
}

if (require.main === module) {
  const tareas = ["estudiar", "cocinar", "dormir"];
  console.log(`Longitud: ${tareas.length}`);
  console.log(`Primero: ${primerElemento(tareas)}`);
  console.log(`Último: ${ultimoElemento(tareas)}`);
  console.log(`Después de push: ${agregarAlFinal(tareas, "leer")}`);
  const pop = quitarDelFinal(tareas);
  console.log(`pop() quita: ${pop.quitado} -> ${pop.array}`);
  console.log(`Después de unshift: ${agregarAlInicio(tareas, "correr")}`);
  const shift = quitarDelInicio(tareas);
  console.log(`shift() quita: ${shift.quitado} -> ${shift.array}`);
}

module.exports = {
  primerElemento,
  ultimoElemento,
  agregarAlFinal,
  quitarDelFinal,
  agregarAlInicio,
  quitarDelInicio,
};
````

</details>