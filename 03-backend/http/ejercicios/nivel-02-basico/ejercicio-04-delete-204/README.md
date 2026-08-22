# Ejercicio 04 — DELETE y código 204

- **Nivel:** 2/5
- **Tema:** Borrar recursos con DELETE
- **Tiempo estimado:** 20 min

## Enunciado

Vas a borrar un recurso con DELETE. El servidor `server.sh` (puerto 8086) acepta `DELETE /tareas/7` y responde con **204 No Content** (sin body) si la tarea existía, o **404** si no.

Completa `peticiones.http` con la petición DELETE y `expected.json` con el status esperado (204).

## Requisitos

- [ ] `peticiones.http` tiene `DELETE /tareas/7 HTTP/1.1`
- [ ] `peticiones.http` tiene `Host: localhost:8086`
- [ ] `expected.json` es JSON válido con `status: 204`
- [ ] `expected.json` tiene `body: null` (204 no tiene body)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- DELETE no suele llevar body.
- 204 No Content significa éxito sin body de respuesta.
- `curl -s -w "%{http_code}" -o /dev/null` te da solo el código.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
DELETE /tareas/7 HTTP/1.1
Host: localhost:8086
```

`expected.json`:

```json
{"status": 204, "body": null}
```

Comprobar:

```bash
curl -s -w "%{http_code}\n" -o /dev/null -X DELETE http://localhost:8086/tareas/7
# → 204
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
