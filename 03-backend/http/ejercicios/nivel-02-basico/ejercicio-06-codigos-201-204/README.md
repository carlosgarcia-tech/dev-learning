# Ejercicio 06 — Códigos 201 y 204

- **Nivel:** 2/5
- **Tema:** Cuándo usar 201 vs 204
- **Tiempo estimado:** 20 min

## Enunciado

Asocia cada escenario con su código de estado correcto. El servidor `server.sh` (puerto 8088) expone varias rutas que demuestran los códigos. Completa `respuesta.json` mapeando cada escenario a su código.

Escenarios:

1. `POST /recursos` crea un recurso y devuelve el recurso creado → ?
2. `DELETE /recursos/1` borra un recurso sin devolver body → ?
3. `POST /recursos` crea un recurso pero no devuelve body → ?
4. `GET /recursos/1` devuelve un recurso existente → ?
5. `PUT /recursos/1` reemplaza un recurso y devuelve el recurso actualizado → ?
6. `DELETE /recursos/999` intenta borrar un recurso que no existe → ?

El `respuesta.json` debe ser un objeto `escenarios` con cada clave (en snake_case) mapeada al código numérico.

## Requisitos

- [ ] `respuesta.json` es JSON válido con un objeto `escenarios`
- [ ] Crear con body → 201
- [ ] Borrar sin body → 204
- [ ] Crear sin body → 204
- [ ] Obtener existente → 200
- [ ] Reemplazar con body → 200
- [ ] Borrar inexistente → 404
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 201 Created: se creó un recurso y se devuelve en el body.
- 204 No Content: éxito sin body (DELETE, o un POST/PUT que no devuelve nada).
- 200 OK: éxito con body.
- 404: el recurso no existe.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "escenarios": {
    "post_crea_con_body": 201,
    "delete_sin_body": 204,
    "post_crea_sin_body": 204,
    "get_existente": 200,
    "put_reemplaza_con_body": 200,
    "delete_inexistente": 404
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
