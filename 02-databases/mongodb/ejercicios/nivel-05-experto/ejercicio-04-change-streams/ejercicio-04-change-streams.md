# Ejercicio 04 — Change Streams

- **Nivel:** 5/5
- **Tema:** change streams, watch(), operationType, cursor.next()
- **Tiempo estimado:** 25 min
- **Requisito:** requiere un replica set (el `test.sh` lo levanta automáticamente)

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.createCollection("eventos");   // colección vacía
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Abre un change stream sobre la colección `eventos` con `db.eventos.watch()` e inserta `{ tipo: "login", usuario: "ana" }`; captura el evento con `cs.next()` y muestra `op` (`operationType`) y `usuario`.
2. Inserta un segundo documento `{ tipo: "registro", usuario: "luis" }` y captura su evento del mismo modo.
3. Cierra el cursor con `cs.close()`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-04-change-streams-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `db.eventos.watch()` devuelve un cursor que bloquea hasta recibir el siguiente evento; puedes usar `cs.next()`.
- Cada evento tiene `operationType` y `fullDocument` (el documento insertado). Nunca imprimas el `_id` ni el `resumeToken`.
- `cursor.disableBlockWarnings()` elimina el aviso de mongosh cuando `next()` bloquea.
- El `test.sh` de este ejercicio levanta un replica set (necesario para change streams) y lo gestiona solo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Abrir watch() y capturar el evento del primer insert
const cs = db.eventos.watch();
cs.disableBlockWarnings();
db.eventos.insertOne({ tipo: "login", usuario: "ana" });
const ev1 = cs.next();
printjson({ op: ev1.operationType, usuario: ev1.fullDocument.usuario });

// 2. Insertar un segundo doc y capturar su evento
db.eventos.insertOne({ tipo: "registro", usuario: "luis" });
const ev2 = cs.next();
printjson({ op: ev2.operationType, usuario: ev2.fullDocument.usuario });

// 3. Cerrar el cursor
cs.close();
print("cursor cerrado");
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-change-streams-test.sh   # requiere podman (levanta mongo efímero con replica set)
```