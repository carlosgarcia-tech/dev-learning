# Ejercicio 05 — Atlas Search

- **Nivel:** 5/5
- **Tema:** índices, $text, $search, $meta textScore, exclusión y $match combinado
- **Tiempo estimado:** 25 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.libros.insertMany([
  { titulo: "Aventuras en la isla del tesoro", autor: "R. L. Stevenson", genero: "aventura", anio: 1883 },
  { titulo: "Las aventuras de Huckleberry Finn", autor: "Mark Twain", genero: "aventura", anio: 1884 },
  { titulo: "Aventura en el espacio profundo", autor: "Carlos Mendez", genero: "ciencia ficcion", anio: 1998 },
  { titulo: "Misterio en la mansion", autor: "Sara Lopez", genero: "misterio", anio: 1975 },
  { titulo: "El misterio del faro", autor: "Sara Lopez", genero: "misterio", anio: 2005 },
  { titulo: "El tesoro perdido", autor: "Julio Verne", genero: "aventura", anio: 1869 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Crea un índice simple sobre `genero` con `createIndex({ genero: 1 })`.
2. Busca con `$text $search: "aventura"` mostrando `titulo` y el `score` (`$meta: "textScore"`), ordenado por score de mayor a menor.
3. Busca `"aventura"` excluyendo los libros que contengan `espacio` (usa `-` delante de la palabra).
4. Combina `$text $search: "misterio"` con un filtro adicional `anio: { $gt: 1950 }`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-05-atlas-search-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para usar `$text` primero debe existir un índice de texto: `db.libros.createIndex({ titulo: "text" })`.
- El score se proyecta con `score: { $meta: "textScore" }` y se ordena también con `{ $meta: "textScore" }`; añade `titulo: 1` como desempate para un orden estable.
- La exclusión usa el prefijo `-` dentro de `$search` (ej. `"aventura -espacio"`).
- Puedes combinar `$text` y un filtro de campo normal en el mismo `find` (ej. `anio: { $gt: 1950 }`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Índice simple sobre genero
print(db.libros.createIndex({ genero: 1 }));

// Índice de texto (necesario para $text) sobre titulo
print(db.libros.createIndex({ titulo: "text" }));

// 2. $text $search "aventura": score ($meta textScore), orden por score desc
db.libros.find(
  { $text: { $search: "aventura" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

// 3. Búsqueda $text con exclusión de palabra
db.libros.find(
  { $text: { $search: "aventura -espacio" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. $text combinado con $match adicional (anio > 1950)
db.libros.find(
  { $text: { $search: "misterio" }, anio: { $gt: 1950 } },
  { _id: 0, titulo: 1, genero: 1, anio: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-atlas-search-test.sh   # requiere podman (levanta mongo efímero)
```