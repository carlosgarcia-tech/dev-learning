# Ejercicio 05 — Flujo de login

- **Nivel:** 1/5
- **Tema:** Flujo de login y verificación de credenciales
- **Tiempo estimado:** 25 min

## Enunciado

Vas a construir el flujo de login: recibir email y contraseña, buscar el hash almacenado, verificar la contraseña y devolver el resultado. Completa `login.json` con el resultado de un login correcto y uno incorrecto.

El sistema tiene registrado:

```json
{
  "email": "alice@example.com",
  "password_hash": "$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
  "password_correcta": "password123"
}
```

Tienes dos intentos de login:

1. Login correcto: `alice@example.com` + `password123`
2. Login incorrecto: `alice@example.com` + `wrongpass`

Pasos:

1. Examina `usuario.json` con el hash almacenado.
2. Completa `login.json` con el resultado de cada intento.
3. Para el intento correcto: `status: "success"`, `authenticated: true`.
4. Para el intento incorrecto: `status: "error"`, `authenticated: false`, mensaje genérico (sin revelar si el email existe).
5. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `login.json` es JSON válido
- [ ] Hay 2 intentos en el array `intentos`
- [ ] Intento correcto: `status: "success"`, `authenticated: true`
- [ ] Intento incorrecto: `status: "error"`, `authenticated: false`
- [ ] El mensaje de error del intento incorrecto es genérico (no dice "contraseña incorrecta" ni "email no existe")
- [ ] El mensaje de error contiene "credenciales" o "inválid"
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La verificación de contraseña usa `bcrypt.checkpw(password, hash)`: retorna `True` si coinciden.
- El mensaje de error debe ser genérico para evitar enumeración de usuarios. No digas si falló el email o la contraseña.
- Un buen mensaje genérico: `"credenciales inválidas"`.
- El login correcto devuelve `authenticated: true` y un user_id.
- El login incorrecto devuelve `authenticated: false` y NO un user_id.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`login.json`:

```json
{
  "intentos": [
    {
      "email": "alice@example.com",
      "password": "password123",
      "status": "success",
      "authenticated": true,
      "user_id": "usr_7f3a2b",
      "message": "login correcto"
    },
    {
      "email": "alice@example.com",
      "password": "wrongpass",
      "status": "error",
      "authenticated": false,
      "user_id": null,
      "message": "credenciales inválidas"
    }
  ]
}
```

Código equivalente:

```python
import bcrypt

def login(email, password, stored_hash):
    # 1. Buscar usuario por email (simulado)
    # 2. Verificar contraseña
    if bcrypt.checkpw(password.encode(), stored_hash.encode()):
        return {
            "status": "success",
            "authenticated": True,
            "user_id": "usr_7f3a2b",
            "message": "login correcto"
        }
    else:
        # Mensaje genérico: no revelar qué falló
        return {
            "status": "error",
            "authenticated": False,
            "user_id": None,
            "message": "credenciales inválidas"
        }
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
