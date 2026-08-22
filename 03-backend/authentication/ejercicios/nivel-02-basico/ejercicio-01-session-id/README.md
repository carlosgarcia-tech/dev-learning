# Ejercicio 01 — Session ID

- **Nivel:** 2/5
- **Tema:** Generación de Session ID seguro
- **Tiempo estimado:** 20 min

## Enunciado

El session ID es la clave que identifica una sesión en el servidor. Debe ser **aleatorio, impredecible y con suficiente entropía**. En este ejercicio vas a generar un session ID seguro y documentar sus propiedades.

Un session ID seguro debe:
- Tener al menos 128 bits de entropía (preferible 256).
- Generarse con un CSPRNG (Cryptographically Secure Pseudo-Random Number Generator).
- No ser secuencial ni predecible.

Pasos:

1. Genera un session ID aleatorio de 256 bits (32 bytes) usando un CSPRNG.
2. Completa `session.json` con el session ID y sus propiedades.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `session.json` es JSON válido
- [ ] `session_id` tiene al menos 32 caracteres
- [ ] `session_id` solo contiene caracteres URL-safe (`[A-Za-z0-9_-]`)
- [ ] `session_id` no contiene espacios ni `+` ni `/` ni `=`
- [ ] `entropia_bits` es `256`
- [ ] `algoritmo` es `"CSPRNG"` o `"secrets.token_urlsafe"`
- [ ] `prefijo` es `"sess_"`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En Python: `secrets.token_urlsafe(32)` genera 32 bytes aleatorios → ~43 caracteres URL-safe.
- `secrets` usa el CSPRNG del sistema operativo (`/dev/urandom` en Linux).
- Nunca uses `random.random()` para session IDs: no es criptográficamente seguro.
- Un prefijo `sess_` ayuda a identificar y buscar session IDs en logs.
- 256 bits de entropía = 2^256 combinaciones → imposible de adivinar por fuerza bruta.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`session.json`:

```json
{
  "session_id": "sess_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG",
  "entropia_bits": 256,
  "algoritmo": "secrets.token_urlsafe",
  "prefijo": "sess_",
  "almacenamiento": "Redis con TTL"
}
```

Generar un session ID seguro:

```python
import secrets

def generate_session_id():
    # 32 bytes = 256 bits de entropía
    random_part = secrets.token_urlsafe(32)  # ~43 chars URL-safe
    return f"sess_{random_part}"

sid = generate_session_id()
# Ej: sess_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG...
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
