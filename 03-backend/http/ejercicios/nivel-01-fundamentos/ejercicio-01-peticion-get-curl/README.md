# Ejercicio 01 — Petición GET con curl

- **Nivel:** 1/5
- **Tema:** Peticiones HTTP con curl
- **Tiempo estimado:** 15 min

## Enunciado

Tu primera petición HTTP. Tienes un servidor de prueba en `server.sh` que arranca en `http://localhost:8080` y responde a varias rutas. Tu tarea es escribir en `peticiones.http` el texto plano de la petición HTTP GET y en `respuesta.json` el JSON esperado de la respuesta, de modo que el `test.sh` valide todo el flujo.

Pasos:

1. Examina `server.sh` para ver las rutas disponibles.
2. Completa `peticiones.http` con una petición GET en texto plano (request line + headers).
3. Completa `expected.json` con el body de respuesta esperado (formato JSON).
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `peticiones.http` contiene una request line `GET /saludo HTTP/1.1`
- [ ] `peticiones.http` incluye el header `Host: localhost:8080`
- [ ] `expected.json` es JSON válido
- [ ] `expected.json` coincide con lo que devuelve `GET /saludo`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una petición HTTP en texto plano empieza por la request line: `METODO /ruta HTTP/versión`.
- Después vienen los headers, uno por línea, con formato `Nombre: valor`.
- Para ver la petición cruda que envía curl, usa `curl -v`.
- El servidor `server.sh` define la ruta `/saludo` y devuelve un JSON sencillo.
- `Host` es obligatorio en HTTP/1.1.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /saludo HTTP/1.1
Host: localhost:8080
User-Agent: curl/8.0
Accept: */*
```

`expected.json`:

```json
{"mensaje": "Hola, mundo"}
```

Verificar a mano:

```bash
# Arrancar el servidor en una terminal
bash server.sh &
# Consultar
curl -s http://localhost:8080/saludo
# → {"mensaje": "Hola, mundo"}
# Parar el servidor
kill %1
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
