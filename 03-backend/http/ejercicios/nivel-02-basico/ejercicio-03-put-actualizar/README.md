# Ejercicio 03 — PUT para Actualizar

- **Nivel:** 2/5
- **Tema:** Reemplazar un recurso con PUT
- **Tiempo estimado:** 20 min

## Enunciado

Tienes un producto existente. Vas a **reemplazarlo por completo** con PUT. El servidor `server.sh` (puerto 8085) acepta `PUT /productos/1` con un body JSON y devuelve el recurso actualizado con `200 OK`.

Completa `peticiones.http` con la petición PUT (reemplazo completo) y `expected.json` con la respuesta esperada (incluye `status: 200`).

Estado actual del producto (en el servidor):

```json
{"id": 1, "nombre": "Teclado", "precio": 49.99, "stock": 10}
```

Reemplazo a enviar:

```json
{"nombre": "Teclado mecánico", "precio": 79.99, "stock": 5}
```

> Recuerda: PUT **reemplaza** el recurso. Si omitieras `stock`, se borraría.

## Requisitos

- [ ] `peticiones.http` tiene `PUT /productos/1 HTTP/1.1`
- [ ] `peticiones.http` tiene `Host: localhost:8085`
- [ ] `peticiones.http` tiene `Content-Type: application/json`
- [ ] `peticiones.http` tiene `Content-Length` correcto
- [ ] `expected.json` tiene `status: 200`
- [ ] `expected.json` refleja el recurso reemplazado (con `id: 1`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- PUT reemplaza el recurso entero: envía todos los campos.
- El servidor conserva el `id` (1) y reemplaza el resto.
- Cuenta los bytes del body para `Content-Length`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
PUT /productos/1 HTTP/1.1
Host: localhost:8085
Content-Type: application/json
Content-Length: 55

{"nombre":"Teclado mecánico","precio":79.99,"stock":5}
```

> `echo -n '{"nombre":"Teclado mecánico","precio":79.99,"stock":5}' | wc -c` → 55

`expected.json`:

```json
{
  "status": 200,
  "body": {"id": 1, "nombre": "Teclado mecánico", "precio": 79.99, "stock": 5}
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
