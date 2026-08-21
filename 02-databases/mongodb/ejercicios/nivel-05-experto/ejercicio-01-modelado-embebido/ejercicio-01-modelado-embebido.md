# Ejercicio 01 — Modelado Embebido

- **Nivel:** 5/5
- **Tema:** modelado embebido, dot notation, operadores de arrays
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.posts.insertMany([
  {
    titulo: "Modelado embebido en MongoDB",
    autor: { nombre: "Ana", email: "ana@mail.com" },
    comentarios: [
      { usuario: "Luis", texto: "Muy claro, gracias." },
      { usuario: "Sara", texto: "¿Y cuándo conviene referenciar?" }
    ]
  },
  {
    titulo: "Transacciones en MongoDB",
    autor: { nombre: "Luis", email: "luis@mail.com" },
    comentarios: [
      { usuario: "Ana", texto: "Interesante." },
      { usuario: "Sara", texto: "Buen ejemplo." },
      { usuario: "Marta", texto: "Gracias por compartir." }
    ]
  },
  {
    titulo: "Indices y rendimiento",
    autor: { nombre: "Ana", email: "ana@mail.com" },
    comentarios: [
      { usuario: "Luis", texto: "Útil para producción." }
    ]
  }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Muestra el post `"Modelado embebido en MongoDB"` completo con su autor y sus comentarios embebidos (proyección `_id: 0`).
2. Muestra los títulos de los posts cuyo autor tiene email `ana@mail.com` (usa dot notation `"autor.email"`).
3. Añade con `$push` un comentario nuevo `{ usuario: "Marta", texto: "¿Dónde hay más ejemplos?" }` al post anterior y muestra el post actualizado.
4. Proyección que muestre solo `titulo` y `comentarios` de todos los posts.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-01-modelado-embebido-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En un modelo embebido el autor y los comentarios viven dentro del propio documento: no hace falta `$lookup`.
- Para filtrar por un campo anidado usa la notación de punto entre comillas: `{ "autor.email": "ana@mail.com" }`.
- `$push` inserta un elemento al final de un array; combínalo con `updateOne` y un filtro por `titulo`.
- Ordena los resultados con `.sort({ titulo: 1 })` para que la salida sea estable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Post completo con sus comentarios (doc embebido, _id:0)
printjson(db.posts.findOne(
  { titulo: "Modelado embebido en MongoDB" },
  { _id: 0, titulo: 1, autor: 1, comentarios: 1 }
));

// 2. Posts de un autor (dot notation)
db.posts.find(
  { "autor.email": "ana@mail.com" },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. $push un comentario nuevo a un post
db.posts.updateOne(
  { titulo: "Modelado embebido en MongoDB" },
  { $push: { comentarios: { usuario: "Marta", texto: "¿Dónde hay más ejemplos?" } } }
);
printjson(db.posts.findOne(
  { titulo: "Modelado embebido en MongoDB" },
  { _id: 0, titulo: 1, comentarios: 1 }
));

// 4. Proyección mostrando solo título y comentarios
db.posts.find(
  {},
  { _id: 0, titulo: 1, comentarios: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-modelado-embebido-test.sh   # requiere podman (levanta mongo efímero)
```