# Ejercicio 04 — Mini proyecto: MVC básico

- **Nivel:** 5/5
- **Tema:** patrón MVC, enrutador, controladores y plantillas
- **Tiempo estimado:** 45 min

## Enunciado

Completa las clases en `ejercicio-04-mini-proyecto-mvc-basico.php`:

1. **`Enrutador`**: registra rutas con `get(string $ruta, callable $controlador)` y `post(...)`; `despachar(string $metodo, string $uri)` recorre las rutas (respetando el método), captura parámetros como `{id}` con `rutaCoincide(string $patron, string $uri)` y llama al controlador con `["id" => ...]`; si ninguna coincide devuelve `["status" => 404, "vista" => "no-encontrada"]`.
2. **`Vista`**: `renderizar(string $plantilla, array $datos = [])` reemplaza los marcadores `{{clave}}` por los valores de `$datos` (usa `str_replace`).
3. Funciones controladoras `inicio()`, `mostrarArticulo(array $params)` y `crearArticulo()` como **closures** registradas en el enrutador, que devuelven arrays `["status" => ..., "vista" => ..., "datos" => ...]`.

## Requisitos

- [ ] `rutaCoincide("/articulo/{id}", "/articulo/7")` devuelve `["id" => "7"]`.
- [ ] `get` y `post` distinguen por método.
- [ ] `despachar` llama al controlador correcto pasando los parámetros.
- [ ] Una ruta sin coincidencia devuelve `status 404`.
- [ ] `Vista::renderizar` reemplaza `{{clave}}` por el dato.
- [ ] Los tests pasan: `php ejercicio-04-mini-proyecto-mvc-basico_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Guarda rutas como `["GET" => [["/ruta", $controlador], ...]]`.
- `explode('/', trim($uri, '/'))` para comparar segmentos y detectar `{...}`.
- `str_replace("{{$clave}}", $valor, $plantilla)` para cada par clave => valor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
class Enrutador
{
    private array $rutas = ['GET' => [], 'POST' => []];

    public function get(string $ruta, callable $controlador): void
    {
        $this->rutas['GET'][] = [$ruta, $controlador];
    }

    public function post(string $ruta, callable $controlador): void
    {
        $this->rutas['POST'][] = [$ruta, $controlador];
    }

    public function rutaCoincide(string $patron, string $uri): ?array
    {
        $segPatron = explode('/', trim($patron, '/'));
        $segUri = explode('/', trim($uri, '/'));
        if (count($segPatron) !== count($segUri)) {
            return null;
        }
        $params = [];
        foreach ($segPatron as $i => $seg) {
            if (str_starts_with($seg, '{')) {
                $params[trim($seg, '{}')] = $segUri[$i];
            } elseif ($seg !== $segUri[$i]) {
                return null;
            }
        }
        return $params;
    }

    public function despachar(string $metodo, string $uri): array
    {
        foreach ($this->rutas[$metodo] ?? [] as [$patron, $controlador]) {
            $params = $this->rutaCoincide($patron, $uri);
            if ($params !== null) {
                return $controlador($params);
            }
        }
        return ['status' => 404, 'vista' => 'no-encontrada'];
    }
}

class Vista
{
    public function renderizar(string $plantilla, array $datos = []): string
    {
        $resultado = $plantilla;
        foreach ($datos as $clave => $valor) {
            $resultado = str_replace('{{' . $clave . '}}', (string) $valor, $resultado);
        }
        return $resultado;
    }
}

function inicio(): array
{
    return ['status' => 200, 'vista' => 'inicio', 'datos' => ['titulo' => 'Bienvenido']];
}

function mostrarArticulo(array $params): array
{
    return ['status' => 200, 'vista' => 'articulo', 'datos' => ['id' => $params['id']]];
}

function crearArticulo(): array
{
    return ['status' => 201, 'vista' => 'creado'];
}
````

</details>