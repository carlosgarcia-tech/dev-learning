# Ejercicio 06 — Session fixation

- **Nivel:** 5/5
- **Tema:** Prevención de session fixation
- **Tiempo estimado:** 40 min

## Enunciado

El **session fixation** es un ataque donde el atacante fija un session ID conocido en el navegador de la víctima antes de que esta se loguee. Si el servidor no rota el session ID tras el login, el atacante puede usar ese ID para acceder a la sesión de la víctima.

Tu tarea es completar el escenario de ataque y la defensa en `session_fixation.json`.

Escenario de ataque:

1. Atacante obtiene un session ID válido: `sess_ATTACKER_KNOWN_ID`.
2. Atacante engaña a la víctima para que use ese session ID (URL con `?sid=` o cookie inyectada).
3. Víctima se loguea con el session ID fijado.
4. Si el servidor NO rota el ID → el atacante usa el mismo ID → accede a la sesión de la víctima.

Defensa:

1. Tras un login exitoso, el servidor **siempre genera un nuevo session ID**.
2. El session ID antiguo se invalida.
3. El nuevo session ID se entrega en una cookie nueva.

Pasos:

1. Completa `session_fixation.json` con el escenario de ataque y la defensa.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `session_fixation.json` es JSON válido
- [ ] `ataque.session_id_fijado` es `"sess_ATTACKER_KNOWN_ID"`
- [ ] `ataque.sin_rotacion.vulnerable` es `true`
- [ ] `ataque.sin_rotacion.atacante_accede` es `true`
- [ ] `ataque.sin_rotacion.descripcion` no está vacía
- [ ] `defensa.con_rotacion.vulnerable` es `false`
- [ ] `defensa.con_rotacion.session_id_rotado` es `true`
- [ ] `defensa.con_rotacion.atacante_accede` es `false`
- [ ] `defensa.con_rotacion.descripcion` no está vacía
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sin rotación: el session ID pre-login (`sess_ATTACKER_KNOWN_ID`) se mantiene tras el login. El atacante lo conoce y puede usarlo.
- Con rotación: tras el login, el servidor genera un nuevo session ID (`sess_NEW_RANDOM_ID`) que el atacante no conoce.
- La rotación debe ocurrir SIEMPRE tras un login exitoso, sin excepciones.
- También es buena práctica rotar el session ID periódicamente o tras cambios de privilegio.
- Otras defensas: aceptar session ID solo vía cookie (no por URL), regenerar ID en cada petición.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`session_fixation.json`:

```json
{
  "ataque": {
    "session_id_fijado": "sess_ATTACKER_KNOWN_ID",
    "sin_rotacion": {
      "vulnerable": true,
      "atacante_accede": true,
      "descripcion": "El servidor no rota el session ID tras el login. El atacante conoce el ID fijado y puede usarlo para acceder a la sesión de la víctima."
    }
  },
  "defensa": {
    "con_rotacion": {
      "vulnerable": false,
      "session_id_rotado": true,
      "nuevo_session_id": "sess_NEW_RANDOM_ID_abc123",
      "atacante_accede": false,
      "descripcion": "Tras el login, el servidor genera un nuevo session ID aleatorio y invalida el anterior. El atacante no conoce el nuevo ID y no puede acceder."
    }
  }
}
```

Código equivalente:

```python
def login_success(user_id, old_session_id):
    # DEFENSA: rotar el session ID tras login
    destroy_session(old_session_id)
    new_sid = create_session(user_id)
    return new_sid  # Set-Cookie con el nuevo ID
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
