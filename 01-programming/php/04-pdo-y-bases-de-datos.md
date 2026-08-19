# 04 — PDO y bases de datos

## Objetivos

- [ ] Explicar qué es PDO y compararlo con la extensión `mysqli`.
- [ ] Conectar a SQLite, MySQL y PostgreSQL cambiando solo el DSN.
- [ ] Configurar atributos: `ERRMODE_EXCEPTION` y `ATTR_DEFAULT_FETCH_MODE`.
- [ ] Ejecutar consultas sin parámetros con `query()` y `exec()`.
- [ ] Usar prepared statements con `prepare()` y `execute()`.
- [ ] Distinguir placeholders posicionales (`?`) y nombrados (`:nombre`).
- [ ] Obtener filas con `fetch()`, `fetchAll()`, `fetchColumn()` y `fetchObject()`.
- [ ] Aplicar los modos de obtención `FETCH_ASSOC`, `FETCH_NUM` y `FETCH_OBJ`.
- [ ] Entender qué es la inyección SQL y por qué los prepared statements la previenen.
- [ ] Agrupar operaciones con `beginTransaction()`, `commit()` y `rollBack()`.
- [ ] Usar `lastInsertId()` y `rowCount()`.
- [ ] Manejar errores con `PDOException` y `try/catch`.
- [ ] Conectar a una base SQLite en memoria (`:memory:`) para pruebas.
- [ ] Implementar un repositorio simple con PDO y un mini-CRUD.

## Apuntes

### ¿Qué es PDO?

**PDO** (*PHP Data Objects*) es una capa de abstracción de acceso a bases de datos incluida en PHP. Con el mismo código (cambiando únicamente el **DSN**) puedes trabajar con MySQL, PostgreSQL, SQLite, Oracle, SQL Server, etc.

```php
<?php
declare(strict_types=1);

// El mismo objeto PDO puede apuntar a motores distintos
$pdo = new PDO("sqlite:tienda.db");                       // SQLite
$pdo = new PDO("mysql:host=localhost;dbname=tienda", "u", "p"); // MySQL
$pdo = new PDO("pgsql:host=localhost;dbname=tienda", "u", "p"); // PostgreSQL
```

#### PDO vs `mysqli`

Existen dos extensiones para bases de datos en PHP. Sus diferencias principales:

| Criterio | PDO | `mysqli` |
| --- | --- | --- |
| Motores soportados | 12+ (MySQL, PostgreSQL, SQLite, Oracle, SQL Server...) | Solo MySQL/MariaDB |
| API orientada a objetos | Sí | Sí y también procedural |
| Prepared statements | Sí, uniformes en todos los motores | Sí, pero sintaxis propia |
| Transacciones | `beginTransaction()` / `commit()` / `rollBack()` | `begin_transaction()` (orientado a objetos) |
| Nombres de métodos | Constantes y métodos uniformes | Varían según el motor |
| Migrar de motor | Solo cambia el DSN | Reescritura casi total |
| Actualización | Mantenida activamente | Mantenida, pero limitada a MySQL |

**Conclusión:** PDO es la opción recomendada en proyectos nuevos por su portabilidad, su API limpia y porque desacopla el código del motor concreto. Esta guía usa PDO en todos los ejemplos.

### Conexión con PDO

La conexión se crea con `new PDO()` y el **DSN** (*Data Source Name*), que describe dónde y cómo conectar. Las partes típicas del DSN:

- `sqlite:` — ruta al archivo de base de datos, o `:memory:` para bases en RAM.
- `mysql:` — `host`, `port`, `dbname` y `charset`.
- `pgsql:` — `host`, `port`, `dbname` y `user`/`password` (o vía argumentos).

```php
<?php
declare(strict_types=1);

// SQLite: archivo en el directorio del script
$pdo = new PDO("sqlite:" . __DIR__ . "/tienda.db");

// SQLite: en memoria (se borra al cerrar la conexión) - ideal para tests
$pdo = new PDO("sqlite::memory:");

// MySQL con charset utf8mb4
$pdo = new PDO(
    "mysql:host=localhost;port=3306;dbname=tienda;charset=utf8mb4",
    "usuario",
    "clave",
);

// PostgreSQL
$pdo = new PDO(
    "pgsql:host=localhost;port=5432;dbname=tienda",
    "usuario",
    "clave",
);
```

