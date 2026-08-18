<?php

declare(strict_types=1);

function parsearJson(string $json): array
{
    // TODO: decodifica con json_decode($json, true) y lanza JsonException si es inválido.
    throw new Exception("TODO: implementar parsearJson()");
}

function mensajeErrorHTTP(int $codigo): string
{
    // TODO: mensaje descriptivo con el código (400, 401, 403, 404, 500, 503, ...).
    throw new Exception("TODO: implementar mensajeErrorHTTP()");
}

function manejarEstadoHTTP(array $respuesta): array
{
    // TODO: lanza RuntimeException si codigo >= 400; si no, devuelve la respuesta.
    throw new Exception("TODO: implementar manejarEstadoHTTP()");
}

function transporteCurl(string $url, array $opciones = []): array
{
    // TODO: petición con cURL y devuelve ['codigo' => int, 'cuerpo' => string].
    throw new Exception("TODO: implementar transporteCurl()");
}

function consumirAPI(string $url, array $opciones = [], ?callable $transporte = null): array
{
    // TODO: transporte (por defecto transporteCurl) + estado HTTP + parsear JSON.
    throw new Exception("TODO: implementar consumirAPI()");
}