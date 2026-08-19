# Ejercicio 02 — Blog con PDO

- **Nivel:** 5/5
- **Tema:** CRUD completo con PDO, `LIKE`, claves foráneas y `LEFT JOIN`
- **Tiempo estimado:** 45 min

## Enunciado

Completa las funciones en `index.php`:

1. `crearEsquemaBlog(PDO $pdo)`: crea `articulos (id, titulo, contenido, publicado, creado_en)` y `comentarios (id, articulo_id, autor, texto, creado_en)`.
2. `crearArticulo(PDO $pdo, string $titulo, string $contenido, bool $publicado = false)`: inserta y devuelve el `lastInsertId()`.
3. `listarArticulos(PDO $pdo)`: todos los artículos ordenados por `id` desc.
4. `listarPublicados(PDO $pdo)`: solo `publicado = 1`.
5. `obtenerArticulo(PDO $pdo, int $id)`: el artículo o `null`.
6. `actualizarArticulo(PDO $pdo, int $id, string $titulo, string $contenido)`: actualiza y devuelve `true` si modificó alguna fila.
7. `eliminarArticulo(PDO $pdo, int $id)`: borra y devuelve `true` si borró alguna fila.
8. `agregarComentario(PDO $pdo, int $articuloId, string $autor, string $texto)`: inserta un comentario y devuelve su id.
9. `contarComentarios(PDO $pdo, int $articuloId)`: número de comentarios del artículo.
10. `buscarArticulos(PDO $pdo, string $texto)`: artículos cuyo título o contenido contenga el texto (con `LIKE`).

## Requisitos

- [ ] El CRUD de artículos funciona con ids incrementales.
- [ ] `listarPublicados` filtra correctamente.
- [ ] `actualizarArticulo` y `eliminarArticulo` devuelven `false` si el id no existe.
- [ ] `agregarComentario` y `contarComentarios` funcionan juntos.
- [ ] `buscarArticulos` encuentra por título o contenido.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 y `pdo_sqlite`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa placeholders nombrados y `rowCount()` para saber si hubo cambios.
- `LIKE '%' || :texto || '%'` o `LIKE :patron` con `$patron = "%$texto%"`.
- `(int) $pdo->lastInsertId()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function crearEsquemaBlog(PDO $pdo): void
{
    $pdo->exec("CREATE TABLE IF NOT EXISTS articulos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        contenido TEXT NOT NULL,
        publicado INTEGER NOT NULL DEFAULT 0,
        creado_en TEXT NOT NULL
    )");
    $pdo->exec("CREATE TABLE IF NOT EXISTS comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        articulo_id INTEGER NOT NULL,
        autor TEXT NOT NULL,
        texto TEXT NOT NULL,
        creado_en TEXT NOT NULL
    )");
}

function crearArticulo(PDO $pdo, string $titulo, string $contenido, bool $publicado = false): int
{
    $stmt = $pdo->prepare(
        "INSERT INTO articulos (titulo, contenido, publicado, creado_en)
         VALUES (:titulo, :contenido, :publicado, :creado_en)"
    );
    $stmt->execute([
        'titulo' => $titulo,
        'contenido' => $contenido,
        'publicado' => $publicado ? 1 : 0,
        'creado_en' => date('Y-m-d H:i:s'),
    ]);
    return (int) $pdo->lastInsertId();
}

function listarArticulos(PDO $pdo): array
{
    return $pdo->query("SELECT * FROM articulos ORDER BY id DESC")->fetchAll();
}

function listarPublicados(PDO $pdo): array
{
    return $pdo->query("SELECT * FROM articulos WHERE publicado = 1 ORDER BY id DESC")->fetchAll();
}

function obtenerArticulo(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare("SELECT * FROM articulos WHERE id = :id");
    $stmt->execute(['id' => $id]);
    $fila = $stmt->fetch();
    return $fila === false ? null : $fila;
}

function actualizarArticulo(PDO $pdo, int $id, string $titulo, string $contenido): bool
{
    $stmt = $pdo->prepare("UPDATE articulos SET titulo = :titulo, contenido = :contenido WHERE id = :id");
    $stmt->execute(['titulo' => $titulo, 'contenido' => $contenido, 'id' => $id]);
    return $stmt->rowCount() > 0;
}

function eliminarArticulo(PDO $pdo, int $id): bool
{
    $stmt = $pdo->prepare("DELETE FROM articulos WHERE id = :id");
    $stmt->execute(['id' => $id]);
    return $stmt->rowCount() > 0;
}

function agregarComentario(PDO $pdo, int $articuloId, string $autor, string $texto): int
{
    $stmt = $pdo->prepare(
        "INSERT INTO comentarios (articulo_id, autor, texto, creado_en)
         VALUES (:articulo_id, :autor, :texto, :creado_en)"
    );
    $stmt->execute([
        'articulo_id' => $articuloId,
        'autor' => $autor,
        'texto' => $texto,
        'creado_en' => date('Y-m-d H:i:s'),
    ]);
    return (int) $pdo->lastInsertId();
}

function contarComentarios(PDO $pdo, int $articuloId): int
{
    $stmt = $pdo->prepare("SELECT COUNT(*) AS total FROM comentarios WHERE articulo_id = :articulo_id");
    $stmt->execute(['articulo_id' => $articuloId]);
    return (int) $stmt->fetch()['total'];
}

function buscarArticulos(PDO $pdo, string $texto): array
{
    $stmt = $pdo->prepare(
        "SELECT * FROM articulos WHERE titulo LIKE :patron OR contenido LIKE :patron ORDER BY id DESC"
    );
    $stmt->execute(['patron' => '%' . $texto . '%']);
    return $stmt->fetchAll();
}
````

</details>