El `charset=utf8mb4` en MySQL es **importante**: sin él, los emojis y caracteres multibyte se corrompen.

#### Opciones de conexión

El cuarto argumento de `new PDO()` es un array de opciones que se aplican en la conexión:

```php
<?php
declare(strict_types=1);

$pdo = new PDO("sqlite::memory:", null, null, [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
]);
```

También puedes configurarlas después con `setAttribute()`:

```php
<?php
declare(strict_types=1);

$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
```

Las tres opciones más importantes:

- `PDO::ATTR_ERRMODE` → `PDO::ERRMODE_EXCEPTION` hace que cualquier error lance una `PDOException`. Sin ella, los errores pasan en silencio y se vuelven casi imposibles de depurar.
- `PDO::ATTR_DEFAULT_FETCH_MODE` → modo de obtención por defecto (ASSOC, NUM, OBJ...).
- `PDO::ATTR_EMULATE_PREPARES` → en MySQL, `false` fuerza prepared statements reales en el servidor (más seguro y más rápido en consultas repetidas).

#### Modos de error de PDO

| Constante | Comportamiento |
| --- | --- |
| `PDO::ERRMODE_SILENT` | No hace nada; debes revisar `errorCode()`/`errorInfo()` (por defecto) |
| `PDO::ERRMODE_WARNING` | Emite un `E_WARNING` y continúa |
| `PDO::ERRMODE_EXCEPTION` | Lanza `PDOException` y detiene el flujo hasta que la capturas |

Siempre se usa `ERRMODE_EXCEPTION` en aplicaciones reales y en esta guía.

### Consultas sin parámetros

#### `query()`

`query()` ejecuta una consulta SQL y devuelve un objeto `PDOStatement` (que es iterable):

```php
<?php
declare(strict_types=1);

$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$stmt = $pdo->query("SELECT id, nombre FROM productos");
foreach ($stmt as $fila) {
    echo $fila["nombre"] . PHP_EOL;
}
```

Al ser `PDOStatement` iterable, puedes recorrerlo directamente en un `foreach` sin llamar a `fetch()`. Si la consulta falla, con `ERRMODE_EXCEPTION` se lanza `PDOException`.

#### `exec()`

`exec()` ejecuta una consulta y devuelve el **número de filas afectadas**. Se usa para INSERT, UPDATE, DELETE o DDL (CREATE TABLE) cuando **no hay parámetros**:

```php
<?php
declare(strict_types=1);

$pdo->exec(
    "CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        precio REAL NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0
    )"
);

$afectadas = $pdo->exec(
    "INSERT INTO productos (nombre, precio, stock) VALUES ('Laptop', 1200.00, 5)"
);
echo $afectadas; // 1
```

`exec()` nunca debe usarse con datos de entrada del usuario (no hay placeholders).

### Prepared statements

Un **prepared statement** envía a la base de datos la consulta con placeholders y, por separado, los valores. El motor prepara el plan de ejecución una vez y lo reutiliza, y los datos jamás se interpretan como SQL.

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("INSERT INTO productos (nombre, precio, stock) VALUES (?, ?, ?)");
$stmt->execute(["Teclado", 45.90, 20]);
```

#### Placeholders posicionales (`?`)

Los `?` se rellenan en orden con un array **indexado**:

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("SELECT * FROM productos WHERE precio >= ? AND stock > ?");
$stmt->execute([100, 0]);
$productos = $stmt->fetchAll();
```

#### Placeholders nombrados (`:nombre`)

Los `:nombre` se rellenan con un array **asociativo**. La clave puede escribirse con o sin el `:` en la mayoría de versiones, pero por claridad se suele omitir:

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare(
    "INSERT INTO productos (nombre, precio, stock)
     VALUES (:nombre, :precio, :stock)"
);
$stmt->execute([
    "nombre" => "Monitor",
    "precio" => 250.00,
    "stock"  => 10,
]);
```

Un placeholder nombrado puede usarse **varias veces** en la misma consulta, pero no puedes mezclar `?` y `:nombre` en la misma sentencia.

#### `bindValue()` y `bindParam()`

Además de `execute([...])` existe el bind explícito:

- `bindValue()` fija **el valor** en ese momento.
- `bindParam()` enlaza una **referencia** a la variable: si cambia después del bind, el nuevo valor se usa en la ejecución.

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("SELECT * FROM productos WHERE stock >= ?");
$minimo = 5;
$stmt->bindValue(1, $minimo, PDO::PARAM_INT);
$stmt->execute();

$minimo = 50; // no afecta a bindValue; sí afectaría a bindParam
$rows = $stmt->fetchAll();
```

