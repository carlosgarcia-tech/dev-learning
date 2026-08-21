# Ejercicio 02 — Lógicos

- **Nivel:** 2/5
- **Tema:** Operadores lógicos `$and`, `$or`, `$not`, `$nor`
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.empleados.insertMany([
  { nombre: "Ana", departamento: "ventas", salario: 2800, activo: true },
  { nombre: "Luis", departamento: "ventas", salario: 5200, activo: true },
  { nombre: "Carmen", departamento: "marketing", salario: 3400, activo: true },
  { nombre: "Pablo", departamento: "rrhh", salario: 4500, activo: true },
  { nombre: "Sara", departamento: "marketing", salario: 2200, activo: false },
  { nombre: "Marta", departamento: "ventas", salario: 3800, activo: true }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Empleados con `salario > 3000` Y `activo: true` (usa el operador `$and` explícito). Ordena por `salario` ascendente.
2. Empleados del departamento `"ventas"` O con `salario > 5000` (usa `$or`). Ordena por `nombre` ascendente.
3. Empleados cuyo `salario` NO sea mayor que 4000 (usa `$not`). Ordena por `salario` ascendente.
4. Empleados que no estén inactivos NI sean del departamento `"rrhh"` (usa `$nor`). Ordena por `nombre` ascendente.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$and` explícito recibe un array de condiciones: `{ $and: [ { ... }, { ... } ] }`.
- `$or` también recibe un array de condiciones y basta con que se cumpla una.
- `$not` niega una condición dentro del propio campo: `{ salario: { $not: { $gt: 4000 } } }`.
- `$nor` recibe un array y excluye los documentos que cumplan cualquiera de las condiciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Empleados con salario > 3000 Y activos (operador $and explícito)
db.empleados.find({
  $and: [{ salario: { $gt: 3000 } }, { activo: true }]
}, { _id: 0 }).sort({ salario: 1 }).forEach(d => printjson(d));

// 2. Empleados del departamento "ventas" O con salario > 5000 (operador $or)
db.empleados.find({
  $or: [{ departamento: "ventas" }, { salario: { $gt: 5000 } }]
}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 3. Empleados cuyo salario NO sea mayor que 4000 (operador $not sobre $gt)
db.empleados.find({ salario: { $not: { $gt: 4000 } } }, { _id: 0 })
  .sort({ salario: 1 }).forEach(d => printjson(d));

// 4. Empleados que no estén inactivos NI sean de "rrhh" (operador $nor)
db.empleados.find({
  $nor: [{ activo: false }, { departamento: "rrhh" }]
}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
