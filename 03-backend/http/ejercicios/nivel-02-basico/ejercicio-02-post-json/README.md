# Ejercicio 02 — POST con JSON

- **Nivel:** 2/5
- **Tema:** Crear recursos con POST y body JSON
- **Tiempo estimado:** 20 min

## Enunciado

Vas a crear un usuario mediante POST. El servidor `server.sh` (puerto 8084) acepta `POST /usuarios` con body JSON `{"nombre":"Ana","email":"ana@ejemplo.com"}` y responde con `201 Created` y el recurso creado (asignando `id: 1` y `activo: true`).

Completa `peticiones.http` con la petición POST completa y `expected.json` con la respuesta esperada (incluye el status).

## Requisitos

- [ ] `peticiones.http` tiene `POST /usuarios HTTP/1.1`
- [ ] `peticiones.http` tiene `Host: localhost:8084`
- [ ] `peticiones.http` tiene `Content-Type: application/json`
- [ ] `peticiones.http` tiene `Content-Length` correcto
- [ ] `peticiones.http` tiene el body JSON correcto
- [ ] `expected.json` es JSON válido con `status: 201`
- [ ] `expected.json` refleja el recurso devuelto
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cuenta los bytes del body para el `Content-Length`.
- El servidor añade `id: 1` y `activo: true`.
- `curl -s -w "\n%{http_code}"` muestra el body y el código de estado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
POST /usuarios HTTP/1.1
Host: localhost:8084
Content-Type: application/json
Content-Length: 42

{"nombre":"Ana","email":"ana@ejemplo.com"}
```

> `echo -n '{"nombre":"Ana","email":"ana@ejemplo.com"}' | wc -c` → 42

`expected.json`:

```json
{
  "status": 201,
  "body": {"id": 1, "nombre": "Ana", "email": "ana@ejemplo.com", "activo": true}
}
```

Comprobar:

```bash
curl -s -w "\n%{http_code}" -X POST http://localhost:8084/usuarios \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Ana","email":"ana@ejemplo.com"}'
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
