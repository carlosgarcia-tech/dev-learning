<?php

declare(strict_types=1);

function agregarTarea(array $tareas, string $descripcion): array
{
    // TODO: devuelve la lista con la tarea nueva (id = max + 1).
    throw new Exception("TODO: implementar agregarTarea()");
}

function completarTarea(array $tareas, int $id): array
{
    // TODO: marca completada=true la tarea con ese id.
    throw new Exception("TODO: implementar completarTarea()");
}

function listarTareas(array $tareas): array
{
    // TODO: devuelve las tareas.
    throw new Exception("TODO: implementar listarTareas()");
}

function persistirTareas(string $ruta, array $tareas): void
{
    // TODO: guarda como JSON legible.
    throw new Exception("TODO: implementar persistirTareas()");
}

function cargarTareas(string $ruta): array
{
    // TODO: lee el JSON o devuelve [].
    throw new Exception("TODO: implementar cargarTareas()");
}