En la práctica, `execute([...])` con array es más legible y suficiente en casi todos los casos.

### Obtención de resultados

#### `fetch()`

Devuelve **una fila** (o `false` cuando no quedan más). Se usa con `while`:

```php
<?php
declare(strict_types=1);

$stmt = $pdo->query("SELECT id, nombre, precio FROM productos");
while ($fila = $stmt->fetch()) {
    echo $fila["nombre"] . " -> " . $fila["precio"] . PHP_EOL;
}
```

Para una sola fila esperada (por ejemplo, buscar por clave primaria):

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("SELECT * FROM productos WHERE id = ?");
$stmt->execute([$id]);
$producto = $stmt->fetch();   // array|false
if ($producto === false) {
    echo "No existe el producto $id" . PHP_EOL;
} else {
    echo $producto["nombre"] . PHP_EOL;
}
```

#### Modos de obtención

`fetch()` y `fetchAll()` aceptan una constante como segundo argumento (o usan el modo por defecto):

| Modo | Resultado |
| --- | --- |
| `PDO::FETCH_ASSOC` | Array asociativo: `$fila["nombre"]` |
| `PDO::FETCH_NUM` | Array numérico: `$fila[0]` |
| `PDO::FETCH_OBJ` | Objeto: `$fila->nombre` |
| `PDO::FETCH_BOTH` | Ambas claves (por defecto) |

```php
<?php
declare(strict_types=1);

$stmt = $pdo->query("SELECT id, nombre FROM productos");

while ($fila = $stmt->fetch(PDO::FETCH_NUM)) {
    echo $fila[0] . " " . $fila[1] . PHP_EOL;
}

$stmt = $pdo->query("SELECT id, nombre FROM productos");
$objetos = $stmt->fetchAll(PDO::FETCH_OBJ);
foreach ($objetos as $obj) {
    echo $obj->id . " " . $obj->nombre . PHP_EOL;
}
```

#### `fetchAll()`

Devuelve **todas** las filas en un array. Modos especialmente útiles:

```php
<?php
declare(strict_types=1);

$todas = $pdo->query("SELECT * FROM productos")->fetchAll();              // matriz
$nombres = $pdo->query("SELECT nombre FROM productos")->fetchAll(PDO::FETCH_COLUMN); // lista plana

// Agrupa por la primera columna (útil para claves primarias)
$porId = $pdo->query("SELECT id, nombre, precio FROM productos")
             ->fetchAll(PDO::FETCH_UNIQUE | PDO::FETCH_ASSOC);

// Mapa clave => valor
$mapa = $pdo->query("SELECT id, nombre FROM productos")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
```

`FETCH_KEY_PAIR` requiere exactamente dos columnas y devuelve `[valor_col1 => valor_col2]`.

#### `fetchColumn()`

Devuelve el valor de **una sola columna** de la siguiente fila (indexada por posición, 0 = primera):

```php
<?php
declare(strict_types=1);

$total = $pdo->query("SELECT COUNT(*) FROM productos")->fetchColumn();
echo "Hay $total productos" . PHP_EOL;

$primerNombre = $pdo->query("SELECT nombre FROM productos ORDER BY id LIMIT 1")->fetchColumn();
echo $primerNombre . PHP_EOL;
```

Si no quedan filas, devuelve `false`. `fetchColumn(1)` devolvería la segunda columna.

#### `fetchObject()`

Devuelve cada fila como **objeto**, ya sea de una clase genérica (`stdClass`) o de una clase específica (útil para mapear a modelos):

```php
<?php
declare(strict_types=1);

class Producto
{
    public int $id;
    public string $nombre;
    public float $precio;
}

