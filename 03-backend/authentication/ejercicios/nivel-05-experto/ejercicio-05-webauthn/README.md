# Ejercicio 05 — WebAuthn

- **Nivel:** 5/5
- **Tema:** WebAuthn / FIDO2 - Registro y autenticación con claves públicas
- **Tiempo estimado:** 50 min

## Enunciado

WebAuthn (Web Authentication) usa claves públicas/privadas generadas en un autenticador (llave USB, Secure Enclave, Touch ID). El servidor nunca ve la clave privada. Es **phishing-resistant** porque el autenticador solo responde al dominio correcto.

Tu tarea es completar el flujo de registro (attestation) y login (assertion) de WebAuthn en `webauthn.json`.

Flujo WebAuthn:

**Registro (attestation):**

1. Servidor envía `challenge` + configuración RP (relying party).
2. Autenticador genera par de claves (priv/públic).
3. Autenticador firma el challenge con la clave privada.
4. Servidor guarda la clave pública.

**Login (assertion):**

1. Servidor envía `challenge` nuevo.
2. Autenticador firma el challenge con la clave privada.
3. Servidor verifica con la clave pública guardada.

Pasos:

1. Completa `webauthn.json` con los dos flujos.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `webauthn.json` es JSON válido
- [ ] `registro.challenge` no está vacío (mínimo 16 caracteres)
- [ ] `registro.rp.name` no está vacío
- [ ] `registro.rp.id` no está vacío (dominio)
- [ ] `registro.user.id` no está vacío
- [ ] `registro.pubKeyCredParams` es un array con al menos un elemento
- [ ] `registro_respuesta.credential_id` no está vacío
- [ ] `registro_respuesta.public_key` no está vacío
- [ ] `login.challenge` no está vacío y es distinto del de registro
- [ ] `login_respuesta.signature` no está vacío
- [ ] `login_respuesta.verified` es `true`
- [ ] `phishing_resistant` es `true`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `challenge` es un valor aleatorio que el servidor genera en cada operación. Debe ser único.
- El `rp.id` (relying party ID) es el dominio del sitio: `app.com`.
- `pubKeyCredParams` especifica los algoritmos de clave pública soportados: `-7` (ES256/ECDSA), `-257` (RS256/RSA).
- El `credential_id` es el identificador de la credencial generada por el autenticador.
- La `public_key` se guarda en el servidor; la clave privada nunca sale del autenticador.
- En el login, el autenticador firma el challenge con la clave privada; el servidor verifica con la pública.
- WebAuthn es phishing-resistant porque el autenticador verifica el origen (rp.id) antes de responder.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`webauthn.json`:

```json
{
  "registro": {
    "challenge": "register_challenge_random_abc123xyz789",
    "rp": {
      "name": "FiltroPro",
      "id": "app.com"
    },
    "user": {
      "id": "user_123",
      "name": "alice@example.com",
      "displayName": "Alice García"
    },
    "pubKeyCredParams": [
      { "type": "public-key", "alg": -7 },
      { "type": "public-key", "alg": -257 }
    ]
  },
  "registro_respuesta": {
    "credential_id": "cred_abc123xyz789",
    "public_key": "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE...\n-----END PUBLIC KEY-----"
  },
  "login": {
    "challenge": "login_challenge_random_def456uvw012",
    "credential_id": "cred_abc123xyz789"
  },
  "login_respuesta": {
    "signature": "base64url_signature_here",
    "verified": true
  },
  "phishing_resistant": true,
  "descripcion": "WebAuthn es phishing-resistant porque el autenticador solo responde al dominio correcto (rp.id). Un sitio de phishing no puede obtener la firma porque el autenticador verifica el origen."
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
