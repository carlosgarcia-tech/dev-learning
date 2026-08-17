<?php

declare(strict_types=1);

// Lógica de dominio: artículos y comentarios. Cada mutación hace
// leer-modificar-guardar sobre el Almacenamiento compartido.
class Blog
{
    public function __construct(private Almacenamiento $almacenamiento)
    {
    }

    public function crearArticulo(string $titulo, string $contenido, bool $publicado, string $autor): int
    {
        // TODO: valida y normaliza; asigna id = siguienteId(), incrementa el contador
        // y guarda el artículo. Devuelve el id creado.
        throw new Exception("TODO: implementar Blog::crearArticulo()");
    }

    public function listarArticulos(bool $soloPublicados = false): array
    {
        // TODO: devuelve los artículos ordenados por id desc.
        // Con $soloPublicados = true filtra los que NO estén publicados.
        throw new Exception("TODO: implementar Blog::listarArticulos()");
    }

    public function obtenerArticulo(int $id): ?array
    {
        // TODO: devuelve el artículo con ese id o null.
        throw new Exception("TODO: implementar Blog::obtenerArticulo()");
    }

    public function actualizarArticulo(int $id, string $titulo, string $contenido, bool $publicado): bool
    {
        // TODO: valida y actualiza; true si el artículo existía y cambió.
        throw new Exception("TODO: implementar Blog::actualizarArticulo()");
    }

    public function eliminarArticulo(int $id): bool
    {
        // TODO: borra el artículo y TODOS sus comentarios; true si existía.
        throw new Exception("TODO: implementar Blog::eliminarArticulo()");
    }

    public function agregarComentario(int $articuloId, string $autor, string $texto): int
    {
        // TODO: valida el texto; el artículo debe existir y estar publicado;
        // asigna id = siguienteId() y guarda. Devuelve el id del comentario.
        throw new Exception("TODO: implementar Blog::agregarComentario()");
    }

    public function listarComentarios(int $articuloId): array
    {
        // TODO: comentarios del artículo ordenados por id asc.
        throw new Exception("TODO: implementar Blog::listarComentarios()");
    }

    public function contarComentarios(int $articuloId): int
    {
        // TODO: número de comentarios del artículo.
        throw new Exception("TODO: implementar Blog::contarComentarios()");
    }

    public function buscarArticulos(string $texto, bool $soloPublicados = true): array
    {
        // TODO: artículos cuyo título o contenido contenga el texto
        // (comparación en minúsculas), opcionalmente solo publicados.
        throw new Exception("TODO: implementar Blog::buscarArticulos()");
    }
}