<?php

declare(strict_types=1);

function coincideRuta(string $patron, string $uri): ?array
{
    // TODO: compara segmentos; captura los {parametros} en un array.
    throw new Exception("TODO: implementar coincideRuta()");
}

function jsonRespuesta(mixed $datos, int $codigo = 200): array
{
    // TODO: devuelve ['codigo' => $codigo, 'cuerpo' => json_encode($datos)].
    throw new Exception("TODO: implementar jsonRespuesta()");
}

function rutear(string $metodo, string $uri, array $body = []): array
{
    // TODO: rutas /api/usuarios con GET/POST y /api/usuarios/{id} con GET/DELETE.
    throw new Exception("TODO: implementar rutear()");
}