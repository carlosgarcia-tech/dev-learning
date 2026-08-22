# Ejercicio 02 — PKCE

- **Nivel:** 4/5
- **Tema:** Proof Key for Code Exchange (PKCE)
- **Tiempo estimado:** 35 min

## Enunciado

PKCE protege el authorization code flow en clientes públicos (SPAs, móviles) que no pueden guardar un `client_secret`. El client genera un `code_verifier` (aleatorio) y un `code_challenge` (SHA256 del verifier en base64url).

Tu tarea es generar un par PKCE válido y completar el flujo en `pkce.json`.

Pasos:

1. Genera un `code_verifier` aleatorio (43-128 chars URL-safe).
2. Calcula `code_challenge = base64url(SHA256(code_verifier))`.
3. Completa `pkce.json` con el verifier, el challenge y el método.
4. Verifica que el challenge es correcto.
5. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `pkce.json` es JSON válido
- [ ] `code_verifier` tiene entre 43 y 128 caracteres
- [ ] `code_verifier` solo contiene `[A-Za-z0-9-._~]`
- [ ] `code_challenge` es `base64url(SHA256(code_verifier))` (verificado por test.sh)
- [ ] `code_challenge_method` es `"S256"`
- [ ] `code_challenge` no contiene padding `=`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `code_verifier`: string aleatorio de al menos 43 caracteres, generado con un CSPRNG.
- `code_challenge`: `base64url(SHA256(code_verifier))`, sin padding `=`.
- El método `S256` indica que el challenge se calcula con SHA-256.
- En Python:

```python
import secrets, hashlib, base64

code_verifier = secrets.token_urlsafe(64)[:43]
digest = hashlib.sha256(code_verifier.encode()).digest()
code_challenge = base64.urlsafe_b64encode(digest).rstrip(b'=').decode('ascii')
```

- El `code_verifier` se envía en el paso de token exchange; el `code_challenge` va en el authorization request.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`pkce.json`:

```json
{
  "code_verifier": "vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG7eY1bK3mN9oP",
  "code_challenge": "k2pQ9vF2mBpL8hR1tYwZcA4bD6eG0iJkMnO5pQsU8w0",
  "code_challenge_method": "S256"
}
```

Generar PKCE:

```python
import secrets, hashlib, base64

def generate_pkce():
    code_verifier = secrets.token_urlsafe(64)[:43]
    digest = hashlib.sha256(code_verifier.encode()).digest()
    code_challenge = base64.urlsafe_b64encode(digest).rstrip(b'=').decode('ascii')
    return code_verifier, code_challenge, "S256"

verifier, challenge, method = generate_pkce()
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
