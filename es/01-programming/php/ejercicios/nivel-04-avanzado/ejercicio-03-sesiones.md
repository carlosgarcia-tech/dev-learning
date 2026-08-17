# Ejercicio 03 — Sesiones

- **Nivel:** 4/5
- **Tema:** `$_SESSION`, autenticación por sesión y mensajes *flash*
- **Tiempo estimado:** 30 min

## Enunciado

Completa las funciones en `ejercicio-03-sesiones.php`. Todas reciben la sesión **por referencia** para poder testearlas sin un servidor web (en producción se pasa `$_SESSION` tras `session_start()`):

1. `escribirEnSesion(array &$sesion, string $clave, mixed $valor)`: guarda `$sesion[$clave] = $valor`.
2. `leerDeSesion(array $sesion, string $clave)`: devuelve el valor o `null` si no existe.
3. `iniciarSesionUsuario(array &$sesion, int $usuarioId)`: guarda `usuario_id` y `autenticado => true`.
4. `estaAutenticado(array $sesion)`: devuelve `true` solo si `autenticado` es `true` y hay `usuario_id`.
5. `cerrarSesion(array &$sesion)`: elimina `usuario_id`, `autenticado` y los mensajes flash.
6. `marcarFlash(array &$sesion, string $clave, mixed $valor)` y `consumirFlash(array &$sesion, string $clave)`: un mensaje *flash* se guarda y solo se puede consumir una vez (la segunda lectura devuelve `null`).

## Requisitos

- [ ] `escribirEnSesion` y `leerDeSesion` guardan y recuperan valores.
- [ ] `leerDeSesion` devuelve `null` para claves inexistentes.
- [ ] `estaAutenticado` es `false` antes del login y `true` después.
- [ ] `cerrarSesion` deja la sesión sin datos de usuario.
- [ ] `consumirFlash` devuelve el valor solo la primera vez.
- [ ] Los tests pasan: `php ejercicio-03-sesiones_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior. El mismo código funciona en producción con `$_SESSION`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los parámetros por referencia se marcan con `&`: `function f(array &$sesion): void`.
- `isset($sesion['clave'])` comprueba existencia.
- Para flash: guarda bajo `'flash_' . $clave` y al consumir haz `unset`.
- `unset($sesion['usuario_id'], $sesion['autenticado'])`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function escribirEnSesion(array &$sesion, string $clave, mixed $valor): void
{
    $sesion[$clave] = $valor;
}

function leerDeSesion(array $sesion, string $clave): mixed
{
    return $sesion[$clave] ?? null;
}

function iniciarSesionUsuario(array &$sesion, int $usuarioId): void
{
    $sesion['usuario_id'] = $usuarioId;
    $sesion['autenticado'] = true;
}

function estaAutenticado(array $sesion): bool
{
    return ($sesion['autenticado'] ?? false) === true && isset($sesion['usuario_id']);
}

function cerrarSesion(array &$sesion): void
{
    unset($sesion['usuario_id'], $sesion['autenticado']);
    foreach ($sesion as $clave => $valor) {
        if (str_starts_with((string) $clave, 'flash_')) {
            unset($sesion[$clave]);
        }
    }
}

function marcarFlash(array &$sesion, string $clave, mixed $valor): void
{
    $sesion['flash_' . $clave] = $valor;
}

function consumirFlash(array &$sesion, string $clave): mixed
{
    $valor = $sesion['flash_' . $clave] ?? null;
    unset($sesion['flash_' . $clave]);
    return $valor;
}
````

</details>