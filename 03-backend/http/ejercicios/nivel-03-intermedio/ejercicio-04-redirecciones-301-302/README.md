# Ejercicio 04 — Redirecciones 301 y 302

- **Nivel:** 3/5
- **Tema:** Redirecciones HTTP
- **Tiempo estimado:** 25 min

## Enunciado

El servidor `server.sh` (puerto 8092) tiene una ruta antigua `/viejo` que redirige permanentemente (301) a `/nuevo`, y una ruta `/temp` que redirige temporalmente (302) a `/nuevo`.

Completa `peticiones.http` con las dos peticiones y `respuesta.json` indicando los códigos y la cabecera `Location` esperada.

## Requisitos

- [ ] `peticiones.http` tiene `GET /viejo`
- [ ] `peticiones.http` tiene `GET /temp`
- [ ] `respuesta.json` mapea cada ruta a su código (301/302) y `Location`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 301 = permanente (el cliente cachea el destino).
- 302 = temporal (no cachea).
- Ambas llevan `Location` con la URL destino.
- `curl -s -o /dev/null -w "%{http_code} %{redirect_url}"` muestra el código y el destino.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /viejo HTTP/1.1
Host: localhost:8092

GET /temp HTTP/1.1
Host: localhost:8092
```

`respuesta.json`:

```json
{
  "rutas": {
    "viejo": {"status": 301, "location": "/nuevo"},
    "temp": {"status": 302, "location": "/nuevo"}
  }
}
```

Comprobar (sin seguir redirecciones):

```bash
curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" http://localhost:8092/viejo
# → 301 http://localhost:8092/nuevo
curl -s -o /dev/null -w "%{http_code} %{redirect_url}\n" http://localhost:8092/temp
# → 302 http://localhost:8092/nuevo
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
