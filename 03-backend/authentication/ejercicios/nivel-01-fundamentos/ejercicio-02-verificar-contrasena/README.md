# Ejercicio 02 — Verificar contraseña contra hash

- **Nivel:** 1/5
- **Tema:** Verificación de contraseñas con bcrypt
- **Tiempo estimado:** 20 min

## Enunciado

Dado un hash bcrypt almacenado y varias contraseñas candidatas, debes determinar cuál es la correcta. Completa `verificacion.json` con la contraseña que coincide con el hash y el resultado de verificación para cada candidata.

El hash bcrypt almacenado es:

```
$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
```

Las contraseñas candidatas a probar:

1. `123456`
2. `password123`
3. `admin`
4. `qwerty`

Pasos:

1. Examina `hash.json` que contiene el hash bcrypt y las candidatas.
2. Determina cuál candidata coincide con el hash.
3. Completa `verificacion.json` indicando la contraseña correcta y el resultado de cada verificación.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `verificacion.json` es JSON válido
- [ ] `password_correcta` indica la contraseña que coincide con el hash
- [ ] `resultados` es un array con 4 elementos, uno por candidata
- [ ] Cada resultado tiene `password` y `coincide` (boolean)
- [ ] Exactamente una candidata tiene `coincide: true`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El hash empieza por `$2b$12$`, lo que indica bcrypt con cost factor 12.
- La verificación de bcrypt no "desencripta" el hash: toma la contraseña candidata, la hashea con el mismo salt y compara los resultados.
- El salt está embebido en el hash bcrypt (`N9qo8uLOickgx2ZMRZoMye`).
- Si tuvieras Python con bcrypt instalado: `bcrypt.checkpw(b"password123", hash)`.
- En este ejercicio, la respuesta correcta es `password123` (es un hash real para esa contraseña).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`verificacion.json`:

```json
{
  "hash_almacenado": "$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
  "password_correcta": "password123",
  "resultados": [
    { "password": "123456", "coincide": false },
    { "password": "password123", "coincide": true },
    { "password": "admin", "coincide": false },
    { "password": "qwerty", "coincide": false }
  ]
}
```

El proceso de verificación:

```python
import bcrypt

hash_almacenado = b"$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy"
candidatas = [b"123456", b"password123", b"admin", b"qwerty"]

for c in candidatas:
    print(c.decode(), bcrypt.checkpw(c, hash_almacenado))
# 123456 False
# password123 True
# admin False
# qwerty False
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