$stmt = $pdo->prepare("SELECT id, nombre, precio FROM productos WHERE id = ?");
$stmt->execute([1]);
$producto = $stmt->fetchObject(Producto::class);

echo $producto->nombre . " cuesta " . $producto->precio . PHP_EOL;
```

`fetchObject(Clase::class)` asigna las columnas a las propiedades del objeto antes de llamar al constructor (o puedes pasar argumentos del constructor como tercer parámetro). Es la base de los mapeadores objeto-relacional.

### Inyección SQL

La **inyección SQL** ocurre cuando concatenas datos del usuario directamente dentro de una consulta SQL. El usuario puede "romper" la cadena y ejecutar código SQL propio.

#### Ejemplo vulnerable

```php
<?php
declare(strict_types=1);

// VULNERABLE: nunca hagas esto
$nombre = $_GET["nombre"] ?? "";
$sql = "SELECT * FROM usuarios WHERE nombre = '$nombre'";
$stmt = $pdo->query($sql);
```

Si `$_GET["nombre"]` vale `' OR '1'='1`, la consulta resultante es:

```sql
SELECT * FROM usuarios WHERE nombre = '' OR '1'='1
```

`'1'='1'` siempre es verdadero, así que la consulta devuelve **todas** las filas. Con valores como `'; DROP TABLE usuarios; --` un atacante puede borrar tablas enteras. Las comillas, el punto y coma y los comentarios (`--`) son las armas típicas.

#### Ejemplo seguro con prepared statements

```php
<?php
declare(strict_types=1);

// SEGURO: los datos van por un canal separado, nunca se interpretan como SQL
$stmt = $pdo->prepare("SELECT * FROM usuarios WHERE nombre = ?");
$stmt->execute([$_GET["nombre"] ?? ""]);
$usuarios = $stmt->fetchAll();
```

**Por qué lo previene:** el motor recibe primero la plantilla de la consulta y compila su plan de ejecución. Después llegan los valores como **datos**, no como código. Una comilla en el valor es un dato literal, no un delimitador de la sentencia. Además, `bindValue` con `PDO::PARAM_*` fuerza el tipo y neutraliza valores como `1=1`.

Regla de oro: **toda entrada que forme parte del SQL va como placeholder**. Jamás se concatenan valores con `"..." . $variable . "..."`.

### Transacciones

Una **transacción** agrupa varias operaciones en una unidad atómica: o se confirman todas (`commit()`) o se deshacen todas (`rollBack()`). Si falla una, ninguna queda aplicada. Es imprescindible cuando la consistencia depende de varias escrituras: transferencias, pedidos, reservas...

```php
<?php
declare(strict_types=1);

try {
    $pdo->beginTransaction();

    $debitar = $pdo->prepare("UPDATE cuentas SET saldo = saldo - ? WHERE id = ?");
    $acreditar = $pdo->prepare("UPDATE cuentas SET saldo = saldo + ? WHERE id = ?");

    $debitar->execute([100.0, 1]);
    $acreditar->execute([100.0, 2]);

    // Si cualquiera de las dos falla, se lanza PDOException y se deshace todo
    $pdo->commit();
} catch (PDOException $e) {
    $pdo->rollBack();
    throw $e;
}
```

#### Cuándo usarlas

- **Siempre** que una operación escriba en dos o más tablas y la consistencia importe.
- En operaciones que **leen y escriben** con lógica entre medias (evitar lecturas inconsistentes).
- NUNCA para una sola consulta simple (es pura sobrecarga).

Detalles importantes:

- Mientras hay una transacción abierta, otras conexiones no ven los cambios (según el aislamiento del motor).
- SQLite soporta transacciones, pero la escritura es **serializada**: dos conexiones que escriben a la vez pueden lanzar `SQLSTATE[HY000]: General error: 5 database is locked`.
- En MySQL/PostgreSQL, consultas DDL (`CREATE TABLE`, `ALTER TABLE`) suelen hacer commit implícito.

#### `inTransaction()`

Puedes comprobar si hay una transacción activa:

```php
<?php
declare(strict_types=1);

if ($pdo->inTransaction()) {
    echo "Hay una transacción abierta" . PHP_EOL;
}
```

### `lastInsertId()` y `rowCount()`

#### `lastInsertId()`

