<?php

declare(strict_types=1);

// Capa de persistencia: todo el estado vive en un único archivo JSON.
// Cada mutación lee, modifica y vuelve a escribir el archivo completo.
class Almacenamiento
{
    public function __construct(private string $ruta)
    {
    }

    public function ruta(): string
    {
        return $this->ruta;
    }

    public function leerTodo(): array
    {
        // TODO: devuelve el contenido del JSON como array.
        // Si el archivo no existe o está corrupto, devuelve la estructura inicial:
        // ['siguiente_id' => 1, 'usuarios' => [], 'articulos' => [], 'comentarios' => []].
        throw new Exception("TODO: implementar Almacenamiento::leerTodo()");
    }

    public function guardarTodo(array $datos): void
    {
        // TODO: crea el directorio si falta y escribe el JSON con
        // json_encode($datos, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE).
        throw new Exception("TODO: implementar Almacenamiento::guardarTodo()");
    }

    public function leerColeccion(string $clave): array
    {
        // TODO: devuelve $this->leerTodo()[$clave] ?? [].
        throw new Exception("TODO: implementar Almacenamiento::leerColeccion()");
    }

    public function siguienteId(): int
    {
        // TODO: devuelve el siguiente id disponible (campo 'siguiente_id').
        throw new Exception("TODO: implementar Almacenamiento::siguienteId()");
    }

    private function estructuraInicial(): array
    {
        return [
            'siguiente_id' => 1,
            'usuarios' => [],
            'articulos' => [],
            'comentarios' => [],
        ];
    }
}