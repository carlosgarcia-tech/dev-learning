<?php

declare(strict_types=1);

function crearEsquemaBlog(PDO $pdo): void
{
    // TODO: crea las tablas articulos y comentarios.
    throw new Exception("TODO: implementar crearEsquemaBlog()");
}

function crearArticulo(PDO $pdo, string $titulo, string $contenido, bool $publicado = false): int
{
    // TODO: inserta y devuelve el id.
    throw new Exception("TODO: implementar crearArticulo()");
}

function listarArticulos(PDO $pdo): array
{
    // TODO: todos ordenados por id desc.
    throw new Exception("TODO: implementar listarArticulos()");
}

function listarPublicados(PDO $pdo): array
{
    // TODO: solo publicado = 1.
    throw new Exception("TODO: implementar listarPublicados()");
}

function obtenerArticulo(PDO $pdo, int $id): ?array
{
    // TODO: el artículo o null.
    throw new Exception("TODO: implementar obtenerArticulo()");
}

function actualizarArticulo(PDO $pdo, int $id, string $titulo, string $contenido): bool
{
    // TODO: actualiza y devuelve true si hubo cambios.
    throw new Exception("TODO: implementar actualizarArticulo()");
}

function eliminarArticulo(PDO $pdo, int $id): bool
{
    // TODO: borra y devuelve true si borró algo.
    throw new Exception("TODO: implementar eliminarArticulo()");
}

function agregarComentario(PDO $pdo, int $articuloId, string $autor, string $texto): int
{
    // TODO: inserta un comentario y devuelve su id.
    throw new Exception("TODO: implementar agregarComentario()");
}

function contarComentarios(PDO $pdo, int $articuloId): int
{
    // TODO: cuenta los comentarios del artículo.
    throw new Exception("TODO: implementar contarComentarios()");
}

function buscarArticulos(PDO $pdo, string $texto): array
{
    // TODO: LIKE sobre titulo o contenido.
    throw new Exception("TODO: implementar buscarArticulos()");
}