# Ejercicio 02 — HATEOAS links

- **Nivel:** 3/5
- **Tema:** Hypermedia (HATEOAS)
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `GET /orders/ord_456` con **HATEOAS** (estilo HAL). La respuesta debe:

- Devolver status **200**.
- Incluir un objeto `_links` con al menos: `self`, `cancel` y `pay`.
- Cada link es un objeto `{ "href": "...", "method": "..." }`.
- El link `pay` debe estar presente porque el pedido está `pending`.

## Requisitos

- [ ] El status es **200**
- [ ] `body._links` es un objeto con `self`, `cancel`, `pay`
- [ ] Cada link tiene `href` (string) y `method` (HTTP válido)
- [ ] `body._links.self.href` apunta a `/orders/ord_456`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- HATEOAS hace la API navegable: el cliente descubre acciones desde los links.
- HAL usa `_links` para links y `_embedded` para recursos anidados.
- El `method` indica el verbo HTTP que espera ese link (`GET`, `POST`...).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "id": "ord_456",
    "status": "pending",
    "total": 99.90,
    "_links": {
      "self": { "href": "/orders/ord_456", "method": "GET" },
      "cancel": { "href": "/orders/ord_456/cancel", "method": "POST" },
      "pay": { "href": "/orders/ord_456/payments", "method": "POST" }
    }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
