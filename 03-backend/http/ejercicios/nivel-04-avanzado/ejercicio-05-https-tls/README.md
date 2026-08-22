# Ejercicio 05 — HTTPS y TLS (Explicación Práctica)

- **Nivel:** 4/5
- **Tema:** HTTPS, TLS, certificados y CA
- **Tiempo estimado:** 35 min

## Enunciado

Este ejercicio es teórico-práctico. El servidor `server.sh` (puerto 8099) sirve `GET /` con headers HSTS. Tu tarea es completar `respuesta.json` con las afirmaciones correctas sobre HTTPS y TLS, y el `test.sh` validará tus respuestas.

Responde a estas preguntas en `respuesta.json`:

1. ¿Qué protocolo de transporte usa HTTPS? → `transporte`
2. ¿Qué handshake ocurre antes de enviar datos HTTP? → `handshake`
3. ¿Quién emite los certificados de confianza? → `quien_emite`
4. ¿Qué header fuerza HTTPS? → `header_https`
5. ¿Pueden las cookies `Secure` enviarse por HTTP? → `cookie_secure_http`

## Requisitos

- [ ] `respuesta.json` es JSON válido
- [ ] `transporte` menciona `TLS` (o `SSL`)
- [ ] `handshake` menciona `TLS` (o `certificado`)
- [ ] `quien_emite` menciona `CA` (o `Certificate Authority`)
- [ ] `header_https` es `Strict-Transport-Security`
- [ ] `cookie_secure_http` es `false`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- HTTPS = HTTP sobre TLS (antes SSL).
- El handshake TLS intercambia certificados y deriva claves de sesión.
- Las CA (Certificate Authorities) firman certificados.
- HSTS fuerza HTTPS.
- Las cookies `Secure` solo se envían por HTTPS.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "transporte": "TLS",
  "handshake": "TLS handshake con intercambio de certificados y claves",
  "quien_emite": "CA (Certificate Authority)",
  "header_https": "Strict-Transport-Security",
  "cookie_secure_http": false
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
