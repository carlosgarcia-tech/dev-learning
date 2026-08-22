# Ejercicio 01 — GET con Query Params

- **Nivel:** 2/5
- **Tema:** Parámetros de consulta (query string)
- **Tiempo estimado:** 20 min

## Enunciado

El servidor `server.sh` expone `GET /productos` y acepta los query params `categoria`, `orden` (asc/desc) y `limite` (número). Completa `peticiones.http` con la petición GET que pide productos de la categoría `electronica`, ordenados desc y con límite 5. Luego completa `expected.json` con la respuesta JSON que el servidor devuelve.

El servidor corre en el puerto 8083. Para construir la query string, une los pares con `&` después del `?`.

## Requisitos

- [ ] `peticiones.http` tiene `GET /productos?categoria=electronica&orden=desc&limite=5 HTTP/1.1`
- [ ] `peticiones.http` incluye `Host: localhost:8083`
- [ ] `expected.json` es JSON válido
- [ ] `expected.json` coincide con la respuesta del servidor
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El query string empieza con `?` y separa parámetros con `&`: `?categoria=electronica&orden=desc&limite=5`.
- No pongas espacios alrededor del `=`.
- `curl -s "http://localhost:8083/productos?categoria=electronica&orden=desc&limite=5"` te muestra la respuesta.
- El servidor filtra por categoría, ordena y limita la lista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /productos?categoria=electronica&orden=desc&limite=5 HTTP/1.1
Host: localhost:8083
Accept: application/json
```

`expected.json` (lo que devuelve el servidor):

```json
{
  "total": 2,
  "productos": [
    {"id": 3, "nombre": "Monitor", "categoria": "electronica", "precio": 249.99},
    {"id": 1, "nombre": "Teclado", "categoria": "electronica", "precio": 49.99}
  ]
}
```

Comprobar con curl:

```bash
curl -s "http://localhost:8083/productos?categoria=electronica&orden=desc&limite=5"
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
