# Ejercicio 05 — Accept y Content Negotiation

- **Nivel:** 2/5
- **Tema:** Content negotiation con el header Accept
- **Tiempo estimado:** 25 min

## Enunciado

El servidor `server.sh` (puerto 8087) sirve el mismo recurso `/dato` en dos formatos: JSON y XML, según el header `Accept` del cliente.

- `Accept: application/json` → responde JSON con `Content-Type: application/json`.
- `Accept: application/xml` → responde XML con `Content-Type: application/xml`.
- Otro `Accept` → `406 Not Acceptable`.

Completa `peticiones.http` con las dos peticiones (JSON y XML) y `expected.json` con el `Content-Type` que el servidor devuelve en cada caso.

## Requisitos

- [ ] `peticiones.http` tiene una petición con `Accept: application/json`
- [ ] `peticiones.http` tiene una petición con `Accept: application/xml`
- [ ] `expected.json` es JSON válido
- [ ] `expected.json` mapea `json` → `application/json` y `xml` → `application/xml`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Accept` declara qué tipos acepta el cliente.
- El servidor decide el formato de respuesta y lo anuncia con `Content-Type`.
- `curl -s -D - -o /dev/null` muestra solo los headers de respuesta (incluido `Content-Type`).
- Si el servidor no soporta ninguno, responde 406.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /dato HTTP/1.1
Host: localhost:8087
Accept: application/json

GET /dato HTTP/1.1
Host: localhost:8087
Accept: application/xml
```

`expected.json`:

```json
{
  "json": "application/json",
  "xml": "application/xml"
}
```

Comprobar:

```bash
curl -s -D - -o /dev/null -H "Accept: application/json" http://localhost:8087/dato | grep -i content-type
# → Content-Type: application/json
curl -s -D - -o /dev/null -H "Accept: application/xml" http://localhost:8087/dato | grep -i content-type
# → Content-Type: application/xml
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
