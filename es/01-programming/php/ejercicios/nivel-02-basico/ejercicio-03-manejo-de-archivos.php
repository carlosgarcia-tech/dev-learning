<?php

declare(strict_types=1);

function leerArchivo(string $ruta): string
{
    // TODO: devuelve el contenido; lanza RuntimeException si no existe o no se puede leer.
    throw new Exception("TODO: implementar leerArchivo()");
}

function escribirArchivo(string $ruta, string $contenido): int
{
    // TODO: escribe el contenido y devuelve los bytes escritos.
    throw new Exception("TODO: implementar escribirArchivo()");
}

function leerLineas(string $ruta): array
{
    // TODO: devuelve un array con las líneas sin saltos de línea.
    throw new Exception("TODO: implementar leerLineas()");
}

function listarArchivos(string $dir): array
{
    // TODO: devuelve los nombres de los archivos (no carpetas) de $dir.
    throw new Exception("TODO: implementar listarArchivos()");
}

function crearSiNoExiste(string $ruta): bool
{
    // TODO: crea el archivo vacío si no existe (true); false si ya existía.
    throw new Exception("TODO: implementar crearSiNoExiste()");
}