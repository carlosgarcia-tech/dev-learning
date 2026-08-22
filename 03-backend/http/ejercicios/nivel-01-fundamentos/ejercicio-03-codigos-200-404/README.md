# Ejercicio 03 — Códigos de estado 200 y 404

- **Nivel:** 1/5
- **Tema:** Códigos de estado HTTP
- **Tiempo estimado:** 15 min

## Enunciado

Tienes un servidor en `server.sh` con dos rutas: `/ok` (devuelve 200) y `/inexistente` (devuelve 404). Completa `expected.json` con los códigos de estado que devuelve cada ruta, y completa `peticiones.http` con las dos peticiones en texto plano.

El `expected.json` debe ser un objeto:

```json
{"rutas": {"ok": 200, "no_encontrada": 404}}
```

## Requisitos

- [ ] `peticiones.http` contiene dos peticiones GET (a `/ok` y a `/inexistente`)
- [ ] `peticiones.http` incluye `Host: localhost:8081`
- [ ] `expected.json` es JSON válido
- [ ] `expected.json` mapea `ok` → 200 y `no_encontrada` → 404
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El código de estado va en la primera línea de la respuesta: `HTTP/1.1 200 OK`.
- `curl -s -o /dev/null -w "%{http_code}"` imprime solo el código.
- La ruta que existe devuelve 200; la que no, 404.
- Para ver el código y los headers sin el body: `curl -i` o `curl -I`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /ok HTTP/1.1
Host: localhost:8081

GET /inexistente HTTP/1.1
Host: localhost:8081
```

`expected.json`:

```json
{"rutas": {"ok": 200, "no_encontrada": 404}}
```

Comprobar con curl:

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8081/ok          # 200
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8081/inexistente  # 404
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
