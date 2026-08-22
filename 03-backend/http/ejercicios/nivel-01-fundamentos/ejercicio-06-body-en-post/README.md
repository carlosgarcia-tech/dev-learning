# Ejercicio 06 — Body en POST

- **Nivel:** 1/5
- **Tema:** Cuerpo de la petición (body) en POST
- **Tiempo estimado:** 15 min

## Enunciado

Vas a enviar una petición POST para crear un producto. Completa `peticiones.http` con la petición completa en texto plano (request line, headers obligatorios y body JSON) y `expected.json` con la respuesta esperada del servidor.

El servidor `server.sh` escucha en el puerto 8082 y responde a `POST /productos` con `201 Created` y el recurso creado (asignándole un `id` fijo `1`).

Petición a construir:

- Método: `POST`
- Ruta: `/productos`
- Versión: `HTTP/1.1`
- Headers: `Host`, `Content-Type: application/json`, `Content-Length` (correcto)
- Body: `{"nombre":"Teclado","precio":49.99}`

## Requisitos

- [ ] `peticiones.http` tiene `POST /productos HTTP/1.1`
- [ ] `peticiones.http` tiene `Host: localhost:8082`
- [ ] `peticiones.http` tiene `Content-Type: application/json`
- [ ] `peticiones.http` tiene `Content-Length` con el valor correcto del body
- [ ] `peticiones.http` tiene el body JSON `{"nombre":"Teclado","precio":49.99}`
- [ ] `expected.json` es JSON válido y refleja la respuesta 201
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `Content-Length` es el número de **bytes** del body. Para texto ASCII coincide con la longitud en caracteres.
- Entre headers y body hay **una línea en blanco**.
- El servidor responde con `201 Created` y devuelve el recurso con un `id` asignado (1).
- Puedes contar los bytes con `echo -n '...' | wc -c`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
POST /productos HTTP/1.1
Host: localhost:8082
Content-Type: application/json
Content-Length: 35

{"nombre":"Teclado","precio":49.99}
```

> `echo -n '{"nombre":"Teclado","precio":49.99}' | wc -c` → 35

`expected.json` (la respuesta del servidor):

```json
{"id": 1, "nombre": "Teclado", "precio": 49.99}
```

Probar con curl:

```bash
curl -s -X POST http://localhost:8082/productos \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Teclado","precio":49.99}'
# → {"id":1,"nombre":"Teclado","precio":49.99}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
