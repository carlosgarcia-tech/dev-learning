# Ejercicio 05 — Estructura de URL

- **Nivel:** 1/5
- **Tema:** Componentes de una URL
- **Tiempo estimado:** 15 min

## Enunciado

Descompón esta URL en sus partes:

```
https://api.tienda.com:8443/v1/products?limit=10&sort=desc#resultados
```

Escribe en `respuesta.json` un objeto `url` con las claves: `esquema`, `host`, `puerto`, `path`, `query` y `fragment`. El `query` debe ser un objeto con cada parámetro.

## Requisitos

- [ ] `respuesta.json` es JSON válido
- [ ] `esquema` es `https`
- [ ] `host` es `api.tienda.com`
- [ ] `puerto` es `8443`
- [ ] `path` es `/v1/products`
- [ ] `query` es un objeto con `limit: "10"` y `sort: "desc"`
- [ ] `fragment` es `resultados`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El esquema va antes de `://`.
- El host es el dominio; el puerto va después de `:`, si existe.
- El path empieza en `/` y va hasta `?` (o hasta `#` si no hay query).
- El query empieza en `?`, pares `k=v` separados por `&`.
- El fragment empieza en `#` y **no se envía al servidor**.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "url": {
    "esquema": "https",
    "host": "api.tienda.com",
    "puerto": "8443",
    "path": "/v1/products",
    "query": {
      "limit": "10",
      "sort": "desc"
    },
    "fragment": "resultados"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
