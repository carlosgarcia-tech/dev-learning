# Ejercicio 06 — Agregados Básicos

- **Nivel:** 2/5
- **Tema:** Consultas de agregación básicas: `countDocuments` y `distinct`
- **Tiempo estimado:** 8 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.ventas.insertMany([
  { vendedor: "Ana", importe: 150, ciudad: "Madrid" },
  { vendedor: "Luis", importe: 80, ciudad: "Barcelona" },
  { vendedor: "Marta", importe: 220, ciudad: "Madrid" },
  { vendedor: "Luis", importe: 95, ciudad: "Valencia" },
  { vendedor: "Ana", importe: 45, ciudad: "Barcelona" },
  { vendedor: "Pablo", importe: 300, ciudad: "Madrid" },
  { vendedor: "Marta", importe: 60, ciudad: "Valencia" },
  { vendedor: "Pablo", importe: 120, ciudad: "Barcelona" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Número de ventas con `importe > 100` (usa `countDocuments` con filtro). Imprime el número.
2. Ciudades distintas, en orden alfabético (usa `distinct`). Imprime el array con `printjson`.
3. Vendedores distintos que venden en `"Barcelona"` (usa `distinct` con filtro), en orden alfabético.
4. Total de ventas (usa `countDocuments`). Imprime el número.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa `printjson` / `print` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `countDocuments(filtro)` devuelve un número; sin filtro cuenta todos los documentos.
- `distinct(campo)` devuelve un array de valores únicos; añade `.sort()` para ordenarlo.
- `distinct` admite un segundo argumento con el filtro: `distinct("vendedor", { ciudad: "Barcelona" })`.
- Imprime arrays con `printjson(...)` y escalares con `print(...)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Número de ventas con importe > 100 (countDocuments con filtro)
print("Ventas con importe > 100: " + db.ventas.countDocuments({ importe: { $gt: 100 } }));

// 2. Ciudades distintas, en orden alfabético (distinct + sort)
printjson(db.ventas.distinct("ciudad").sort());

// 3. Vendedores distintos que venden en "Barcelona" (distinct con filtro)
printjson(db.ventas.distinct("vendedor", { ciudad: "Barcelona" }).sort());

// 4. Total de ventas (countDocuments)
print("Total de ventas: " + db.ventas.countDocuments());
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
