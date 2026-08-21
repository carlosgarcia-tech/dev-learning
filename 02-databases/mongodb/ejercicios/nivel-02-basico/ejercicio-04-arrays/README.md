# Ejercicio 04 — Arrays

- **Nivel:** 2/5
- **Tema:** Arrays: coincidencia exacta, `$all`, `$size`, `$elemMatch`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.peliculas.insertMany([
  { titulo: "La vida es bella", anio: 1997, generos: [{ nombre: "comedia", popular: true }, { nombre: "drama", popular: false }] },
  { titulo: "El laberinto del fauno", anio: 2006, generos: [{ nombre: "fantasia", popular: true }, { nombre: "drama", popular: false }] },
  { titulo: "Piratas del Caribe", anio: 2003, generos: [{ nombre: "aventura", popular: true }, { nombre: "accion", popular: false }, { nombre: "comedia", popular: true }] },
  { titulo: "Regreso al futuro", anio: 1985, generos: [{ nombre: "aventura", popular: false }, { nombre: "comedia", popular: true }, { nombre: "ciencia ficcion", popular: false }] },
  { titulo: "Amelie", anio: 2001, generos: [{ nombre: "comedia", popular: true }, { nombre: "romance", popular: false }] },
  { titulo: "El llanero solitario", anio: 2013, generos: [{ nombre: "aventura", popular: true }, { nombre: "comedia", popular: false }] }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Películas cuyo array `generos` coincida exactamente (mismo contenido y orden) con `[{ nombre: "comedia", popular: true }, { nombre: "drama", popular: false }]`.
2. Películas que contengan al menos un elemento `"comedia"` Y uno `"aventura"`, en cualquier orden (usa `$all`).
3. Películas con exactamente 2 elementos en `generos` (usa `$size`).
4. Películas con UN mismo elemento del array que cumpla a la vez `nombre: "aventura"` y `popular: false` (usa `$elemMatch`).

Ordena los resultados de cada consulta por `titulo` ascendente.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La coincidencia exacta de array compara contenido Y orden de los elementos.
- `$all` exige que el array contenga todos los elementos indicados, sin importar el orden.
- `$size` filtra por el número exacto de elementos del array.
- `$elemMatch` exige que UN mismo elemento cumpla todas las condiciones; un campo sin él podría combinar condiciones de elementos distintos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Películas cuyo array generos coincida exactamente (mismo contenido y orden)
db.peliculas.find(
  { generos: [{ nombre: "comedia", popular: true }, { nombre: "drama", popular: false }] },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Películas que contengan al menos un elemento "comedia" Y uno "aventura" ($all)
db.peliculas.find(
  { generos: { $all: [{ nombre: "comedia" }, { nombre: "aventura" }] } },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Películas con exactamente 2 elementos en generos (operador $size)
db.peliculas.find({ generos: { $size: 2 } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Películas con un elemento del array que cumpla DOS condiciones a la vez:
//    nombre "aventura" Y popular false (operador $elemMatch)
db.peliculas.find(
  { generos: { $elemMatch: { nombre: "aventura", popular: false } } },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
