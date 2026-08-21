# Ejercicio 03 — Proyección

- **Nivel:** 1/5
- **Tema:** proyección en find (inclusiva y exclusiva), proyección + filtro
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.articulos.insertMany([
  { titulo: "Cien años de soledad", autor: "Gabriel García Márquez", anio: 1967, precio: 12 },
  { titulo: "1984", autor: "George Orwell", anio: 1949, precio: 10 },
  { titulo: "El nombre del viento", autor: "Patrick Rothfuss", anio: 2007, precio: 15 },
  { titulo: "Ready Player One", autor: "Ernest Cline", anio: 2011, precio: 18 },
  { titulo: "La sombra del viento", autor: "Carlos Ruiz Zafón", anio: 2001, precio: 14 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Proyección inclusiva: devuelve solo `titulo` y `precio` (con `_id: 0`).
2. Proyección exclusiva: devuelve todos los campos excepto `autor` (con `_id: 0`).
3. Proyección + filtro: devuelve solo `titulo` de los artículos posteriores al año 2000 (`anio > 2000`).

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-03-proyeccion-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La proyección inclusiva indica los campos con valor `1`; la exclusiva, con valor `0`.
- No se pueden mezclar campos inclusivos y exclusivos (salvo `_id`).
- Incluye siempre `{ _id: 0 }` para que la salida sea estable y sin ObjectIds.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Proyección inclusiva: solo titulo y precio
db.articulos.find({}, { _id: 0, titulo: 1, precio: 1 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Proyección exclusiva: excluir el campo autor
db.articulos.find({}, { _id: 0, autor: 0 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Nivel 1: proyección con find (sin $project)

// 4. Proyección + filtro: solo titulo de los artículos posteriores al año 2000
db.articulos.find({ anio: { $gt: 2000 } }, { _id: 0, titulo: 1 }).sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-proyeccion-test.sh   # requiere podman (levanta mongo efímero)
```