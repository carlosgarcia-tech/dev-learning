# Ejercicio 04 — CSRF token

- **Nivel:** 2/5
- **Tema:** Protección CSRF con synchronizer token pattern
- **Tiempo estimado:** 25 min

## Enunciado

CSRF (Cross-Site Request Forgery) engaña al navegador de un usuario autenticado para que envíe una petición al sitio víctima. La defensa clásica es el **CSRF token**: el servidor genera un token aleatorio, lo guarda en la sesión y lo incluye en el formulario. En cada POST se compara.

Tu tarea es completar el flujo de validación de un CSRF token en `csrf.json`.

Escenario:

1. El servidor genera un CSRF token: `csrf_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG`
2. El usuario envía un formulario POST con el token correcto.
3. Un atacante intenta enviar un formulario sin token (o con token incorrecto).

Pasos:

1. Examina el token en `csrf.json`.
2. Completa los 3 escenarios: (a) token correcto, (b) token ausente, (c) token incorrecto.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `csrf.json` es JSON válido
- [ ] `token_esperado` no está vacío
- [ ] Escenario "token_correcto": `valido: true`, `status: "success"`
- [ ] Escenario "token_ausente": `valido: false`, `status: "error"`
- [ ] Escenario "token_incorrecto": `valido: false`, `status: "error"`
- [ ] Los 3 escenarios están en el array `escenarios`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El token esperado se compara con el recibido usando comparación timing-safe (`hmac.compare_digest`).
- Si el token recibido es `None` o está vacío → inválido.
- Si el token recibido no coincide con el esperado → inválido.
- Solo si coinciden exactamente → válido.
- El token debe ser aleatorio y único por sesión, nunca estático.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`csrf.json`:

```json
{
  "token_esperado": "csrf_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG",
  "escenarios": [
    {
      "nombre": "token_correcto",
      "token_recibido": "csrf_vZ8mF3kQ9wP2xN7tR5sL8jB6fH0cA4dG",
      "valido": true,
      "status": "success"
    },
    {
      "nombre": "token_ausente",
      "token_recibido": null,
      "valido": false,
      "status": "error"
    },
    {
      "nombre": "token_incorrecto",
      "token_recibido": "csrf_falso_atacante_123",
      "valido": false,
      "status": "error"
    }
  ]
}
```

Verificación en el servidor:

```python
import hmac

def verify_csrf(token_esperado, token_recibido):
    if not token_recibido:
        return False
    return hmac.compare_digest(token_esperado, token_recibido)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
