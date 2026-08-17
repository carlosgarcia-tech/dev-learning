<?php

declare(strict_types=1);

// Enrutador web simple: registra rutas GET/POST con patrones {param}
// y despacha a un controlador fn(array $params, array $extra): array.
// El controlador devuelve ['status' => int, 'vista' => string, 'datos' => array].
class Enrutador
{
    private array $rutas = ['GET' => [], 'POST' => []];

    public function get(string $ruta, callable $controlador): void
    {
        // TODO: registra la ruta GET.
        throw new Exception("TODO: implementar Enrutador::get()");
    }

    public function post(string $ruta, callable $controlador): void
    {
        // TODO: registra la ruta POST.
        throw new Exception("TODO: implementar Enrutador::post()");
    }

    public function despachar(string $metodo, string $uri, array $extra = []): array
    {
        // TODO: recorre las rutas del método, captura los parámetros {id}
        // y llama al controlador. Si ninguna coincide: ['status' => 404, ...].
        throw new Exception("TODO: implementar Enrutador::despachar()");
    }

    private function coincide(string $patron, string $uri): ?array
    {
        // TODO: compara segmento a segmento; captura {parametros};
        // null si no coincide (número de segmentos o estáticos distintos).
        throw new Exception("TODO: implementar Enrutador::coincide()");
    }
}