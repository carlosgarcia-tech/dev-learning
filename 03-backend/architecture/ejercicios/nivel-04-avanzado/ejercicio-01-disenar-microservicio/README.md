# Ejercicio 01 — Diseñar un microservicio

- **Nivel:** 4/5
- **Tema:** Diseño de microservicio (contexto, API, BD propia)
- **Tiempo estimado:** 45 min

## Enunciado

Diseña el microservicio `Pedidos` de un e-commerce. No debe ser un monolito: define su **bounded context**, su API REST, su modelo de datos propio (no compartido) y su contrato de eventos publicados/consumidos.

El entregable es un documento `solucion.json` que describe el microservicio, y un `diagrama.txt` con su arquitectura y sus l��mites.

Pasos:

1. Examina `estructura.json` para ver el schema esperado del `solucion.json`.
2. Completa `solucion.json` con el diseño del microservicio Pedidos.
3. Dibuja el `diagrama.txt`.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.json` define `nombre`, `bounded_context`, `responsabilidad`
- [ ] `solucion.json` lista los endpoints REST (al menos: crear, obtener, listar pedidos)
- [ ] `solucion.json` define `base_de_datos` propia (no compartida con otros servicios)
- [ ] `solucion.json` lista `eventos_publicados` (al menos PedidoCreado)
- [ ] `solucion.json` lista `eventos_consumidos` (al menos uno, ej. PagoConfirmado)
- [ ] `solucion.json` es JSON válido y cumple el schema de `estructura.json`
- [ ] `diagrama.txt` muestra el servicio con su BD y sus eventos
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Bounded context de Pedidos: todo lo relacionado con crear y gestionar pedidos.
- Endpoints: `POST /pedidos`, `GET /pedidos/:id`, `GET /pedidos`.
- BD propia: `pedidos_db` (Postgres); no accedes a la BD de Productos ni Pagos.
- Publica: `PedidoCreado` (con id, total, cliente). Consume: `PagoConfirmado` (para marcar como pagado), `ProductoAgotado` (para cancelar).
- El diagrama muestra el servicio como una caja con su BD y flechas de eventos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.json`:

```json
{
  "nombre": "pedidos-service",
  "bounded_context": "gestión de pedidos",
  "responsabilidad": "crear, consultar y gestionar el ciclo de vida de los pedidos de un e-commerce",
  "base_de_datos": {
    "tipo": "postgres",
    "nombre": "pedidos_db",
    "compartida": false
  },
  "endpoints": [
    { "metodo": "POST", "ruta": "/pedidos", "descripcion": "crea un pedido" },
    { "metodo": "GET", "ruta": "/pedidos/:id", "descripcion": "obtiene un pedido por id" },
    { "metodo": "GET", "ruta": "/pedidos", "descripcion": "lista pedidos" },
    { "metodo": "PATCH", "ruta": "/pedidos/:id/cancelar", "descripcion": "cancela un pedido" }
  ],
  "eventos_publicados": [
    { "nombre": "PedidoCreado", "campos": ["pedido_id", "cliente_id", "total"] },
    { "nombre": "PedidoCancelado", "campos": ["pedido_id", "motivo"] }
  ],
  "eventos_consumidos": [
    { "nombre": "PagoConfirmado", "accion": "marcar pedido como pagado" },
    { "nombre": "ProductoAgotado", "accion": "cancelar pedido pendiente" }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
