# Ejercicio 03 — Versionado de API

- **Nivel:** 3/5
- **Tema:** Versionado en la ruta (`/v1`, `/v2`)
- **Tiempo estimado:** 20 min

## Enunciado

La API de productos cambia: en **v1** el campo era `price` (número), en **v2** se renombró a `unitPrice` (para mayor claridad) y se añadió `currency`.

Implementa dos respuestas para el mismo producto (`GET /products/prod_001`):

1. `respuesta_v1.json`: `/v1/products/prod_001` con `price`.
2. `respuesta_v2.json`: `/v2/products/prod_001` con `unitPrice` y `currency`.

## Requisitos

- [ ] `respuesta_v1.json`: status 200, `body.price` presente (numérico), sin `unitPrice`
- [ ] `respuesta_v2.json`: status 200, `body.unitPrice` presente (numérico) y `body.currency`
- [ ] `respuesta_v1.json` no tiene `unitPrice`; `respuesta_v2.json` no tiene `price`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El versionado permite cambiar campos sin romper clientes existentes.
- v1 sigue respondiendo con `price` aunque internamente ya uses `unitPrice`.
- v2 introduce el cambio. Ambas versiones coexisten hasta el sunset de v1.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_v1.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 }
}
````

`respuesta_v2.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "name": "Teclado mecánico", "unitPrice": 89.90, "currency": "EUR" }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
