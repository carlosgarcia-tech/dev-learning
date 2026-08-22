# Ejercicio 03 — Headers de Seguridad

- **Nivel:** 4/5
- **Tema:** Headers de seguridad HTTP
- **Tiempo estimado:** 30 min

## Enunciado

El servidor `server.sh` (puerto 8097) sirve una página en `GET /` con varios **headers de seguridad**. Completa `respuesta.json` listando qué headers de seguridad DEBE devolver el servidor (con sus valores), y comprueba que están presentes.

Los headers esperados:

- `Strict-Transport-Security`
- `X-Content-Type-Options`
- `X-Frame-Options`
- `Content-Security-Policy`

## Requisitos

- [ ] `respuesta.json` es JSON válido con un objeto `headers`
- [ ] Incluye `Strict-Transport-Security` con `max-age`
- [ ] Incluye `X-Content-Type-Options: nosniff`
- [ ] Incluye `X-Frame-Options: DENY`
- [ ] Incluye `Content-Security-Policy` con `default-src`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- HSTS: `Strict-Transport-Security: max-age=31536000; includeSubDomains`.
- `X-Content-Type-Options: nosniff` evita MIME sniffing.
- `X-Frame-Options: DENY` evita clickjacking.
- CSP: `Content-Security-Policy: default-src 'self'` restringe la carga de recursos.
- `curl -s -D - -o /dev/null` muestra todos los headers de respuesta.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "headers": {
    "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Content-Security-Policy": "default-src 'self'"
  }
}
```

Comprobar:

```bash
curl -s -D - -o /dev/null http://localhost:8097/ | grep -iE 'strict-transport|x-content|x-frame|content-security'
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
