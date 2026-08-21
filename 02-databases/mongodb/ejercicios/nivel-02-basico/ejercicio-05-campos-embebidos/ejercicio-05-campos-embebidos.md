# Ejercicio 05 — Campos Embebidos

- **Nivel:** 2/5
- **Tema:** Documentos embebidos: dot notation, filtros sobre subcampos y proyección
- **Tiempo estimado:** 12 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.pedidos.insertMany([
  { codigo: 1, cliente: { nombre: "Ana", ciudad: "Madrid" }, items: [{ producto: "Portátil", cantidad: 1 }, { producto: "Ratón", cantidad: 2 }] },
  { codigo: 2, cliente: { nombre: "Luis", ciudad: "Madrid" }, items: [{ producto: "Monitor", cantidad: 1 }] },
  { codigo: 3, cliente: { nombre: "Ana", ciudad: "Barcelona" }, items: [{ producto: "Teclado", cantidad: 3 }, { producto: "Lámpara", cantidad: 2 }] },
  { codigo: 4, cliente: { nombre: "Marta", ciudad: "Madrid" }, items: [{ producto: "laptop", cantidad: 5 }, { producto: "Auriculares", cantidad: 1 }] },
  { codigo: 5, cliente: { nombre: "Pablo", ciudad: "Sevilla" }, items: [{ producto: "laptop", cantidad: 10 }] }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Pedidos cuyo cliente viva en `"Madrid"` (usa dot notation sobre `cliente.ciudad`).
2. Pedidos cuyo cliente se llame `"Ana"` (usa dot notation sobre `cliente.nombre`).
3. Pedidos que tengan algún item `"laptop"` (filtra sobre el array `items` con dot notation).
4. Proyección de subcampo embebido: devuelve solo `cliente.nombre` con `_id: 0`.

Ordena los resultados de cada consulta por `codigo` ascendente.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-05-campos-embebidos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La dot notation usa el nombre del campo entre comillas: `"cliente.ciudad"`.
- Sobre arrays de objetos se aplica igual: `"items.producto"` busca en todos los elementos.
- En la proyección también puedes usar dot notation: `{ _id: 0, "cliente.nombre": 1 }`.
- Al proyectar un subcampo, el documento de salida conserva la estructura embebida: `{ cliente: { nombre: ... } }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Pedidos cuyo cliente vive en "Madrid" (dot notation sobre cliente.ciudad)
db.pedidos.find({ "cliente.ciudad": "Madrid" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 2. Pedidos cuyo cliente se llama "Ana" (dot notation sobre cliente.nombre)
db.pedidos.find({ "cliente.nombre": "Ana" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 3. Pedidos con algún item "laptop" (filtro sobre array de objetos embebidos)
db.pedidos.find({ "items.producto": "laptop" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 4. Proyección de subcampo embebido: solo cliente.nombre (_id: 0)
db.pedidos.find({}, { _id: 0, "cliente.nombre": 1 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-campos-embebidos-test.sh   # requiere podman (levanta mongo efímero)
```