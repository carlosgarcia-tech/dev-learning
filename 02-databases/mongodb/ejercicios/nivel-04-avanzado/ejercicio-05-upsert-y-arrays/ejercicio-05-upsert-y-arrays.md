# Ejercicio 05 — Upsert y Arrays

- **Nivel:** 4/5
- **Tema:** updateOne, upsert, $push, $pull, $addToSet
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.carritos.insertMany([
  { usuario: "ana", items: ["camisa", "gorra"], total: 40 },
  { usuario: "luis", items: ["reloj"], total: 120 },
  { usuario: "carla", items: [], total: 0 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Usa `updateOne` con `upsert: true` para el usuario nuevo `marta` (`items: ["mochila"]`, `total: 60`) y comprueba el resultado con un `find`.
2. Añade `"zapatillas"` al carrito de `ana` con `$push` y comprueba el resultado.
3. Quita `"reloj"` del carrito de `luis` con `$pull` y comprueba el resultado.
4. Añade a `carla` los items `"mochila"`, `"mochila"` y `"libro"` con `$addToSet` y `$each` (los duplicados no deben añadirse) y comprueba el resultado.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-05-upsert-y-arrays-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `upsert: true` crea el documento si el filtro no encuentra ninguno.
- `$push` añade un elemento al final del array; `$pull` elimina todos los elementos que coincidan con el valor.
- `$addToSet` añade solo si el valor no existe; combínalo con `$each` para pasar una lista.
- Comprueba cada operación con un `find` que proyecte `_id: 0`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. updateOne con upsert:true para un usuario nuevo (se crea el documento)
db.carritos.updateOne(
  { usuario: "marta" },
  { $set: { items: ["mochila"], total: 60 } },
  { upsert: true }
);
printjson(db.carritos.find({ usuario: "marta" }, { _id: 0 }).toArray());

// 2. $push: añadir un item al carrito de ana
db.carritos.updateOne({ usuario: "ana" }, { $push: { items: "zapatillas" } });
printjson(db.carritos.find({ usuario: "ana" }, { _id: 0 }).toArray());

// 3. $pull: quitar un item del carrito de luis
db.carritos.updateOne({ usuario: "luis" }, { $pull: { items: "reloj" } });
printjson(db.carritos.find({ usuario: "luis" }, { _id: 0 }).toArray());

// 4. $addToSet: añadir items únicos (no duplica)
db.carritos.updateOne(
  { usuario: "carla" },
  { $addToSet: { items: { $each: ["mochila", "mochila", "libro"] } } }
);
printjson(db.carritos.find({ usuario: "carla" }, { _id: 0 }).toArray());
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-upsert-y-arrays-test.sh   # requiere podman (levanta mongo efímero)
```