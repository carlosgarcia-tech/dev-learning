# Ejercicio 06 — Condicionales

- **Nivel:** 3/5
- **Tema:** `$cond`, `$ifNull`, `$add`, `$sort`, `$project`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.empleados.insertMany([
  { nombre: "ana", salario: 6200, bono: 500 },
  { nombre: "luis", salario: 4800, bono: 300 },
  { nombre: "carla", salario: 3500 },
  { nombre: "diego", salario: 4200, bono: 200 },
  { nombre: "eva", salario: 2800 },
  { nombre: "fran", salario: 5400, bono: 400 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Con `$cond` anidado clasifica cada empleado en "Alto", "Medio" o "Bajo" según su `salario` y proyecta `_id: 0`.
2. Con `$ifNull` usa un `bono` por defecto de 0 cuando falte y calcula `total = salario + bono`.
3. Calcula el `total` (salario + bono) y ordena por `total` desc con `$sort`, proyectando `_id: 0`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$cond` es un ternario: `[condición, valor_si_true, valor_si_false]`.
- Puedes anidar un `$cond` dentro de otro para más de dos ramas.
- `$ifNull: ["$bono", 0]` sustituye un valor ausente por 0.
- Para el último punto, calcula `total` en una etapa anterior y aplica `$sort` sobre ese campo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $project con $cond anidado: categoría Alto / Medio / Bajo según salario
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      categoria: {
        $cond: [
          { $gt: ["$salario", 5000] }, "Alto",
          { $cond: [{ $gt: ["$salario", 3000] }, "Medio", "Bajo"] }
        ]
      }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 2. $project con $ifNull (bono por defecto 0) y total = salario + bono
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      bono: { $ifNull: ["$bono", 0] },
      total: { $add: ["$salario", { $ifNull: ["$bono", 0] }] }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 3. $sort por total desc + proyección {_id: 0}
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      bono: { $ifNull: ["$bono", 0] },
      total: { $add: ["$salario", { $ifNull: ["$bono", 0] }] }
  } },
  { $sort: { total: -1 } }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
