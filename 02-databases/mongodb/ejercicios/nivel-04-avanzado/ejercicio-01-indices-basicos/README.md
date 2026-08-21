# Ejercicio 01 — Indices Básicos

- **Nivel:** 4/5
- **Tema:** `createIndex`, `getIndexes`, `dropIndex`, dirección de índices
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.productos.insertMany([
  { nombre: "camisa", precio: 25, categoria: "ropa" },
  { nombre: "pantalon", precio: 40, categoria: "ropa" },
  { nombre: "zapatillas", precio: 80, categoria: "calzado" },
  { nombre: "gorra", precio: 15, categoria: "ropa" },
  { nombre: "reloj", precio: 120, categoria: "accesorios" },
  { nombre: "mochila", precio: 60, categoria: "accesorios" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Crea un índice ascendente sobre `nombre` con `createIndex` e imprime el nombre del índice creado.
2. Lista todos los índices de la colección con `getIndexes()`.
3. Crea un índice descendente sobre `precio` e imprime su nombre.
4. Elimina el índice `nombre_1` con `dropIndex` y vuelve a listar los índices.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `createIndex` devuelve una cadena con el nombre del índice; puedes imprimirla directamente con `print(...)`.
- `getIndexes()` devuelve objetos con campos `key` y `name`; filtra con `.map(i => ({ name: i.name, key: i.key }))` para una salida clara y determinista.
- La dirección de un índice se indica con `1` (ascendente) o `-1` (descendente).
- El índice `_id_` siempre existe y no se puede eliminar con `dropIndex`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Índice ascendente sobre nombre (createIndex devuelve el nombre)
print(db.productos.createIndex({ nombre: 1 }));

// 2. Ver todos los índices: solo name y key (salida determinista)
printjson(db.productos.getIndexes().map(i => ({ name: i.name, key: i.key })));

// 3. Índice descendente sobre precio
print(db.productos.createIndex({ precio: -1 }));

// 4. Eliminar el índice nombre_1 y listar de nuevo
db.productos.dropIndex("nombre_1");
printjson(db.productos.getIndexes().map(i => ({ name: i.name, key: i.key })));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
