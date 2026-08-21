# Ejercicio 05 — Sort, Limit y Skip

- **Nivel:** 3/5
- **Tema:** `$sort`, `$limit`, `$skip`, `$project`
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.participantes.insertMany([
  { nombre: "ana", puntos: 320 },
  { nombre: "luis", puntos: 540 },
  { nombre: "carla", puntos: 410 },
  { nombre: "marta", puntos: 680 },
  { nombre: "pedro", puntos: 275 },
  { nombre: "sofia", puntos: 590 },
  { nombre: "diego", puntos: 355 },
  { nombre: "laura", puntos: 440 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Ordena por `puntos` desc con `$sort` y limita a 3 con `$limit` (los 3 mejores).
2. Tras ordenar por `puntos` desc, usa `$skip 3` y `$limit 2` para obtener las posiciones 4 y 5.
3. Ordena alfabéticamente por `nombre` y limita a 3, con proyección `_id: 0`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El orden de las etapas importa: `$sort` → `$skip` → `$limit` para paginar.
- `$limit` corta el flujo tras el orden aplicado en la etapa anterior.
- Proyecta `_id: 0` al final para no imprimir el ObjectId.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Top 3: $sort puntos desc + $limit 3
db.participantes.aggregate([
  { $sort: { puntos: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));

// 2. Posiciones 4-5: $sort desc + $skip 3 + $limit 2
db.participantes.aggregate([
  { $sort: { puntos: -1 } },
  { $skip: 3 },
  { $limit: 2 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));

// 3. $sort alfabético + $limit 3 con proyección {_id: 0}
db.participantes.aggregate([
  { $sort: { nombre: 1 } },
  { $limit: 3 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
