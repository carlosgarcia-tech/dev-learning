# Ejercicio 03 — Regex y Existencia

- **Nivel:** 2/5
- **Tema:** Expresiones regulares (`$regex`, `$options`) y existencia/tipo (`$exists`, `$type`)
- **Tiempo estimado:** 12 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.articulos.insertMany([
  { titulo: "El Quijote", autor: "Miguel de Cervantes", publicado: true, precio: 12.5, resumen: "Aventuras de un hidalgo." },
  { titulo: "el principito", autor: "Antoine de Saint-Exupéry", publicado: true, precio: 9.9 },
  { titulo: "Cien años de soledad", autor: "Gabriel García Márquez", publicado: true, precio: 15.0, resumen: "Historia de los Buendía." },
  { titulo: "La casa de los espíritus", autor: "Isabel Allende", publicado: false, precio: 14.5, resumen: "Saga familiar chilena." },
  { titulo: "El Hobbit", autor: "J. R. R. Tolkien", publicado: true, precio: NumberInt(18) },
  { titulo: "Crónica de una muerte anunciada", autor: "García Márquez", publicado: true, resumen: "Crónica de un crimen." }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Títulos que empiecen por `"El "` sin importar mayúsculas (usa `$regex` con `$options: "i"`). Ordena por `titulo` ascendente.
2. Autores que contengan `"García"` (usa `$regex`). Ordena por `titulo` ascendente.
3. Documentos que tengan el campo `resumen` (usa `$exists`). Ordena por `titulo` ascendente.
4. Documentos cuyo campo `precio` sea de tipo `double` (usa `$type`). Ordena por `titulo` ascendente.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-03-regex-y-existe-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$regex` acepta anclas como `^` para "empieza por": `{ $regex: "^El " }`.
- `$options: "i"` hace la búsqueda insensible a mayúsculas y minúsculas.
- `$exists: true` filtra documentos que tengan el campo; `$type` filtra por tipo BSON.
- Observa que `NumberInt(18)` guarda el precio como entero, no como `double`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Títulos que empiecen por "El " (expresión regular, insensible a mayúsculas)
db.articulos.find({ titulo: { $regex: "^El ", $options: "i" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Autores que contengan "García" (operador $regex)
db.articulos.find({ autor: { $regex: "García" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Documentos que tengan el campo "resumen" (operador $exists)
db.articulos.find({ resumen: { $exists: true } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Documentos cuyo campo "precio" sea de tipo double (operador $type)
db.articulos.find({ precio: { $type: "double" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-regex-y-existe-test.sh   # requiere podman (levanta mongo efímero)
```