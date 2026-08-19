# Ejercicio 04 — API REST mínima

- **Nivel:** 4/5
- **Tema:** enrutado por método y URI, códigos HTTP, JSON
- **Tiempo estimado:** 40 min

## Enunciado

Completa las funciones en `index.php`:

1. `coincideRuta(string $patron, string $uri)`: el patrón `"/usuarios/{id}"` coincide con `"/usuarios/5"` y devuelve `["id" => "5"]`; devuelve `null` si no coincide (segmentos estáticos deben ser iguales y el número de segmentos igual).
2. `jsonRespuesta(mixed $datos, int $codigo = 200)`: devuelve `["codigo" => $codigo, "cuerpo" => json_encode($datos)]`.
3. `rutear(string $metodo, string $uri, array $body = [])`: enruta bajo `/api`:
   - `GET /api/usuarios` → `200` con `["usuarios" => [...]]` (usa una lista interna fija).
   - `POST /api/usuarios` → `201` con el usuario creado; si falta `nombre` o `email` → `400` con `["error" => "..."]`.
   - `GET /api/usuarios/{id}` → `200` con el usuario o `404`.
   - `DELETE /api/usuarios/{id}` → `204` sin cuerpo o `404`.
   - Cualquier otra ruta `/api` → `404`; ruta que no empiece por `/api` → `404`.
   - Devuelve `["codigo" => ..., "cuerpo" => ...]` (cuerpo como JSON string o `""` para 204).

## Requisitos

- [ ] `coincideRuta` captura parámetros y rechaza URIs distintas.
- [ ] `jsonRespuesta` devuelve el JSON correcto con el código.
- [ ] `rutear` responde `200`, `201`, `204`, `400` y `404` según el caso.
- [ ] `POST` sin `nombre` devuelve `400` con mensaje de error.
- [ ] `GET /api/usuarios/99` devuelve `404`.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Divide con `explode('/', trim($uri, '/'))` y compara segmento a segmento.
- Detecta parámetros con `str_starts_with($segmento, '{')`.
- Mantén una lista interna: `$usuarios = [['id'=>1,'nombre'=>'Ana','email'=>'ana@mail.com'], ...]`.
- `json_encode($datos)` y para 204 usa `"cuerpo" => ""`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function coincideRuta(string $patron, string $uri): ?array
{
    $segPatron = explode('/', trim($patron, '/'));
    $segUri = explode('/', trim($uri, '/'));
    if (count($segPatron) !== count($segUri)) {
        return null;
    }
    $params = [];
    foreach ($segPatron as $i => $seg) {
        if (str_starts_with($seg, '{')) {
            $clave = trim($seg, '{}');
            $params[$clave] = $segUri[$i];
        } elseif ($seg !== $segUri[$i]) {
            return null;
        }
    }
    return $params;
}

function jsonRespuesta(mixed $datos, int $codigo = 200): array
{
    return ['codigo' => $codigo, 'cuerpo' => json_encode($datos)];
}

function rutear(string $metodo, string $uri, array $body = []): array
{
    if (!str_starts_with($uri, '/api')) {
        return jsonRespuesta(['error' => 'Ruta no encontrada'], 404);
    }

    $usuarios = [
        ['id' => 1, 'nombre' => 'Ana', 'email' => 'ana@mail.com'],
        ['id' => 2, 'nombre' => 'Pablo', 'email' => 'pablo@mail.com'],
    ];

    if ($metodo === 'GET' && $uri === '/api/usuarios') {
        return jsonRespuesta(['usuarios' => $usuarios]);
    }

    if ($metodo === 'POST' && $uri === '/api/usuarios') {
        if (empty($body['nombre']) || empty($body['email'])) {
            return jsonRespuesta(['error' => 'nombre y email son obligatorios'], 400);
        }
        $nuevo = ['id' => count($usuarios) + 1, 'nombre' => $body['nombre'], 'email' => $body['email']];
        return jsonRespuesta($nuevo, 201);
    }

    $params = coincideRuta('/api/usuarios/{id}', $uri);
    if ($params !== null) {
        $id = (int) $params['id'];
        $usuario = null;
        foreach ($usuarios as $u) {
            if ($u['id'] === $id) {
                $usuario = $u;
                break;
            }
        }
        if ($metodo === 'GET') {
            return $usuario !== null
                ? jsonRespuesta($usuario)
                : jsonRespuesta(['error' => 'Usuario no encontrado'], 404);
        }
        if ($metodo === 'DELETE') {
            return $usuario !== null
                ? ['codigo' => 204, 'cuerpo' => '']
                : jsonRespuesta(['error' => 'Usuario no encontrado'], 404);
        }
    }

    return jsonRespuesta(['error' => 'Ruta no encontrada'], 404);
}
````

</details>