Devuelve el ID generado por el último INSERT en columnas `AUTO_INCREMENT`/`AUTOINCREMENT`:

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("INSERT INTO productos (nombre, precio, stock) VALUES (?, ?, ?)");
$stmt->execute(["Ratón", 19.99, 50]);
$nuevoId = (int) $pdo->lastInsertId();
echo "Nuevo producto con id $nuevoId" . PHP_EOL;
```

**Cuidado:** `lastInsertId()` es de **conexión**, no global. Dos conexiones distintas tienen contadores independientes. En PostgreSQL con `SERIAL`/`IDENTITY` puedes pasar la secuencia como argumento: `$pdo->lastInsertId('productos_id_seq')`.

#### `rowCount()`

Devuelve el número de filas afectadas por la última sentencia INSERT, UPDATE o DELETE:

```php
<?php
declare(strict_types=1);

$stmt = $pdo->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");
$stmt->execute([3, 10]);

if ($stmt->rowCount() === 0) {
    echo "El producto 10 no existe o ya no quedaba stock" . PHP_EOL;
} else {
    echo "Stock actualizado" . PHP_EOL;
}
```

Advertencia importante: `rowCount()` **no es fiable** para SELECT en todos los motores (SQLite devuelve el número de filas; algunos motores devuelven 0 o -1). Para contar resultados de SELECT usa `COUNT(*)` o cuentas el array de `fetchAll()`.

### Manejo de errores

Con `ERRMODE_EXCEPTION`, todo error de SQL lanza `PDOException`. La capturas con `try/catch`:

```php
<?php
declare(strict_types=1);

try {
    $pdo = new PDO("sqlite::memory:");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->query("SELECT * FROM tabla_inexistente");
} catch (PDOException $e) {
    echo "Error de BD: " . $e->getMessage() . PHP_EOL;
}
```

La `PDOException` expone detalles útiles:

- `getMessage()` — texto del error.
- `getCode()` — el código de error (a veces el código del driver).
- `errorInfo()` (método de PDO) — array con `[SQLSTATE, código del driver, mensaje del driver]`.

```php
<?php
declare(strict_types=1);

try {
    $pdo->query("SELECT * FROM productos_inexistentes");
} catch (PDOException $e) {
    $info = $pdo->errorInfo();
    printf("SQLSTATE: %s | Driver: %s | Mensaje: %s\n", $info[0], $info[1], $info[2]);
}
```

**Regla de oro:** nunca expongas `$e->getMessage()` al usuario final (filtra IPs, rutas y estructura de tablas). En producción, logéalo en un archivo y muestra un mensaje genérico.

### SQLite en memoria para tests

Un truco muy potente: `sqlite::memory:` crea una base de datos **en RAM** que vive mientras dura la conexión. Ideal para tests rápidos sin instalar nada.

```php
<?php
declare(strict_types=1);

function crearPdoDePrueba(): PDO
{
    $pdo = new PDO("sqlite::memory:");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->exec(
        "CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL,
            stock INTEGER NOT NULL DEFAULT 0
        )"
    );
    return $pdo;
}

$pdo = crearPdoDePrueba();
$pdo->exec("INSERT INTO productos (nombre, precio, stock) VALUES ('Laptop', 1200.00, 5)");
$total = (int) $pdo->query("SELECT COUNT(*) FROM productos")->fetchColumn();
echo $total; // 1
```

Ventajas para tests:

- No requiere servidor ni permisos.
- Cada test puede crear su propia base limpia.
- Es rápido: todo ocurre en RAM.
- El mismo código funciona luego contra MySQL/PostgreSQL cambiando solo el DSN.

### Patrones de acceso a datos

#### Repositorio simple con PDO

Un **repositorio** encapsula todas las consultas de una entidad. La dependencia es un `PDO`, así que en tests puedes inyectar la base en memoria:

```php
<?php
declare(strict_types=1);

final class ProductoRepositorio
{
    public function __construct(private PDO $pdo)
    {
    }

    public function crear(string $nombre, float $precio, int $stock): int
    {
        $stmt = $this->pdo->prepare(
            "INSERT INTO productos (nombre, precio, stock) VALUES (?, ?, ?)"
        );
        $stmt->execute([$nombre, $precio, $stock]);
        return (int) $this->pdo->lastInsertId();
    }

