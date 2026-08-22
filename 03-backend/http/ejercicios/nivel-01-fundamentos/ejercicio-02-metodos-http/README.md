# Ejercicio 02 — Métodos HTTP

- **Nivel:** 1/5
- **Tema:** Métodos HTTP y su intención
- **Tiempo estimado:** 15 min

## Enunciado

Para cada operación del negocio, escribe en `respuesta.json` el método HTTP correcto. La tabla cubre las operaciones más habituales de una API de productos.

Operaciones:

1. Listar todos los productos.
2. Obtener un producto por su id.
3. Crear un producto nuevo.
4. Reemplazar por completo un producto.
5. Modificar solo el precio de un producto.
6. Borrar un producto.
7. Saber qué métodos soporta un recurso (metadatos).
8. Obtener solo los headers de un producto (sin el body).

Escribe en `respuesta.json` un objeto `operaciones` que mapea cada clave a un método HTTP en mayúsculas.

## Requisitos

- [ ] `respuesta.json` es JSON válido con un objeto `operaciones`
- [ ] Cada operación tiene el método HTTP correcto
- [ ] GET se usa solo para lectura
- [ ] POST se usa para crear
- [ ] PUT para reemplazar, PATCH para modificar parcial
- [ ] DELETE para borrar
- [ ] OPTIONS y HEAD aparecen donde corresponde
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Listar y obtener son operaciones de lectura → GET.
- Crear es POST sobre la colección.
- PUT reemplaza todo el recurso; PATCH modifica parcial.
- Borrar es DELETE.
- OPTIONS describe las opciones de comunicación del recurso.
- HEAD devuelve lo mismo que GET pero sin body.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "operaciones": {
    "listar_productos": "GET",
    "obtener_producto_por_id": "GET",
    "crear_producto": "POST",
    "reemplazar_producto": "PUT",
    "modificar_precio_producto": "PATCH",
    "borrar_producto": "DELETE",
    "saber_metodos_soportados": "OPTIONS",
    "obtener_solo_headers": "HEAD"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
