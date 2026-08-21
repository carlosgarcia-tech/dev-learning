# Ejercicio 06 — Orden y Limit

- **Nivel:** 1/5
- **Tema:** sort, limit, skip y findOne
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.jugadores.insertMany([
  { nombre: "Ana", puntos: 150 },
  { nombre: "Luis", puntos: 200 },
  { nombre: "Marta", puntos: 90 },
  { nombre: "Pedro", puntos: 250 },
  { nombre: "Sara", puntos: 180 },
  { nombre: "Jorge", puntos: 120 },
  { nombre: "Elena", puntos: 300 },
  { nombre: "Raúl", puntos: 75 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Devuelve todos los jugadores ordenados por `puntos` de forma descendente (con `_id: 0`).
2. Devuelve el top 3: orden descendente + `limit(3)`.
3. Devuelve la "página" que salta 2 y coge 3: `skip(2).limit(3)` con orden descendente.
4. Devuelve el jugador con más puntos (orden descendente + `limit(1)`).

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-06-orden-y-limit-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `.sort({ puntos: -1 })` ordena descendente; `1` sería ascendente.
- `.limit(n)` limita el número de resultados; `.skip(n)` descarta los primeros n.
- Añade un segundo criterio de orden (por ejemplo `nombre: 1`) para un orden totalmente estable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Jugadores ordenados por puntos de forma descendente
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).forEach(d => printjson(d));

// 2. Top 3: orden descendente + limit(3)
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).limit(3).forEach(d => printjson(d));

// 3. Paginación: skip(2) + limit(3) con orden descendente
db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).skip(2).limit(3).forEach(d => printjson(d));

// 4. El jugador con más puntos (findOne con orden)
printjson(db.jugadores.find({}, { _id: 0 }).sort({ puntos: -1, nombre: 1 }).limit(1).next());
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-orden-y-limit-test.sh   # requiere podman (levanta mongo efímero)
```