    public function porId(int $id): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM productos WHERE id = ?");
        $stmt->execute([$id]);
        $fila = $stmt->fetch();
        return $fila === false ? null : $fila;
    }

    public function todos(): array
    {
        return $this->pdo->query("SELECT * FROM productos ORDER BY nombre")->fetchAll();
    }

    public function actualizarPrecio(int $id, float $precio): bool
    {
        $stmt = $this->pdo->prepare("UPDATE productos SET precio = ? WHERE id = ?");
        $stmt->execute([$precio, $id]);
        return $stmt->rowCount() > 0;
    }

    public function eliminar(int $id): bool
    {
        $stmt = $this->pdo->prepare("DELETE FROM productos WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->rowCount() > 0;
    }
}
```

#### Mini-CRUD completo

CRUD = **Create, Read, Update, Delete**. Un programa CLI que usa el repositorio:

```php
<?php
declare(strict_types=1);

function menu(): string
{
    echo "\n--- Mini CRUD de productos ---\n";
    echo "1) Listar\n2) Crear\n3) Actualizar precio\n4) Eliminar\n5) Salir\n";
    echo "Opción: ";
    return trim(fgets(STDIN));
}

$pdo = crearPdoDePrueba();
$repo = new ProductoRepositorio($pdo);

while (true) {
    $opcion = menu();
    if ($opcion === "5") {
        break;
    }
    switch ($opcion) {
        case "1":
            foreach ($repo->todos() as $p) {
                printf("%d) %s — %.2f € (stock %d)\n", $p["id"], $p["nombre"], $p["precio"], $p["stock"]);
            }
            break;
        case "2":
            echo "Nombre: ";
            $nombre = trim(fgets(STDIN));
            echo "Precio: ";
            $precio = (float) trim(fgets(STDIN));
            $id = $repo->crear($nombre, $precio, 0);
            echo "Creado con id $id\n";
            break;
        case "3":
            echo "Id: ";
            $id = (int) trim(fgets(STDIN));
            echo "Nuevo precio: ";
            $precio = (float) trim(fgets(STDIN));
            echo $repo->actualizarPrecio($id, $precio) ? "Actualizado\n" : "No encontrado\n";
            break;
        case "4":
            echo "Id: ";
            $id = (int) trim(fgets(STDIN));
            echo $repo->eliminar($id) ? "Eliminado\n" : "No encontrado\n";
            break;
        default:
            echo "Opción inválida\n";
    }
}
```

Este patrón (repositorio + PDO inyectado) es exactamente lo que usan los frameworks: separa la lógica de datos de la lógica de negocio y hace los tests triviales al poder sustituir el motor por SQLite en memoria.

## Ejemplos de código

```php
<?php
declare(strict_types=1);
// Ejemplo 1: preparar la base, crear el esquema y sembrar datos
$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

$pdo->exec("CREATE TABLE articulos (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT NOT NULL)");
$pdo->exec("CREATE TABLE comentarios (id INTEGER PRIMARY KEY AUTOINCREMENT, articulo_id INTEGER NOT NULL, texto TEXT NOT NULL)");

$pdo->exec("INSERT INTO articulos (titulo) VALUES ('Primer artículo'), ('Segundo artículo')");
$stmt = $pdo->prepare("INSERT INTO comentarios (articulo_id, texto) VALUES (?, ?)");
$stmt->execute([1, "¡Muy útil!"]);
$stmt->execute([1, "Me encanta"]);
$stmt->execute([2, "Gracias"]);

$sql = "SELECT a.id, a.titulo, COUNT(c.id) AS comentarios
        FROM articulos a
        LEFT JOIN comentarios c ON c.articulo_id = a.id
        GROUP BY a.id
        ORDER BY a.id DESC";
