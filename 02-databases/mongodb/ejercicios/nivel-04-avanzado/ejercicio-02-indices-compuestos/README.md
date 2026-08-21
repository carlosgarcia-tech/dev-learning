# Ejercicio 02 — Indices Compuestos

- **Nivel:** 4/5
- **Tema:** índices compuestos, `createIndex`, `getIndexes`, `explain("executionStats")`
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.ventas.insertMany([
  { anio: 2024, mes: 1, vendedor: "ana", importe: 120 },
  { anio: 2024, mes: 2, vendedor: "luis", importe: 80 },
  { anio: 2024, mes: 3, vendedor: "carla", importe: 250 },
  { anio: 2024, mes: 3, vendedor: "ana", importe: 150 },
  { anio: 2024, mes: 4, vendedor: "marta", importe: 300 },
  { anio: 2025, mes: 1, vendedor: "luis", importe: 200 },
  { anio: 2025, mes: 2, vendedor: "carla", importe: 90 },
  { anio: 2025, mes: 3, vendedor: "marta", importe: 175 },
  { anio: 2025, mes: 3, vendedor: "ana", importe: 110 },
  { anio: 2025, mes: 4, vendedor: "luis", importe: 65 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Crea un índice compuesto `{ anio: 1, mes: -1 }` e imprime su nombre.
2. Crea un índice compuesto `{ vendedor: 1, importe: -1 }` e imprime su nombre.
3. Lista todos los índices de la colección con `getIndexes()`.
4. Ejecuta `explain("executionStats")` sobre una consulta que filtre por `anio` y `mes` y muestra solo `nReturned`, `totalKeysExamined` y `totalDocsExamined`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En un índice compuesto el orden de los campos importa: primero el campo de igualdad, luego el de rango.
- `createIndex` devuelve el nombre del índice; imprímelo con `print(...)`.
- En `explain("executionStats")` NO imprimas el objeto completo (contiene tiempos y ObjectIds no deterministas); guarda el resultado en una variable y selecciona solo los campos estables de `executionStats`.
- La consulta `{ anio: 2024, mes: 3 }` debe usar el índice `anio_1_mes_-1`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Índice compuesto: anio ascendente + mes descendente
print(db.ventas.createIndex({ anio: 1, mes: -1 }));

// 2. Índice compuesto: vendedor ascendente + importe descendente
print(db.ventas.createIndex({ vendedor: 1, importe: -1 }));

// 3. Ver todos los índices: solo name y key
printjson(db.ventas.getIndexes().map(i => ({ name: i.name, key: i.key })));

// 4. Explain de una consulta sobre (anio, mes): solo campos estables
const e = db.ventas.find({ anio: 2024, mes: 3 }).explain("executionStats");
printjson({
  nReturned: e.executionStats.nReturned,
  totalKeysExamined: e.executionStats.totalKeysExamined,
  totalDocsExamined: e.executionStats.totalDocsExamined
});
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
