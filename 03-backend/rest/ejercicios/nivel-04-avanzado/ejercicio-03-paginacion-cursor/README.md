# Ejercicio 03 — Paginación con cursor

- **Nivel:** 4/5
- **Tema:** Paginación basada en cursor
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `GET /products?limit=2&cursor=eyJpZCI6InByb2RfMDIifQ` (paginación por cursor). La respuesta debe:

- Devolver status **200**.
- `body.data` con 2 elementos.
- `body.pagination` con `limit`, `nextCursor` (base64) y `hasMore` (bool).

## Requisitos

- [ ] El status es **200**
- [ ] `body.data` tiene exactamente 2 elementos
- [ ] `pagination.limit` = 2
- [ ] `pagination.nextCursor` es un string no vacío
- [ ] `pagination.hasMore` es `true` (hay más elementos)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El cursor codifica la posición (típicamente el último id visto) en base64.
- `nextCursor` apunta a la siguiente página; el cliente lo pasa como `?cursor=...`.
- `hasMore: true` indica que hay más datos; cuando llega al final, `nextCursor` es null y `hasMore` false.
- Cursor es O(1) en BD (`WHERE id > last_id`), estable ante inserciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "data": [
      { "id": "prod_003", "name": "Monitor", "price": 199.90 },
      { "id": "prod_004", "name": "Webcam", "price": 45.50 }
    ],
    "pagination": {
      "limit": 2,
      "nextCursor": "eyJpZCI6InByb2RfMDQifQ==",
      "hasMore": true
    }
  }
}
````

El `nextCursor` es `base64({"id":"prod_004"})`, que el cliente pasa en la siguiente petición como `?cursor=...`.

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