foreach ($pdo->query($sql) as $fila) {
    printf("Artículo %d: %s (%d comentarios)\n", $fila["id"], $fila["titulo"], $fila["comentarios"]);
}
```

```php
<?php
declare(strict_types=1);
// Ejemplo 2: búsqueda dinámica con filtros opcionales y placeholders nombrados
function buscarProductos(PDO $pdo, array $filtros): array
{
    $sql = "SELECT * FROM productos WHERE 1=1";
    $params = [];

    if (isset($filtros["precio_min"])) {
        $sql .= " AND precio >= :precio_min";
        $params["precio_min"] = $filtros["precio_min"];
    }
    if (isset($filtros["stock_min"])) {
        $sql .= " AND stock >= :stock_min";
        $params["stock_min"] = $filtros["stock_min"];
    }
    if (!empty($filtros["nombre"])) {
        $sql .= " AND nombre LIKE :nombre";
        $params["nombre"] = "%" . $filtros["nombre"] . "%";
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchAll();
}

$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec("CREATE TABLE productos (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, precio REAL, stock INTEGER)");
$pdo->exec("INSERT INTO productos (nombre, precio, stock) VALUES ('Laptop', 1200, 5), ('Mouse', 20, 100), ('Teclado', 45, 30)");

foreach (buscarProductos($pdo, ["precio_min" => 30, "stock_min" => 10]) as $p) {
    echo $p["nombre"] . PHP_EOL; // Mouse, Teclado
}
```

```php
<?php
declare(strict_types=1);
// Ejemplo 3: transacción de transferencia entre dos cuentas
$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec("CREATE TABLE cuentas (id INTEGER PRIMARY KEY, titular TEXT, saldo REAL)");
$pdo->exec("INSERT INTO cuentas (id, titular, saldo) VALUES (1, 'Ana', 500), (2, 'Luis', 100)");

function transferir(PDO $pdo, int $origen, int $destino, float $monto): void
{
    if ($monto <= 0) {
        throw new InvalidArgumentException("El monto debe ser positivo");
    }
    try {
        $pdo->beginTransaction();

        $restar = $pdo->prepare("UPDATE cuentas SET saldo = saldo - ? WHERE id = ?");
        $sumar  = $pdo->prepare("UPDATE cuentas SET saldo = saldo + ? WHERE id = ?");

        $restar->execute([$monto, $origen]);
        if ($restar->rowCount() === 0) {
            throw new RuntimeException("Cuenta origen inexistente");
        }
        $sumar->execute([$monto, $destino]);
        if ($sumar->rowCount() === 0) {
            throw new RuntimeException("Cuenta destino inexistente");
        }

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

transferir($pdo, 1, 2, 150.0);
foreach ($pdo->query("SELECT titular, saldo FROM cuentas ORDER BY id") as $fila) {
    echo "{$fila['titular']}: {$fila['saldo']} €" . PHP_EOL;
}
// Ana: 350 € | Luis: 250 €
```

```php
<?php
declare(strict_types=1);
// Ejemplo 4: lectura eficiente con fetchColumn, KEY_PAIR y UNIQUE
$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->exec("CREATE TABLE productos (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, precio REAL)");
$pdo->exec("INSERT INTO productos (nombre, precio) VALUES ('Laptop', 1200), ('Mouse', 20), ('Monitor', 250)");

$total = (int) $pdo->query("SELECT COUNT(*) FROM productos")->fetchColumn();
echo "Total: $total\n";

$precios = $pdo->query("SELECT precio FROM productos")->fetchAll(PDO::FETCH_COLUMN);
echo "Precios: " . implode(", ", $precios) . "\n";

$porId = $pdo->query("SELECT id, nombre, precio FROM productos")
             ->fetchAll(PDO::FETCH_UNIQUE | PDO::FETCH_ASSOC);
echo $porId[2]["nombre"] . "\n"; // Mouse (acceso por id)

$mapa = $pdo->query("SELECT nombre, precio FROM productos")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
echo $mapa["Laptop"] . "\n"; // 1200
```

```php
<?php
declare(strict_types=1);
// Ejemplo 5: manejo de errores con PDOException sin filtrar datos sensibles
function conectarSeguro(string $dsn): PDO
{
    try {
        $pdo = new PDO($dsn);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $pdo;
    } catch (PDOException $e) {
        // Nunca mostrar $e->getMessage() al usuario final
        error_log("[BD] Error de conexión: " . $e->getMessage());
        throw new RuntimeException("No se pudo conectar a la base de datos");
    }
}

try {
    $pdo = conectarSeguro("sqlite::memory:");
    $pdo->query("SELECT * FROM tabla_que_no_existe");
} catch (RuntimeException $e) {
    echo $e->getMessage() . PHP_EOL;          // mensaje genérico
} catch (PDOException $e) {
    echo "Error de consulta: " . $e->getMessage() . PHP_EOL; // detalle técnico en consola
}
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — PDO básico y avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Blog con PDO](../ejercicios/nivel-05-experto/)
- [Proyectos PHP](../ejercicios/proyectos/)

## Errores comunes

- **Interpolar variables directamente en el SQL** → `$pdo->query("SELECT * FROM t WHERE x = '$var'")` es una bomba de inyección SQL. Usa siempre `prepare()` + `execute()` con placeholders.
- **No configurar `ERRMODE_EXCEPTION`** → los errores pasan en silencio y el código "falla" sin dar pistas. Configúralo justo después de conectar.
- **Confundir `exec()` con `query()`** → `exec()` devuelve filas afectadas y no sirve para SELECT; `query()` devuelve un `PDOStatement`. Úsalos según lo que necesites.
- **Mezclar `?` y `:nombre` en la misma consulta** → `SQLSTATE[HY093]: Invalid parameter number`. Elige un solo estilo de placeholder por sentencia.
- **Pasar claves con `:` en `execute()`** → si escribes `execute([':precio' => 5])` y en otro sitio `execute(['precio' => 5])`, rompes la consistencia. Elige una convención (sin `:` es la más común) y respétala.
- **No hacer `rollBack()` en el `catch`** → la transacción queda abierta, las escrituras se mantienen y el estado se corrompe. Llama `rollBack()` (o comprueba `inTransaction()`) antes de relanzar.
- **Usar `rowCount()` para contar resultados de SELECT** → en varios motores devuelve 0 o -1. Usa `SELECT COUNT(*)` o `count($stmt->fetchAll())`.
- **Olvidar que `lastInsertId()` es por conexión** → si usas pools o varias conexiones, el ID puede no corresponder a tu INSERT. Captúralo inmediatamente después del `execute()`.
- **Leer `getMessage()` de `PDOException` y mostrarlo al usuario** → filtra información interna (rutas, estructura de tablas, IPs). Logéalo y muestra un mensaje genérico.
- **Asumir que `fetch()` siempre devuelve array** → devuelve `false` si no hay más filas. Comprueba `=== false` antes de usar el resultado.
- **Crear una conexión por consulta** → es lentísimo y agota el pool. Crea un `PDO` una vez y reutilízalo (inyéctal0 como dependencia).
- **Olvidar `charset=utf8mb4` en MySQL** → los acentos y emojis se corrompen o producen `SQLSTATE[HY000]: charset is unknown`. Inclúyelo siempre en el DSN.
- **`sqlite database is locked` en transacciones** → SQLite serializa escrituras. Cierra el `PDOStatement` antes de escribir de nuevo y reduce el tiempo de transacción.
- **Tratar los tipos como si fueran estrictos** → PDO puede devolver `int` o `string` según el driver. Si necesitas garantías, castea: `(int) $fila["id"]` o `(float) $fila["precio"]`.
- **No comprobar `rowCount()` en UPDATE/DELETE** → crees que modificaste algo y no lo hiciste. Verifica el número de filas afectadas para informar al usuario.

## Recursos

- [PHP.net — PDO](https://www.php.net/manual/es/book.pdo.php)
- [PHP.net — PDO::prepare](https://www.php.net/manual/es/pdo.prepare.php)
- [PHP.net — PDOStatement](https://www.php.net/manual/es/class.pdostatement.php)
- [PHP.net — Modos de obtención](https://www.php.net/manual/es/pdostatement.fetch.php)
- [PHP.net — Transacciones](https://www.php.net/manual/es/pdo.transactions.php)
- [PHP.net — Errores y manejo](https://www.php.net/manual/es/pdo.error-handling.php)
- [PHP.net — PDO::lastInsertId](https://www.php.net/manual/es/pdo.lastinsertid.php)
- [PHP.net — PDO::rowCount](https://www.php.net/manual/es/pdostatement.rowcount.php)
- [OWASP — SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [SQLite — PRAGMA (optimizaciones)](https://www.sqlite.org/pragma.html)