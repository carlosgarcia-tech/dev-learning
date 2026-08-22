# Ejercicio 01 — TOTP MFA

- **Nivel:** 5/5
- **Tema:** TOTP (Time-based One-Time Password) para MFA
- **Tiempo estimado:** 45 min

## Enunciado

TOTP (RFC 6238) genera códigos de 6 dígitos que cambian cada 30 segundos, a partir de un secret compartido y la hora actual. Es el método de MFA más usado (Google Authenticator, Authy).

Tu tarea es generar un código TOTP válido para un secret dado y completar la verificación.

Pasos:

1. Examina `totp.json` con el secret y el timestamp.
2. Genera el código TOTP de 6 dígitos usando HMAC-SHA1.
3. Verifica el código con una ventana de ±30s.
4. Ejecuta `bash test.sh`.

### Algoritmo TOTP

```
1. counter = timestamp // 30
2. key = base32_decode(secret)
3. msg = pack(">Q", counter)   # 8 bytes big-endian
4. hash = HMAC-SHA1(key, msg)
5. offset = hash[-1] & 0x0F
6. code = unpack(">I", hash[offset:offset+4])[0] & 0x7FFFFFFF
7. otp = code % 1000000  → str(otp).zfill(6)
```

## Requisitos

- [ ] `totp.json` es JSON válido
- [ ] `secret` es `"JBSWY3DPEHPK3PXP"` (base32)
- [ ] `timestamp` es `1700000000`
- [ ] `codigo_generado` es el código TOTP de 6 dígitos correcto
- [ ] `ventana_segundos` es `30`
- [ ] `digitos` es `6`
- [ ] `algoritmo` es `"HMAC-SHA1"`
- [ ] `otpauth_uri` sigue el formato `otpauth://totp/...`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El secret `JBSWY3DPEHPK3PXP` es un secret base32 válido.
- `counter = 1700000000 // 30 = 56666666`
- Usa `hmac.new(key, msg, hashlib.sha1)` para el HMAC.
- `struct.pack(">Q", counter)` empaqueta el counter como 8 bytes big-endian.
- El dynamic truncation usa los últimos 4 bits del hash para determinar el offset.
- El código final es `code % 1000000`, rellenado con ceros a la izquierda hasta 6 dígitos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`totp.json`:

```json
{
  "secret": "JBSWY3DPEHPK3PXP",
  "timestamp": 1700000000,
  "codigo_generado": "287082",
  "ventana_segundos": 30,
  "digitos": 6,
  "algoritmo": "HMAC-SHA1",
  "otpauth_uri": "otpauth://totp/FiltroPro:alice@example.com?secret=JBSWY3DPEHPK3PXP&issuer=FiltroPro&digits=6&period=30"
}
```

Generar TOTP:

```python
import hmac, hashlib, struct, base64, time

def totp_code(secret_b32, timestamp=None):
    if timestamp is None:
        timestamp = int(time.time())
    counter = timestamp // 30
    key = base64.b32decode(secret_b32)
    msg = struct.pack(">Q", counter)
    digest = hmac.new(key, msg, hashlib.sha1).digest()
    offset = digest[-1] & 0x0F
    code = struct.unpack(">I", digest[offset:offset+4])[0] & 0x7FFFFFFF
    return str(code % 1000000).zfill(6)

print(totp_code("JBSWY3DPEHPK3PXP", 1700000000))
# 287082
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
