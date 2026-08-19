# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** aplicación CLI, persistencia JSON, CRUD de tareas
- **Tiempo estimado:** 40 min

## Enunciado

Completa las funciones en `index.php`:

1. `agregarTarea(array $tareas, string $descripcion)`: devuelve la lista con una tarea nueva `["id" => <siguiente>, "descripcion" => ..., "completada" => false]` (el id es el máximo existente + 1).
2. `completarTarea(array $tareas, int $id)`: devuelve la lista con la tarea del id marcada `completada => true`; si no existe, la devuelve igual.
3. `listarTareas(array $tareas)`: devuelve las tareas tal cual.
4. `persistirTareas(string $ruta, array $tareas)`: guarda la lista como JSON con `JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE`.
5. `cargarTareas(string $ruta)`: lee el JSON y devuelve el array; si el archivo no existe devuelve `[]`.

## Requisitos

- [ ] `agregarTarea` asigna ids incrementales y no muta la lista original.
- [ ] `completarTarea` marca solo la tarea indicada.
- [ ] `persistirTareas` + `cargarTareas` conservan las tareas en disco.
- [ ] `cargarTareas` de un archivo inexistente devuelve `[]`.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `max(array_column($tareas, 'id'))` o recorre con `foreach` para el siguiente id.
- Para no mutar, copia con `$nuevas = $tareas;`.
- `json_encode($tareas, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)`.
- `file_get_contents` + `json_decode($contenido, true)`; si no existe, `[]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function agregarTarea(array $tareas, string $descripcion): array
{
    $siguiente = 1;
    foreach ($tareas as $tarea) {
        if ($tarea['id'] >= $siguiente) {
            $siguiente = $tarea['id'] + 1;
        }
    }
    $nuevas = $tareas;
    $nuevas[] = [
        'id' => $siguiente,
        'descripcion' => $descripcion,
        'completada' => false,
    ];
    return $nuevas;
}

function completarTarea(array $tareas, int $id): array
{
    foreach ($tareas as $i => $tarea) {
        if ($tarea['id'] === $id) {
            $tareas[$i]['completada'] = true;
            break;
        }
    }
    return $tareas;
}

function listarTareas(array $tareas): array
{
    return $tareas;
}

function persistirTareas(string $ruta, array $tareas): void
{
    file_put_contents($ruta, json_encode($tareas, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
}

function cargarTareas(string $ruta): array
{
    if (!is_file($ruta)) {
        return [];
    }
    $contenido = file_get_contents($ruta);
    if ($contenido === false) {
        return [];
    }
    $datos = json_decode($contenido, true);
    return is_array($datos) ? $datos : [];
}
````

</details>