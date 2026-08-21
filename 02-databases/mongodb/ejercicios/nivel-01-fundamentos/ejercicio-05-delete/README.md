# Ejercicio 05 — Delete

- **Nivel:** 1/5
- **Tema:** `deleteOne`, `deleteMany`, `countDocuments` y `drop` de colecciones
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.tareas.insertMany([
  { titulo: "Comprar leche", completada: false, prioridad: 1 },
  { titulo: "Estudiar Mongo", completada: true, prioridad: 3 },
  { titulo: "Hacer ejercicio", completada: false, prioridad: 2 },
  { titulo: "Leer un libro", completada: true, prioridad: 1 },
  { titulo: "Llamar al banco", completada: false, prioridad: 2 },
  { titulo: "Ordenar el escritorio", completada: true, prioridad: 1 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Borra con `deleteOne` la tarea concreta "Llamar al banco".
2. Borra con `deleteMany` todas las tareas completadas (`completada: true`).
3. Cuenta con `countDocuments` cuántas tareas quedan y muestra el estado final.
4. Crea una colección temporal, insértale un documento, haz `drop()` y verifica que ya no existe.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `deleteOne` elimina el primer documento que coincida; `deleteMany` todos los que coincidan.
- No puedes borrar la base activa (`ejercicios_db`), pero sí colecciones temporales con `drop()`.
- Para comprobar si una colección existe usa `db.getCollectionNames().includes("nombre")`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Borrar una tarea concreta con deleteOne
printjson(db.tareas.deleteOne({ titulo: "Llamar al banco" }));

// 2. Borrar todas las tareas completadas con deleteMany
printjson(db.tareas.deleteMany({ completada: true }));

// 3. Recuento de tareas restantes y estado de la colección
print("Tareas restantes: " + db.tareas.countDocuments());
db.tareas.find({}, { _id: 0 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Drop de una colección temporal y verificación
db.temporal.insertOne({ nota: "temporal" });
print("Colección temporal existe (antes del drop): " + db.getCollectionNames().includes("temporal"));
db.temporal.drop();
print("Colección temporal existe (después del drop): " + db.getCollectionNames().includes("temporal"));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
