# Ejercicio 01 — Diseñar URL RESTful

- **Nivel:** 1/5
- **Tema:** Diseño de URLs RESTful
- **Tiempo estimado:** 10 min

## Enunciado

Estás diseñando la API REST de una tienda online con estos recursos: **productos**, **usuarios** y **pedidos** (orders). Para cada operación del negocio, escribe la URL RESTful correcta usando el método HTTP adecuado.

Operaciones a cubrir:

1. Listar todos los productos.
2. Obtener un producto concreto por su id.
3. Crear un producto nuevo.
4. Reemplazar por completo un producto existente.
5. Modificar solo el precio de un producto.
6. Borrar un producto.
7. Listar los pedidos de un usuario concreto.
8. Obtener un pedido concreto de un usuario.

Escribe tu respuesta en `respuesta.json` siguiendo el formato de `respuesta.json` de ejemplo (un objeto `operaciones` que mapea cada operación a `"METODO /ruta"`).

## Requisitos

- [ ] Todas las rutas usan sustantivos en **plural** (`/products`, no `/product`)
- [ ] Ninguna ruta contiene **verbos** (`/getProducts` está mal)
- [ ] Los identificadores van al final del path del recurso (`/products/{id}`)
- [ ] El método HTTP expresa la intención (GET=leer, POST=crear, PUT=reemplazar, PATCH=modificar parcial, DELETE=borrar)
- [ ] Los sub-recursos se anidan bajo el padre (`/users/{id}/orders`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una colección se lista y se crea con la misma URI base (`/products`); el método distingue: GET lista, POST crea.
- Un item individual se identifica añadiendo el id: `/products/prod_001`.
- PUT reemplaza todo; PATCH modifica parcial (ideal para cambiar solo el precio).
- Para "pedidos de un usuario", anida: `/users/{userId}/orders`.
- No inventes verbos: `/getProduct`, `/createOrder`, `/deleteUser` son anti-patrones RPC.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

````json
{
  "operaciones": {
    "listar_productos": "GET /products",
    "obtener_producto_por_id": "GET /products/prod_001",
    "crear_producto": "POST /products",
    "reemplazar_producto": "PUT /products/prod_001",
    "modificar_precio_producto": "PATCH /products/prod_001",
    "borrar_producto": "DELETE /products/prod_001",
    "listar_pedidos_de_usuario": "GET /users/usr_123/orders",
    "obtener_pedido_de_usuario": "GET /users/usr_123/orders/ord_456"
  }
}
````

Principios aplicados:
- Plurales: `/products`, `/users`, `/orders`.
- Sin verbos en la URL: el método HTTP (`GET`, `POST`...) expresa la acción.
- IDs al final: `/products/prod_001`.
- Sub-recursos anidados: `/users/usr_123/orders`.

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
