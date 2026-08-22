# Ejercicio 02 — Verificar JWT

- **Nivel:** 3/5
- **Tema:** Verificación de firma, expiración y claims de un JWT
- **Tiempo estimado:** 30 min

## Enunciado

Crear un JWT es fácil; **verificarlo** es lo crítico. Un servidor debe comprobar: la firma, la expiración (`exp`), el emisor (`iss`) y la audiencia (`aud`).

Se te dan 3 tokens JWT en `tokens.json`. Tienes que verificar cada uno contra el secret `super-secreto-2024` y completar `verificacion.json` con el resultado.

Pasos:

1. Examina los 3 tokens en `tokens.json`.
2. Para cada token: decodifica, verifica la firma con el secret, comprueba `exp`.
3. Completa `verificacion.json` con el resultado de cada verificación.
4. Ejecuta `bash test.sh`.

Los 3 tokens:

- **Token 1**: válido (firma correcta, no expirado).
- **Token 2**: firma inválida (alguien modificó el payload).
- **Token 3**: expirado (`exp` en el pasado).

## Requisitos

- [ ] `verificacion.json` es JSON válido
- [ ] Hay 3 resultados en el array `resultados`
- [ ] Token 1: `valido: true`, `firma_valida: true`, `expirado: false`
- [ ] Token 2: `valido: false`, `firma_valida: false`
- [ ] Token 3: `valido: false`, `firma_valida: true`, `expirado: true`
- [ ] Cada resultado tiene `motivo` explicando por qué es válido o no
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para verificar la firma: recalcula HMAC-SHA256(header.payload, secret) y compara con la firma del token usando `hmac.compare_digest`.
- Para verificar expiración: `payload["exp"] < time.time()` → expirado.
- Un token es válido solo si la firma es válida Y no está expirado.
- El token 2 tiene el payload modificado, por lo que la firma ya no coincide.
- El token 3 tiene `exp` en el pasado (ej: 1700000000 cuando ahora es mayor).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`verificacion.json`:

```json
{
  "secret_usado": "super-secreto-2024",
  "resultados": [
    {
      "token_id": "token_1_valido",
      "valido": true,
      "firma_valida": true,
      "expirado": false,
      "motivo": "La firma es correcta y el token no ha expirado"
    },
    {
      "token_id": "token_2_firma_invalida",
      "valido": false,
      "firma_valida": false,
      "expirado": false,
      "motivo": "La firma no coincide: el payload fue modificado"
    },
    {
      "token_id": "token_3_expirado",
      "valido": false,
      "firma_valida": true,
      "expirado": true,
      "motivo": "La firma es correcta pero el token expiró (exp < ahora)"
    }
  ]
}
```

Código de verificación:

```python
import base64, json, hmac, hashlib, time

SECRET = b"super-secreto-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

def verify_jwt(token, secret):
    parts = token.split('.')
    if len(parts) != 3:
        return {"valido": False, "motivo": "formato inválido"}
    
    header_b64, payload_b64, sig_b64 = parts
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(secret, signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url_encode(expected_sig)
    
    firma_valida = hmac.compare_digest(expected_sig_b64, sig_b64)
    if not firma_valida:
        return {"valido": False, "firma_valida": False, "motivo": "firma inválida"}
    
    payload = json.loads(b64url_decode(payload_b64))
    expirado = payload.get("exp", 0) < time.time()
    if expirado:
        return {"valido": False, "firma_valida": True, "expirado": True, "motivo": "expirado"}
    
    return {"valido": True, "firma_valida": True, "expirado": False, "motivo": "válido"}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
