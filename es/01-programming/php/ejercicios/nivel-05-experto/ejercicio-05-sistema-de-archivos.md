# Ejercicio 05 — Sistema de archivos

- **Nivel:** 5/5
- **Tema:** recorrido recursivo de directorios, `glob`, `filesize`, copia de árboles
- **Tiempo estimado:** 40 min

## Enunciado

Completa las funciones en `ejercicio-05-sistema-de-archivos.php`:

1. `tamanoDirectorio(string $dir)`: suma los bytes de **todos** los archivos de forma recursiva.
2. `encontrarPorExtension(string $dir, string $extension)`: devuelve las rutas de los archivos con esa extensión (sin el `.`), recorriendo subcarpetas.
3. `copiarRecursivo(string $origen, string $destino)`: copia un árbol de directorios completo; crea `$destino` si no existe y devuelve `true`.
4. `arbolDeArchivos(string $dir)`: devuelve una estructura anidada: cada entrada es `["nombre" => ..., "tipo" => "dir"|"archivo", "hijos" => [...] (solo en dirs)]`.

## Requisitos

- [ ] `tamanoDirectorio` suma los tamaños de todos los archivos anidados.
- [ ] `encontrarPorExtension` busca en subcarpetas.
- [ ] `copiarRecursivo` replica el árbol y los archivos.
- [ ] `arbolDeArchivos` refleja la jerarquía con tipos correctos.
- [ ] Los tests pasan: `php ejercicio-05-sistema-de-archivos_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior. Los tests crean árboles temporales.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `RecursiveIteratorIterator` + `RecursiveDirectoryIterator` simplifican el recorrido.
- `str_ends_with($ruta, '.' . $extension)` filtra por extensión.
- `mkdir($destino, 0777, true)` y `copy()` para archivos.
- `is_dir()`/`is_file()` distinguen entradas; `scandir()` lista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function tamanoDirectorio(string $dir): int
{
    $total = 0;
    foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS)) as $archivo) {
        if ($archivo->isFile()) {
            $total += $archivo->getSize();
        }
    }
    return $total;
}

function encontrarPorExtension(string $dir, string $extension): array
{
    $resultado = [];
    $extension = ltrim($extension, '.');
    foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($dir, FilesystemIterator::SKIP_DOTS)) as $archivo) {
        if ($archivo->isFile() && str_ends_with($archivo->getFilename(), '.' . $extension)) {
            $resultado[] = $archivo->getPathname();
        }
    }
    sort($resultado);
    return $resultado;
}

function copiarRecursivo(string $origen, string $destino): bool
{
    if (!is_dir($origen)) {
        return false;
    }
    if (!is_dir($destino)) {
        mkdir($destino, 0777, true);
    }
    foreach (scandir($origen) as $entrada) {
        if ($entrada === '.' || $entrada === '..') {
            continue;
        }
        $ruta = $origen . '/' . $entrada;
        if (is_dir($ruta)) {
            copiarRecursivo($ruta, $destino . '/' . $entrada);
        } else {
            copy($ruta, $destino . '/' . $entrada);
        }
    }
    return true;
}

function arbolDeArchivos(string $dir): array
{
    $arbol = [];
    foreach (scandir($dir) as $entrada) {
        if ($entrada === '.' || $entrada === '..') {
            continue;
        }
        $ruta = $dir . '/' . $entrada;
        if (is_dir($ruta)) {
            $arbol[] = [
                'nombre' => $entrada,
                'tipo' => 'dir',
                'hijos' => arbolDeArchivos($ruta),
            ];
        } else {
            $arbol[] = ['nombre' => $entrada, 'tipo' => 'archivo'];
        }
    }
    usort($arbol, fn ($a, $b) => $a['nombre'] <=> $b['nombre']);
    return $arbol;
}
````

</details>