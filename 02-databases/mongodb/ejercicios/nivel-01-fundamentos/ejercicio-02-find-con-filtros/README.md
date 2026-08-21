# Ejercicio 02 — Find con Filtros

- **Nivel:** 1/5
- **Tema:** `find` con operadores de consulta (`$ne`, `$gte`, filtros múltiples), `countDocuments`
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.usuarios.insertMany([
  { nombre: "Ana", edad: 30, ciudad: "Madrid", activo: true },
  { nombre: "Luis", edad: 45, ciudad: "Barcelona", activo: true },
  { nombre: "Marta", edad: 25, ciudad: "Madrid", activo: false },
  { nombre: "Pedro", edad: 50, ciudad: "Sevilla", activo: true },
  { nombre: "Sara", edad: 35, ciudad: "Barcelona", activo: false },
  { nombre: "Jorge", edad: 28, ciudad: "Madrid", activo: true }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Busca con `find` los usuarios de la ciudad "Madrid" (filtro por igualdad).
2. Busca los usuarios que NO sean de "Madrid" (operador `$ne`).
3. Busca los usuarios activos Y con 30 años o más (filtro múltiple con `$gte`).
4. Cuenta con `countDocuments` cuántos usuarios tienen 30 años o más.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un filtro con varios pares `clave: valor` equivale a un AND.
- `$ne` se escribe como `{ campo: { $ne: valor } }`.
- `$gte` significa "mayor o igual que" (greater than or equal).
- `countDocuments()` acepta el mismo filtro que `find`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Usuarios de Madrid (filtro por igualdad)
db.usuarios.find({ ciudad: "Madrid" }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 2. Usuarios que NO son de Madrid ($ne)
db.usuarios.find({ ciudad: { $ne: "Madrid" } }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 3. Usuarios activos y con 30 años o más (filtro múltiple)
db.usuarios.find({ activo: true, edad: { $gte: 30 } }, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 4. Recuento de usuarios con 30 años o más (countDocuments con filtro)
print("Usuarios con edad >= 30: " + db.usuarios.countDocuments({ edad: { $gte: 30 } }));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
