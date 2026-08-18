# 04 — PDO y bases de datos

## Objetivos

- [ ] Conectar a una base de datos con PDO (DSN, usuario, clave).
- [ ] Configurar el modo de errores a excepciones.
- [ ] Ejecutar consultas con `query()`, `prepare()` y `execute()`.
- [ ] Obtener resultados con `fetch()`, `fetchAll()` y `fetchObject()`.
- [ ] Usar placeholders **posicionales** (`?`) y **nombrados** (`:nombre`).
- [ ] Trabajar con `lastInsertId()` y `rowCount()`.
- [ ] Usar transacciones con `beginTransaction()`, `commit()` y `rollBack()`.

## Apuntes

### Conexión con PDO

PDO (`PHP Data Objects`) es la capa de acceso a bases de datos de PHP. Funciona con MySQL, PostgreSQL, SQLite, entre otros, cambiando solo el **DSN**.

```php
// SQLite (archivo o memoria)
$dsn = "sqlite:" . __DIR__ . "/tienda.db";
$pdo = new PDO($dsn);

// MySQL
$pdo = new PDO(
    "mysql:host=localhost;dbname=tienda;charset=utf8mb4",
    "usuario",
    "clave"
);
```

Configura el manejo de errores para que lancen excepciones:

```php
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
```

### Consultas sin parámetros

```php
$filas = $pdo->query("SELECT * FROM productos")->fetchAll();
foreach ($filas as $fila) {
    echo $fila["nombre"] . ": " . $fila["precio"] . PHP_EOL;
}
```

### Consultas con parámetros (seguridad)

Nunca interpoles datos del usuario en el SQL: usa **prepared statements**. Esto previene la inyección SQL.

```php
// Placeholder posicional (?)
$stmt = $pdo->prepare("SELECT * FROM productos WHERE precio >= ? AND stock > 0");
$stmt->execute([100]);
$caros = $stmt->fetchAll();

// Placeholder nombrado (:precio)
$stmt = $pdo->prepare("INSERT INTO productos (nombre, precio, stock) VALUES (:nombre, :precio, :stock)");
$stmt->execute([
    "nombre" => "Laptop",
    "precio" => 1200.0,
    "stock" => 5,
]);
$nuevoId = (int) $pdo->lastInsertId();
$afectadas = $stmt->rowCount();
```

### Modos de obtención

- `PDO::FETCH_ASSOC` — array asociativo.
- `PDO::FETCH_NUM` — array numérico.
- `PDO::FETCH_OBJ` — objeto con propiedades.
- `fetch()` — una fila (o `false` si no hay más).
- `fetchAll()` — todas las filas.

```php
$stmt = $pdo->query("SELECT id, nombre FROM productos");
while ($fila = $stmt->fetch()) {
    echo $fila["nombre"] . PHP_EOL;
}

$producto = $pdo->prepare("SELECT * FROM productos WHERE id = ?");
$producto->execute([$id]);
$uno = $producto->fetch();   // ?array
```

### Transacciones

Una transacción agrupa varias operaciones: o se confirman todas (`commit`) o se deshacen todas (`rollBack`). Imprescindible para transferencias, pedidos, etc.

```php
try {
    $pdo->beginTransaction();

    $pdo->prepare("UPDATE cuentas SET saldo = saldo - ? WHERE id = ?")->execute([100, 1]);
    $pdo->prepare("UPDATE cuentas SET saldo = saldo + ? WHERE id = ?")->execute([100, 2]);

    $pdo->commit();
} catch (PDOException $e) {
    $pdo->rollBack();
    throw $e;
}
```

### Consultas con JOIN y agregados

```php
$sql = "SELECT a.id, a.titulo, COUNT(c.id) AS comentarios
        FROM articulos a
        LEFT JOIN comentarios c ON c.articulo_id = a.id
        GROUP BY a.id
        ORDER BY a.id DESC";
$articulos = $pdo->query($sql)->fetchAll();
```

## Ejemplos de código

```php
// Filtros dinámicos con placeholders nombrados
function buscar(PDO $pdo, array $filtros): array
{
    $sql = "SELECT * FROM productos WHERE 1=1";
    $params = [];
    if (!empty($filtros["precio_min"])) {
        $sql .= " AND precio >= :precio_min";
        $params["precio_min"] = $filtros["precio_min"];
    }
    if (!empty($filtros["categoria"])) {
        $sql .= " AND categoria = :categoria";
        $params["categoria"] = $filtros["categoria"];
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — PDO básico y avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Blog con PDO](../ejercicios/nivel-05-experto/)

## Errores comunes

- **Interpolar variables en el SQL** → vulnerabilidad de inyección SQL. Usa siempre `prepare()` + `execute()`.
- **Olvidar `PDO::ATTR_ERRMODE`** → los errores pasan silenciosos y cuesta depurar.
- **Confundir `execute()` con parámetros** → si usas placeholders nombrados, las claves del array deben incluir el `:` o no (según la versión); sé consistente.
- **`fetchAll()` con `FETCH_ASSOC` mezclado con `FETCH_OBJ`** → elige un modo global con `ATTR_DEFAULT_FETCH_MODE`.
- **No hacer `rollBack()` en el `catch`** → la transacción queda abierta y corrompe el estado.

## Recursos

- [PHP.net — PDO](https://www.php.net/manual/es/book.pdo.php)
- [PHP.net — PDO::prepare](https://www.php.net/manual/es/pdo.prepare.php)
- [PHP.net — Transacciones](https://www.php.net/manual/es/pdo.transactions.php)
- [OWASP — SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)