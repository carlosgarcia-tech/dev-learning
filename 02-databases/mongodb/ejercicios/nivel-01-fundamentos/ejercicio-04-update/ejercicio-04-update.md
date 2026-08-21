# Ejercicio 04 — Update

- **Nivel:** 1/5
- **Tema:** updateOne y updateMany con $set, $inc y $unset
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.inventario.insertMany([
  { nombre: "Manzana", cantidad: 12, categoria: "Frutas" },
  { nombre: "Leche", cantidad: 5, categoria: "Lácteos" },
  { nombre: "Pan", cantidad: 0, categoria: "Panadería" },
  { nombre: "Queso", cantidad: 8, categoria: "Lácteos" },
  { nombre: "Tomate", cantidad: 3, categoria: "Verduras" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Usa `updateOne` con `$set` para cambiar la categoría de "Tomate" a "Frescos".
2. Usa `updateMany` con `$inc` para sumar 10 a la cantidad de los productos que están en stock (`cantidad > 0`).
3. Usa `updateOne` con `$unset` para eliminar el campo `categoria` de "Queso".
4. Usa `updateMany` con `$set` condicional para marcar `activo: false` en los productos con `cantidad === 0`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-04-update-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$set` añade o modifica campos; `$unset` los elimina.
- `$inc` suma (o resta) numéricamente el valor indicado a un campo.
- `updateOne` afecta al primer documento que coincida; `updateMany` a todos los que coincidan.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. updateOne con $set: cambiar la categoría de "Tomate"
printjson(db.inventario.updateOne({ nombre: "Tomate" }, { $set: { categoria: "Frescos" } }));

// 2. updateMany con $inc: sumar 10 a la cantidad de los productos en stock
printjson(db.inventario.updateMany({ cantidad: { $gt: 0 } }, { $inc: { cantidad: 10 } }));

// 3. updateOne con $unset: eliminar el campo categoria de "Queso"
printjson(db.inventario.updateOne({ nombre: "Queso" }, { $unset: { categoria: "" } }));

// 4. updateMany con $set condicional: marcar como no activos los productos sin stock
printjson(db.inventario.updateMany({ cantidad: 0 }, { $set: { activo: false } }));

// Estado final de la colección
db.inventario.find({}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-update-test.sh   # requiere podman (levanta mongo efímero)
```