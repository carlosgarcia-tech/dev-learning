# Ejercicio 03 — Lookup (Join)

- **Nivel:** 3/5
- **Tema:** `$lookup`, `$unwind`, `$size`, `$match`, `$project`
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.autores.insertMany([
  { _id: "a1", nombre: "Gabriel García Márquez", nacionalidad: "colombiana" },
  { _id: "a2", nombre: "Isabel Allende", nacionalidad: "chilena" },
  { _id: "a3", nombre: "Jorge Luis Borges", nacionalidad: "argentina" },
  { _id: "a4", nombre: "Julio Cortázar", nacionalidad: "argentina" }
]);
db.libros.insertMany([
  { _id: "l1", titulo: "Cien años de soledad", autor_id: "a1", anio: 1967 },
  { _id: "l2", titulo: "El amor en los tiempos del cólera", autor_id: "a1", anio: 1985 },
  { _id: "l3", titulo: "La casa de los espíritus", autor_id: "a2", anio: 1982 },
  { _id: "l4", titulo: "Inés del alma mía", autor_id: "a2", anio: 2006 },
  { _id: "l5", titulo: "Ficciones", autor_id: "a3", anio: 1944 },
  { _id: "l6", titulo: "Rayuela", autor_id: "a4", anio: 1963 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Une `libros` con `autores` mediante `$lookup` (`localField: "autor_id"`, `foreignField: "_id"`), aplana con `$unwind` y proyecta `_id: 0` con `titulo`, `anio`, `autor` y `nacionalidad`.
2. Sin usar `$unwind`, cuenta los libros de cada autor con `$size` sobre el array que devuelve el `$lookup`.
3. Filtra con `$match` los libros con `anio > 2000`, vuelve a unirlos con `$lookup` y proyecta `_id: 0` con `titulo`, `anio` y `autor`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `$lookup` de `libros` hacia `autores` usa `localField: "autor_id"` y `foreignField: "_id"`.
- Tras `$lookup` el resultado es un array: usa `$unwind` para aplanarlo o `$size` para contarlo.
- Los campos del documento unido se referencian como `$autor.nombre`, `$autor.nacionalidad`, etc.
- No proyectes el `_id` de los documentos unidos: proyección `_id: 0` al final.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $lookup libros -> autores por autor_id, $unwind y proyección {_id:0}
db.libros.aggregate([
  { $lookup: {
      from: "autores",
      localField: "autor_id",
      foreignField: "_id",
      as: "autor"
  } },
  { $unwind: "$autor" },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre", nacionalidad: "$autor.nacionalidad" } },
  { $sort: { titulo: 1 } }
]).forEach(d => printjson(d));

// 2. $lookup sin $unwind: contar libros por autor con $size
db.autores.aggregate([
  { $lookup: {
      from: "libros",
      localField: "_id",
      foreignField: "autor_id",
      as: "libros"
  } },
  { $project: { _id: 0, autor: "$nombre", nacionalidad: 1, num_libros: { $size: "$libros" } } },
  { $sort: { autor: 1 } }
]).forEach(d => printjson(d));

// 3. $match anio > 2000 + $lookup + proyección {_id:0}
db.libros.aggregate([
  { $match: { anio: { $gt: 2000 } } },
  { $lookup: {
      from: "autores",
      localField: "autor_id",
      foreignField: "_id",
      as: "autor"
  } },
  { $unwind: "$autor" },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre" } },
  { $sort: { titulo: 1 } }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
