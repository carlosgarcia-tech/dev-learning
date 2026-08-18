<?php

declare(strict_types=1);

// Front controller: TODO, aquí se conectan todas las piezas.
// Es el único punto de entrada del blog.

require __DIR__ . '/../app/autoload.php';

session_start();

$almacenamiento = new Almacenamiento(__DIR__ . '/../data/datos.json');
$blog = new Blog($almacenamiento);
$auth = new Auth($almacenamiento, new Sesion());
$enrutador = new Enrutador();

// --- Rutas públicas -------------------------------------------------------

$enrutador->get('/', function () use ($blog): array {
    // TODO: portada con los artículos publicados (más recientes primero).
    throw new Exception("TODO: ruta GET /");
});

$enrutador->get('/articulo/{id}', function (array $params) use ($blog): array {
    // TODO: detalle del artículo publicado + sus comentarios; 404 si no existe.
    throw new Exception("TODO: ruta GET /articulo/{id}");
});

$enrutador->post('/articulo/{id}/comentar', function (array $params, array $extra) use ($blog): array {
    // TODO: crea un comentario (autor de $extra o 'Anónimo') y redirige
    // al artículo; captura ValidacionException y devuelve 422 con el error.
    throw new Exception("TODO: ruta POST /articulo/{id}/comentar");
});

$enrutador->get('/buscar', function (array $params, array $extra) use ($blog): array {
    // TODO: resultados de búsqueda sobre artículos publicados.
    throw new Exception("TODO: ruta GET /buscar");
});

// --- Autenticación --------------------------------------------------------

$enrutador->get('/login', function (): array {
    // TODO: formulario de login.
    throw new Exception("TODO: ruta GET /login");
});

$enrutador->post('/login', function (array $params, array $extra) use ($auth): array {
    // TODO: valida credenciales y redirige a / si hay éxito; 401 si no.
    throw new Exception("TODO: ruta POST /login");
});

$enrutador->get('/registro', function (): array {
    // TODO: formulario de registro.
    throw new Exception("TODO: ruta GET /registro");
});

$enrutador->post('/registro', function (array $params, array $extra) use ($auth): array {
    // TODO: registra el usuario y redirige al login.
    throw new Exception("TODO: ruta POST /registro");
});

$enrutador->get('/logout', function () use ($auth): array {
    // TODO: cierra sesión y redirige a /.
    throw new Exception("TODO: ruta GET /logout");
});

// --- Panel de administración (solo admin) ---------------------------------

$enrutador->get('/admin', function (array $params, array $extra) use ($blog, $auth): array {
    // TODO: lista de artículos (borradores y publicados) solo para admin.
    throw new Exception("TODO: ruta GET /admin");
});

$enrutador->get('/admin/articulos/nuevo', function () use ($auth): array {
    // TODO: formulario para crear artículo (solo admin).
    throw new Exception("TODO: ruta GET /admin/articulos/nuevo");
});

$enrutador->post('/admin/articulos', function (array $params, array $extra) use ($blog, $auth): array {
    // TODO: crea el artículo (solo admin) y redirige a /admin.
    throw new Exception("TODO: ruta POST /admin/articulos");
});

$enrutador->get('/admin/articulos/{id}/editar', function (array $params) use ($blog, $auth): array {
    // TODO: formulario de edición (solo admin).
    throw new Exception("TODO: ruta GET /admin/articulos/{id}/editar");
});

$enrutador->post('/admin/articulos/{id}', function (array $params, array $extra) use ($blog, $auth): array {
    // TODO: actualiza el artículo (solo admin) y redirige a /admin.
    throw new Exception("TODO: ruta POST /admin/articulos/{id}");
});

$enrutador->post('/admin/articulos/{id}/eliminar', function (array $params) use ($blog, $auth): array {
    // TODO: elimina el artículo y sus comentarios (solo admin) y redirige.
    throw new Exception("TODO: ruta POST /admin/articulos/{id}/eliminar");
});

// --- Despacho y renderizado ------------------------------------------------

$metodo = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';

$respuesta = $enrutador->despachar($metodo, $uri, [
    'usuario' => $auth->usuarioActual(),
    'body' => $_POST,
]);

if (isset($respuesta['redirigir'])) {
    header('Location: ' . $respuesta['redirigir'], true, $respuesta['status']);
    exit;
}

http_response_code($respuesta['status'] ?? 200);
$vista = $respuesta['vista'] ?? 'no-encontrada';
$datos = $respuesta['datos'] ?? [];
$datos['usuario'] = $auth->usuarioActual();

$archivoVista = __DIR__ . '/../vistas/' . $vista . '.php';
if (!is_file($archivoVista)) {
    $archivoVista = __DIR__ . '/../vistas/no-encontrada.php';
}

require __DIR__ . '/../vistas/layout.php';