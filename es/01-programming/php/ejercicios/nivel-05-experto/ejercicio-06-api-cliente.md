# Ejercicio 06 — Cliente de API REST

- **Nivel:** 5/5
- **Tema:** consumir una API REST con cURL, parsear JSON y manejar errores HTTP
- **Tiempo estimado:** 45 min

## Enunciado

Completa las funciones en `ejercicio-06-api-cliente.php`:

1. `parsearJson(string $json)`: decodifica el JSON a un array asociativo con `json_decode($json, true)`; si el JSON es inválido (o no es objeto/array) lanza `JsonException` con el motivo.
2. `mensajeErrorHTTP(int $codigo)`: devuelve un mensaje descriptivo del código, p. ej. `"404: No encontrado"`. Debe reconocer al menos 400, 401, 403, 404, 500 y 503 (y un fallback para el resto).
3. `manejarEstadoHTTP(array $respuesta)`: recibe `["codigo" => int, "cuerpo" => string]`; si `codigo >= 400` lanza `RuntimeException` con `mensajeErrorHTTP($codigo)`; en caso contrario devuelve la respuesta tal cual.
4. `transporteCurl(string $url, array $opciones = [])`: hace la petición con cURL (`curl_init`, `curl_setopt`/`curl_setopt_array` y `curl_exec`). Soporta `metodo`, `headers` y `cuerpo` en `$opciones`. Devuelve `["codigo" => int, "cuerpo" => string]`. Si `curl_exec` devuelve `false` lanza `RuntimeException("Error de red: ...")`.
5. `consumirAPI(string $url, array $opciones = [], ?callable $transporte = null)`: orquesta el cliente. Si `$transporte` es `null` usa `transporteCurl`; llama al transporte, comprueba el estado HTTP con `manejarEstadoHTTP` y devuelve el JSON parseado con `parsearJson`.

El parámetro `$transporte` es una *dependencia inyectable*: los tests pasan un transporte falso para no depender de la red, pero la implementación real usa cURL.

## Requisitos

- [ ] `parsearJson` decodifica objetos y arrays, y lanza `JsonException` con JSON inválido.
- [ ] `mensajeErrorHTTP` devuelve mensajes con el código incluido.
- [ ] `manejarEstadoHTTP` lanza `RuntimeException` solo con códigos `>= 400`.
- [ ] `transporteCurl` devuelve el código HTTP y el cuerpo (o lanza error de red).
- [ ] `consumirAPI` devuelve los datos parseados y propaga los errores HTTP/JSON.
- [ ] Los tests pasan: `php ejercicio-06-api-cliente_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior (extensión `curl`). Los tests inyectan un transporte falso, así que no necesitan red.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `json_decode($json, true)` y comprueba `json_last_error() !== JSON_ERROR_NONE`; lanza `JsonException` con `json_last_error_msg()`.
- Para `manejarEstadoHTTP`, guarda un array `[400 => 'Solicitud inválida', ...]` y usa `?? 'Error desconocido'`.
- cURL: `curl_init($url)`, `CURLOPT_RETURNTRANSFER => true`, `CURLOPT_CUSTOMREQUEST` para el método y `CURLOPT_POSTFIELDS` para el cuerpo.
- Alternativa sin cURL: `file_get_contents($url, false, stream_context_create(['http' => [...]))` — menos control sobre errores.
- En `consumirAPI` usa `$transporte ?? 'transporteCurl'` para que un string sea invocable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function parsearJson(string $json): array
{
    $datos = json_decode($json, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new JsonException("JSON inválido: " . json_last_error_msg());
    }
    if (!is_array($datos)) {
        throw new JsonException("Se esperaba un objeto o array JSON");
    }
    return $datos;
}

function mensajeErrorHTTP(int $codigo): string
{
    $mensajes = [
        400 => 'Solicitud inválida',
        401 => 'No autorizado',
        403 => 'Prohibido',
        404 => 'No encontrado',
        500 => 'Error interno del servidor',
        503 => 'Servicio no disponible',
    ];
    $texto = $mensajes[$codigo] ?? 'Error desconocido';
    return $codigo . ': ' . $texto;
}

function manejarEstadoHTTP(array $respuesta): array
{
    $codigo = (int) ($respuesta['codigo'] ?? 200);
    if ($codigo >= 400) {
        throw new RuntimeException(mensajeErrorHTTP($codigo));
    }
    return $respuesta;
}

function transporteCurl(string $url, array $opciones = []): array
{
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 10,
        CURLOPT_CUSTOMREQUEST => $opciones['metodo'] ?? 'GET',
        CURLOPT_HTTPHEADER => $opciones['headers'] ?? [],
    ]);
    if (array_key_exists('cuerpo', $opciones)) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $opciones['cuerpo']);
    }
    $cuerpo = curl_exec($ch);
    if ($cuerpo === false) {
        $error = curl_error($ch);
        curl_close($ch);
        throw new RuntimeException("Error de red: " . $error);
    }
    $codigo = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ['codigo' => $codigo, 'cuerpo' => $cuerpo];
}

function consumirAPI(string $url, array $opciones = [], ?callable $transporte = null): array
{
    $transporte = $transporte ?? 'transporteCurl';
    $respuesta = manejarEstadoHTTP($transporte($url, $opciones));
    return parsearJson($respuesta['cuerpo']);
}
````

</details>