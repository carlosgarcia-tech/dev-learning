# Ejercicio 02 — Cookie Set-Cookie

- **Nivel:** 2/5
- **Tema:** Atributos de seguridad de cookies
- **Tiempo estimado:** 25 min

## Enunciado

Una cookie de sesión mal configurada es un riesgo de seguridad. Tu tarea es construir el header `Set-Cookie` correcto para un session ID, incluyendo todos los atributos de seguridad.

El session ID a enviar es: `sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3`

Pasos:

1. Construye el header `Set-Cookie` completo en `cookie.json`.
2. Debe incluir: `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/`, `Max-Age=3600`.
3. Completa los campos del JSON documentando cada atributo.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `cookie.json` es JSON válido
- [ ] `set_cookie` contiene `sid=sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3`
- [ ] `set_cookie` contiene `HttpOnly`
- [ ] `set_cookie` contiene `Secure`
- [ ] `set_cookie` contiene `SameSite=Lax`
- [ ] `set_cookie` contiene `Path=/`
- [ ] `set_cookie` contiene `Max-Age=3600`
- [ ] `atributos` es un array con al menos 5 elementos (uno por atributo)
- [ ] Cada atributo tiene `nombre` y `proposito`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El formato completo de Set-Cookie es: `Nombre=Valor; Atributo1; Atributo2; ...`
- `HttpOnly`: impide acceso vía `document.cookie` (anti XSS).
- `Secure`: solo se envía por HTTPS (anti interceptación).
- `SameSite=Lax`: no se envía en peticiones POST cross-site (anti CSRF).
- `Path=/`: la cookie aplica a todo el dominio.
- `Max-Age=3600`: expira en 1 hora (3600 segundos).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`cookie.json`:

```json
{
  "set_cookie": "sid=sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600",
  "atributos": [
    { "nombre": "HttpOnly", "proposito": "Impide acceso vía JavaScript (document.cookie), previene robo por XSS" },
    { "nombre": "Secure", "proposito": "La cookie solo se envía por HTTPS, previene interceptación en HTTP" },
    { "nombre": "SameSite=Lax", "proposito": "No se envía en peticiones POST cross-site, previene CSRF clásico" },
    { "nombre": "Path=/", "proposito": "La cookie aplica a todas las rutas del dominio" },
    { "nombre": "Max-Age=3600", "proposito": "La cookie expira en 1 hora (3600 segundos)" }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
