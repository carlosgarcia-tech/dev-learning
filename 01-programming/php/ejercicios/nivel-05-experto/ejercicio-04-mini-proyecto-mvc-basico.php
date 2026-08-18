<?php

declare(strict_types=1);

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

    public function rutaCoincide(string $patron, string $uri): ?array
    {
        // TODO: captura los {parametros}; null si no coincide.
        throw new Exception("TODO: implementar Enrutador::rutaCoincide()");
    }

    public function despachar(string $metodo, string $uri): array
    {
        // TODO: llama al controlador correcto o devuelve 404.
        throw new Exception("TODO: implementar Enrutador::despachar()");
    }
}

class Vista
{
    public function renderizar(string $plantilla, array $datos = []): string
    {
        // TODO: reemplaza {{clave}} por el valor.
        throw new Exception("TODO: implementar Vista::renderizar()");
    }
}

function inicio(): array
{
    // TODO: ['status'=>200, 'vista'=>'inicio', 'datos'=>['titulo'=>'Bienvenido']].
    throw new Exception("TODO: implementar inicio()");
}

function mostrarArticulo(array $params): array
{
    // TODO: ['status'=>200, 'vista'=>'articulo', 'datos'=>['id'=>$params['id']]].
    throw new Exception("TODO: implementar mostrarArticulo()");
}

function crearArticulo(): array
{
    // TODO: ['status'=>201, 'vista'=>'creado'].
    throw new Exception("TODO: implementar crearArticulo()");
}