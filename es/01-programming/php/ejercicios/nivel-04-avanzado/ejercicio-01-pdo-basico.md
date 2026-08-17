# Ejercicio 01 — PDO básico

- **Nivel:** 4/5
- **Tema:** conexión PDO, `prepare`, `execute`, `fetchAll`, `lastInsertId`
- **Tiempo estimado:** 35 min

## Enunciado

Completa las funciones en `ejercicio-01-pdo-basico.php`:

1. `crearConexion(string $dsn)`: crea un `PDO`, activa `ERRMODE_EXCEPTION` y el modo `FETCH_ASSOC`.
2. `crearTablaUsuarios(PDO $pdo)`: ejecuta `CREATE TABLE IF NOT EXISTS usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, email TEXT NOT NULL UNIQUE)`.
3. `insertarUsuario(PDO $pdo, string $nombre, string $email)`: inserta con **placeholders nombrados** (`:nombre`, `:email`) y devuelve `lastInsertId()`.
4. `listarUsuarios(PDO $pdo)`: devuelve todos los usuarios ordenados por `id`.
5. `contarUsuarios(PDO $pdo)`: devuelve el número de usuarios con `COUNT(*)`.

## Requisitos

- [ ] `crearConexion` devuelve una instancia de `PDO`.
- [ ] `insertarUsuario` devuelve ids incrementales.
- [ ] `listarUsuarios` devuelve los usuarios con `nombre` y `email`.
- [ ] `contarUsuarios` refleja los insertados.
- [ ] Insertar un `email` duplicado lanza `PDOException`.
- [ ] Los tests pasan: `php ejercicio-01-pdo-basico_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 y la extensión `pdo_sqlite` (los tests usan una base SQLite en memoria).

## Pistas

<details>
<summary>Mostrar pistas</summary>

- DSN de prueba: `"sqlite::memory:"`.
- `$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);`.
- `prepare("INSERT ... VALUES (:nombre, :email)")` + `execute(['nombre' => ..., 'email' => ...])`.
- `(int) $pdo->lastInsertId()`; `(int) $fila['total']` al contar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
function crearConexion(string $dsn): PDO
{
    $pdo = new PDO($dsn);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    return $pdo;
}

function crearTablaUsuarios(PDO $pdo): void
{
    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
        )"
    );
}

function insertarUsuario(PDO $pdo, string $nombre, string $email): int
{
    $stmt = $pdo->prepare("INSERT INTO usuarios (nombre, email) VALUES (:nombre, :email)");
    $stmt->execute(['nombre' => $nombre, 'email' => $email]);
    return (int) $pdo->lastInsertId();
}

function listarUsuarios(PDO $pdo): array
{
    return $pdo->query("SELECT * FROM usuarios ORDER BY id")->fetchAll();
}

function contarUsuarios(PDO $pdo): int
{
    return (int) $pdo->query("SELECT COUNT(*) AS total FROM usuarios")->fetch()['total'];
}
````

</details>