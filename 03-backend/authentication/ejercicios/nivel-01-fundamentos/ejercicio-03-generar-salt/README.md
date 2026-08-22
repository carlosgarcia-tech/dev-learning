# Ejercicio 03 — Generar salt

- **Nivel:** 1/5
- **Tema:** Generación de salt y formato bcrypt
- **Tiempo estimado:** 20 min

## Enunciado

El salt es la base de la seguridad de las contraseñas. En este ejercicio vas a entender qué es un salt y por qué cada contraseña debe tener el suyo. Tienes que generar un salt aleatorio válido para bcrypt y completar `salt.json` con las propiedades del salt.

Pasos:

1. Observa el salt de referencia en `salt.json` (campo `salt_referencia`).
2. Genera un salt aleatorio de 22 caracteres del alfabeto base64.
3. Completa los campos `salt`, `longitud`, `alfabeto` y `entropia_bits`.
4. Ejecuta `bash test.sh`.

### Cómo generar un salt aleatorio

Un salt de bcrypt usa 22 caracteres del alfabeto base64: `A-Z`, `a-z`, `0-9`, `.`, `/`.

```python
import secrets
import string

alphabet = string.ascii_letters + string.digits + "./"
salt = ''.join(secrets.choice(alphabet) for _ in range(22))
print(salt)
```

El salt debe tener 22 caracteres → 22 × 6 bits = 132 bits de entropía.

## Requisitos

- [ ] `salt.json` es JSON válido
- [ ] `salt` tiene exactamente 22 caracteres
- [ ] `salt` solo contiene caracteres de `[A-Za-z0-9./]`
- [ ] `salt` es distinto de `salt_referencia` (debe ser único)
- [ ] `longitud` es `22`
- [ ] `alfabeto` describe el alfabeto: `[A-Za-z0-9./]`
- [ ] `entropia_bits` es `132`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El alfabeto base64 estándar para bcrypt es: `A-Z`, `a-z`, `0-9`, `+`, `/` → 64 caracteres.
- En bcrypt el salt usa 22 caracteres de este alfabeto. Cada carácter aporta 6 bits de entropía (2^6 = 64).
- 22 caracteres × 6 bits = 132 bits de entropía.
- Usa `secrets.choice` (CSPRNG) para generar cada carácter, nunca `random.choice`.
- El salt de referencia es `N9qo8uLOickgx2ZMRZoMye`; el tuyo debe ser distinto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`salt.json`:

```json
{
  "salt_referencia": "N9qo8uLOickgx2ZMRZoMye",
  "salt": "AbCdEfGhIjKlMnOpQrStUv",
  "longitud": 22,
  "alfabeto": "[A-Za-z0-9./]",
  "entropia_bits": 132
}
```

Generar un salt aleatorio seguro:

```python
import secrets
import string

alphabet = string.ascii_letters + string.digits + "./"
salt = ''.join(secrets.choice(alphabet) for _ in range(22))
print(salt)
# Ej: xK9mP3vN7qR2sW4tL8jB6f
```

Para construir un hash bcrypt completo con tu salt:

```python
password = b"password123"
salt_full = b"$2b$12$" + salt.encode()
# hash = bcrypt.hashpw(password, salt_full)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
