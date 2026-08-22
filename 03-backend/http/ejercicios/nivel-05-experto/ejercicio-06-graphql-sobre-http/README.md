# Ejercicio 06 — GraphQL sobre HTTP

- **Nivel:** 5/5
- **Tema:** GraphQL sobre HTTP
- **Tiempo estimado:** 45 min

## Enunciado

El servidor `server.sh` (puerto 8103) implementa un endpoint GraphQL mínimo en `POST /graphql`. Acepta una query en JSON y responde con los datos pedidos.

Completa `peticiones.http` con la petición GraphQL (POST con body JSON) y `expected.json` con la respuesta esperada.

Query a enviar:

```graphql
{ producto(id: 1) { id nombre precio } }
```

## Requisitos

- [ ] `peticiones.http` tiene `POST /graphql HTTP/1.1`
- [ ] `peticiones.http` tiene `Content-Type: application/json`
- [ ] El body contiene `"query": "{ producto(id: 1) ...`
- [ ] `expected.json` es JSON válido con la estructura `data.producto`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- GraphQL usa un solo endpoint, normalmente `POST /graphql`.
- El body es JSON con una clave `query` que contiene la query GraphQL.
- La respuesta es JSON con una clave `data`.
- Los errores van en `errors` (con status 200).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
POST /graphql HTTP/1.1
Host: localhost:8103
Content-Type: application/json
Content-Length: 52

{"query":"{ producto(id: 1) { id nombre precio } }"}
```

`expected.json`:

```json
{
  "data": {
    "producto": {"id": 1, "nombre": "Teclado", "precio": 49.99}
  }
}
```

Comprobar:

```bash
curl -s -X POST http://localhost:8103/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ producto(id: 1) { id nombre precio } }"}'
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
