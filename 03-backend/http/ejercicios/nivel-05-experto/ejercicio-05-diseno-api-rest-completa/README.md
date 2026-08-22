# Ejercicio 05 — Diseño de API REST Completa

- **Nivel:** 5/5
- **Tema:** Diseño de API REST completa
- **Tiempo estimado:** 60 min

## Enunciado

Diseña una API REST completa para una tienda online con recursos **productos**, **usuarios** y **pedidos**. Completa `respuesta.json` con todas las rutas (método + path) para cada operación.

El `test.sh` valida que las rutas siguen las convenciones REST (plurales, sin verbos, anidación correcta de sub-recursos).

Operaciones a cubrir:

1. Listar productos
2. Obtener un producto
3. Crear un producto
4. Actualizar un producto (parcial)
5. Borrar un producto
6. Listar usuarios
7. Crear un usuario
8. Listar pedidos de un usuario
9. Crear un pedido para un usuario
10. Obtener un pedido concreto de un usuario
11. Cancelar un pedido (PATCH al estado)
12. Listar los items de un pedido

## Requisitos

- [ ] `respuesta.json` es JSON válido con un objeto `rutas`
- [ ] Todas las rutas usan sustantivos en plural
- [ ] Ninguna ruta contiene verbos
- [ ] Los sub-recursos se anidan bajo el padre (`/users/{id}/orders`)
- [ ] Los métodos HTTP son correctos (GET, POST, PATCH, DELETE)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Colecciones: `/products`, `/users`.
- Sub-recursos anidados: `/users/{id}/orders`, `/orders/{id}/items`.
- PATCH para modificaciones parciales (cancelar un pedido).
- DELETE para borrar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "rutas": {
    "listar_productos": "GET /products",
    "obtener_producto": "GET /products/{id}",
    "crear_producto": "POST /products",
    "actualizar_producto": "PATCH /products/{id}",
    "borrar_producto": "DELETE /products/{id}",
    "listar_usuarios": "GET /users",
    "crear_usuario": "POST /users",
    "listar_pedidos_de_usuario": "GET /users/{id}/orders",
    "crear_pedido_de_usuario": "POST /users/{id}/orders",
    "obtener_pedido_de_usuario": "GET /users/{id}/orders/{orderId}",
    "cancelar_pedido": "PATCH /users/{id}/orders/{orderId}",
    "listar_items_de_pedido": "GET /orders/{id}/items"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
