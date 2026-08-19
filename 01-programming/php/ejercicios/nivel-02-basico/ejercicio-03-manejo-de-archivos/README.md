# Ejercicio 03 — Manejo de archivos

- **Nivel:** 2/5
- **Tema:** `file_get_contents`, `file_put_contents`, `file`, `scandir`, `is_dir`, `mkdir`
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `index.php`:

1. `leerArchivo(string $ruta)`: devuelve el contenido completo del archivo; lanza una `RuntimeException` si no existe.
2. `escribirArchivo(string $ruta, string $contenido)`: escribe el contenido y devuelve la cantidad de bytes escritos.
3. `leerLineas(string $ruta)`: devuelve un array con las líneas del archivo (sin saltos de línea al final).
4. `listarArchivos(string $dir)`: devuelve los **nombres** de los archivos (no carpetas) dentro de `$dir`.
5. `crearSiNoExiste(string $ruta)`: crea el archivo vacío si no existe y devuelve `true`; devuelve `false` si ya existía.

## Requisitos

- [ ] `escribirArchivo` y luego `leerArchivo` devuelven el contenido escrito.
- [ ] `leerLineas` devuelve `["línea1", "línea2"]` para un archivo de dos líneas.
- [ ] `listarArchivos` ignora las subcarpetas.
- [ ] `crearSiNoExiste` crea el archivo la primera vez y devuelve `false` la segunda.
- [ ] `leerArchivo` lanza una excepción para rutas inexistentes.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior. Los tests crean archivos temporales en `sys_get_temp_dir()`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `file_get_contents()` devuelve `false` si falla; comprueba con `is_file()` o `$contenido === false`.
- `file_put_contents()` devuelve el número de bytes.
- `file($ruta, FILE_IGNORE_NEW_LINES)` devuelve líneas sin el `\n`.
- `scandir()` incluye `.` y `..`; filtra con `is_file($dir . '/' . $item)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function leerArchivo(string $ruta): string
{
    if (!is_file($ruta)) {
        throw new RuntimeException("El archivo no existe: {$ruta}");
    }
    $contenido = file_get_contents($ruta);
    if ($contenido === false) {
        throw new RuntimeException("No se pudo leer el archivo: {$ruta}");
    }
    return $contenido;
}

function escribirArchivo(string $ruta, string $contenido): int
{
    return file_put_contents($ruta, $contenido);
}

function leerLineas(string $ruta): array
{
    return file($ruta, FILE_IGNORE_NEW_LINES);
}

function listarArchivos(string $dir): array
{
    $archivos = [];
    foreach (scandir($dir) as $item) {
        if (is_file($dir . '/' . $item)) {
            $archivos[] = $item;
        }
    }
    sort($archivos);
    return $archivos;
}

function crearSiNoExiste(string $ruta): bool
{
    if (file_exists($ruta)) {
        return false;
    }
    file_put_contents($ruta, '');
    return true;
}
````

</details>