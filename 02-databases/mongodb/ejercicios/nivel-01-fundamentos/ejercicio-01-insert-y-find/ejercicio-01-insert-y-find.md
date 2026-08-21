# Ejercicio 01 — Insert y Find

- **Nivel:** 1/5
- **Tema:** insertOne, insertMany, find, countDocuments
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.productos.insertMany([
  { nombre: "Ratón", precio: 12, stock: 40, categoria: "Periféricos" },
  { nombre: "Teclado", precio: 25, stock: 15, categoria: "Periféricos" },
  { nombre: "Monitor", precio: 150, stock: 10, categoria: "Pantallas" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Inserta un producto nuevo con `insertOne` (nombre "Teclado Mecánico", precio 45, stock 5, categoria "Periféricos") y comprueba el recuento con `countDocuments`.
2. Inserta 3 productos más con `insertMany`.
3. Consulta todos los productos con `find`, ordenados por nombre y con proyección `_id: 0`.
4. Cuenta el total de productos con `countDocuments`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-01-insert-y-find-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `insertOne` y `insertMany` devuelven un acuse con el `_id` del documento insertado; no lo imprimas.
- Para un orden estable usa `.sort({ nombre: 1 })` después de `find`.
- `countDocuments()` admite un filtro opcional como argumento.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Insertar un producto nuevo con insertOne y comprobar el recuento
db.productos.insertOne({ nombre: "Teclado Mecánico", precio: 45, stock: 5, categoria: "Periféricos" });
print("Documentos tras insertOne: " + db.productos.countDocuments());

// 2. Insertar 3 productos más con insertMany
db.productos.insertMany([
  { nombre: "Auriculares", precio: 30, stock: 12, categoria: "Periféricos" },
  { nombre: "Webcam", precio: 60, stock: 4, categoria: "Periféricos" },
  { nombre: "Alfombrilla", precio: 8, stock: 60, categoria: "Accesorios" }
]);

// 3. Consultar todos los productos ordenados por nombre
db.productos.find({}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 4. Recuento total de productos
print("Total de productos: " + db.productos.countDocuments());
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-insert-y-find-test.sh   # requiere podman (levanta mongo efímero)
```