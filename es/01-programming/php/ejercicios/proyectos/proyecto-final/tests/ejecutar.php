<?php

declare(strict_types=1);

// Suite de tests del PROYECTO FINAL.
// Uso: cd proyecto-final/tests && php ejecutar.php
// Solo pasa (exit 0) cuando el proyecto en starter/ está completo y correcto.

require __DIR__ . '/../starter/app/autoload.php';

$errores = [];
$aserciones = 0;

function check(bool $condicion, string $mensaje): void
{
    global $errores, $aserciones;
    $aserciones++;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

function lanza(callable $fn, string $clase): bool
{
    try {
        $fn();
        return false;
    } catch (Throwable $e) {
        return $e instanceof $clase;
    }
}

function nuevoAlmacenamiento(): array
{
    $ruta = sys_get_temp_dir() . '/proyecto-final-' . bin2hex(random_bytes(6)) . '/datos.json';
    return [new Almacenamiento($ruta), $ruta];
}

function limpiarTemp(string $ruta): void
{
    $dir = dirname($ruta);
    if (is_file($ruta)) {
        unlink($ruta);
    }
    $padres = [];
    while (str_contains($dir, 'proyecto-final-') && is_dir($dir)) {
        $padres[] = $dir;
        $dir = dirname($dir);
        if (count($padres) > 10) {
            break;
        }
    }
    foreach ($padres as $d) {
        @rmdir($d);
    }
}

// ============================================================
// 1. ESTRUCTURA DEL PROYECTO
// ============================================================

check(is_file(__DIR__ . '/../README.md'), 'falta el README.md del proyecto final');
check(is_file(__DIR__ . '/../starter/app/autoload.php'), 'falta starter/app/autoload.php');
check(is_file(__DIR__ . '/../starter/app/Almacenamiento.php'), 'falta starter/app/Almacenamiento.php');
check(is_file(__DIR__ . '/../starter/app/Sesion.php'), 'falta starter/app/Sesion.php');
check(is_file(__DIR__ . '/../starter/app/ValidacionException.php'), 'falta starter/app/ValidacionException.php');
check(is_file(__DIR__ . '/../starter/app/Validador.php'), 'falta starter/app/Validador.php');
check(is_file(__DIR__ . '/../starter/app/Blog.php'), 'falta starter/app/Blog.php');
check(is_file(__DIR__ . '/../starter/app/Auth.php'), 'falta starter/app/Auth.php');
check(is_file(__DIR__ . '/../starter/app/Enrutador.php'), 'falta starter/app/Enrutador.php');
check(is_file(__DIR__ . '/../starter/public/index.php'), 'falta starter/public/index.php');
check(is_dir(__DIR__ . '/../starter/vistas'), 'falta la carpeta starter/vistas');
check(is_dir(__DIR__ . '/../starter/data'), 'falta la carpeta starter/data');

$indexPhp = @file_get_contents(__DIR__ . '/../starter/public/index.php');
check(is_string($indexPhp) && str_contains($indexPhp, '../app/autoload.php'), 'public/index.php debe cargar el autoload');
check(is_string($indexPhp) && str_contains($indexPhp, 'data/datos.json'), 'public/index.php debe persistir en data/datos.json');
check(is_string($indexPhp) && str_contains($indexPhp, 'session_start'), 'public/index.php debe iniciar la sesión');

check(class_exists('Almacenamiento'), 'la clase Almacenamiento debe cargar con el autoload');
check(class_exists('Sesion'), 'la clase Sesion debe cargar con el autoload');
check(class_exists('Validador'), 'la clase Validador debe cargar con el autoload');
check(class_exists('ValidacionException'), 'la clase ValidacionException debe cargar con el autoload');
check(class_exists('Blog'), 'la clase Blog debe cargar con el autoload');
check(class_exists('Auth'), 'la clase Auth debe cargar con el autoload');
check(class_exists('Enrutador'), 'la clase Enrutador debe cargar con el autoload');

if ($errores !== []) {
    fwrite(STDERR, "ERRORES DE ESTRUCTURA — el proyecto no está completo." . PHP_EOL . PHP_EOL);
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

// ============================================================
// 2. ALMACENAMIENTO
// ============================================================

[$alm, $ruta] = nuevoAlmacenamiento();

check($alm->ruta() === $ruta, 'Almacenamiento::ruta() debe devolver la ruta');
check(is_array($alm->leerTodo()), 'leerTodo() sin archivo debe devolver un array');
check($alm->leerTodo()['siguiente_id'] === 1, 'la estructura inicial debe empezar en id 1');
check($alm->leerTodo()['usuarios'] === [], 'la estructura inicial no debe tener usuarios');
check($alm->leerTodo()['articulos'] === [], 'la estructura inicial no debe tener artículos');
check($alm->leerTodo()['comentarios'] === [], 'la estructura inicial no debe tener comentarios');
check($alm->leerColeccion('usuarios') === [], 'leerColeccion() debe devolver la colección');
check($alm->leerColeccion('no-existe') === [], 'leerColeccion() de una clave ausente devuelve []');
check($alm->siguienteId() === 1, 'siguienteId() inicial debe ser 1');

$datos = ['siguiente_id' => 5, 'usuarios' => [], 'articulos' => [], 'comentarios' => []];
$alm->guardarTodo($datos);
check(is_file($ruta), 'guardarTodo() debe crear el archivo en disco');
check($alm->leerTodo()['siguiente_id'] === 5, 'guardarTodo()+leerTodo() deben conservar los datos');

file_put_contents($ruta, '{json-corrupto');
check($alm->leerTodo()['siguiente_id'] === 1, 'un archivo corrupto debe recuperar la estructura inicial');

$ruta2 = sys_get_temp_dir() . '/proyecto-final-' . bin2hex(random_bytes(6)) . '/sub/datos.json';
$alm2 = new Almacenamiento($ruta2);
$alm2->guardarTodo(['siguiente_id' => 1, 'usuarios' => [], 'articulos' => [], 'comentarios' => []]);
check(is_file($ruta2), 'guardarTodo() debe crear directorios intermedios');

limpiarTemp($ruta);
limpiarTemp($ruta2);

// ============================================================
// 3. VALIDADOR
// ============================================================

check(lanza(fn () => Validador::validarTitulo(''), ValidacionException::class), 'el título vacío debe rechazarse');
check(lanza(fn () => Validador::validarTitulo(str_repeat('a', 101)), ValidacionException::class), 'el título de más de 100 caracteres debe rechazarse');
Validador::validarTitulo('Título válido');
check(true, 'un título correcto no debe lanzar');

check(lanza(fn () => Validador::validarContenido(''), ValidacionException::class), 'el contenido vacío debe rechazarse');
check(lanza(fn () => Validador::validarContenido('corto'), ValidacionException::class), 'el contenido de menos de 10 caracteres debe rechazarse');
Validador::validarContenido('Contenido lo bastante largo');
check(true, 'un contenido correcto no debe lanzar');

check(lanza(fn () => Validador::validarComentario(''), ValidacionException::class), 'el comentario vacío debe rechazarse');
check(lanza(fn () => Validador::validarComentario(str_repeat('x', 501)), ValidacionException::class), 'el comentario de más de 500 caracteres debe rechazarse');
Validador::validarComentario('Un comentario normal');
check(true, 'un comentario correcto no debe lanzar');

check(lanza(fn () => Validador::validarCredenciales('', 'clave123'), ValidacionException::class), 'el usuario vacío debe rechazarse');
check(lanza(fn () => Validador::validarCredenciales('x', 'clave123'), ValidacionException::class), 'el usuario de menos de 3 caracteres debe rechazarse');
check(lanza(fn () => Validador::validarCredenciales('nombre válido', 'clave123'), ValidacionException::class), 'el usuario con espacios debe rechazarse');
check(lanza(fn () => Validador::validarCredenciales('valido', '123'), ValidacionException::class), 'la contraseña corta debe rechazarse');
Validador::validarCredenciales('valido_1', 'clave123');
check(true, 'unas credenciales correctas no deben lanzar');

check(Validador::validarEmail('ana@mail.com') === true, 'un email válido devuelve true');
check(Validador::validarEmail('no-es-email') === false, 'un email inválido devuelve false');
check(Validador::normalizarTitulo('  Hola  ') === 'Hola', 'normalizarTitulo() debe recortar espacios');

// ============================================================
// 4. BLOG: ARTÍCULOS Y COMENTARIOS
// ============================================================

[$almB, $rutaB] = nuevoAlmacenamiento();
$blog = new Blog($almB);

$idBorrador = $blog->crearArticulo('Borrador', 'Contenido inicial de ejemplo', false, 'ana');
$idPublicado = $blog->crearArticulo('Publicado', 'Contenido publicado de ejemplo', true, 'ana');

check($idBorrador === 1, 'el primer artículo debe tener id 1');
check($idPublicado === 2, 'el segundo artículo debe tener id 2');
check(count($blog->listarArticulos()) === 2, 'listarArticulos() debe devolver 2 artículos');
check(count($blog->listarArticulos(true)) === 1, 'listarArticulos(true) solo devuelve publicados');
check($blog->listarArticulos(true)[0]['id'] === 2, 'los artículos deben ordenarse por id desc');
check($blog->listarArticulos()[0]['id'] === 2, 'el más reciente debe aparecer primero');
check($blog->obtenerArticulo($idBorrador)['titulo'] === 'Borrador', 'obtenerArticulo() debe encontrar el artículo');
check($blog->obtenerArticulo(999) === null, 'obtenerArticulo() de un id inexistente devuelve null');
check($blog->obtenerArticulo(1)['publicado'] === false, 'los borradores deben guardarse como no publicados');

check($blog->actualizarArticulo(1, 'Borrador actualizado', 'Contenido actualizado largo', false) === true, 'actualizarArticulo() devuelve true');
check($blog->obtenerArticulo(1)['titulo'] === 'Borrador actualizado', 'actualizarArticulo() debe cambiar el título');
check($blog->actualizarArticulo(999, 'X', 'Contenido largo válido', false) === false, 'actualizarArticulo() de un id inexistente devuelve false');
check(lanza(fn () => $blog->actualizarArticulo(1, '', 'Contenido largo válido', false), ValidacionException::class), 'actualizar con título vacío debe rechazarse');

check($blog->agregarComentario(2, 'Ana', '¡Gran artículo!') === 3, 'el primer comentario debe tener id 3');
check($blog->agregarComentario(2, 'Pablo', 'Muy útil') === 4, 'el segundo comentario debe tener id 4');
check($blog->contarComentarios(2) === 2, 'contarComentarios() debe devolver 2');
check($blog->contarComentarios(1) === 0, 'contarComentarios() de un artículo sin comentarios devuelve 0');
check(count($blog->listarComentarios(2)) === 2, 'listarComentarios() debe devolver los comentarios');
check($blog->listarComentarios(2)[0]['autor'] === 'Ana', 'los comentarios deben conservar su autor');
check(lanza(fn () => $blog->agregarComentario(1, 'Ana', 'Texto de comentario'), ValidacionException::class), 'no se puede comentar un borrador');
check(lanza(fn () => $blog->agregarComentario(2, 'Ana', ''), ValidacionException::class), 'el comentario vacío debe rechazarse');
check(lanza(fn () => $blog->agregarComentario(999, 'Ana', 'Texto de comentario'), ValidacionException::class), 'no se puede comentar un artículo inexistente');

check(count($blog->buscarArticulos('publicado')) === 1, 'buscarArticulos() encuentra por título');
check(count($blog->buscarArticulos('publicado de ejemplo')) === 1, 'buscarArticulos() encuentra por contenido');
check(count($blog->buscarArticulos('no existe')) === 0, 'buscarArticulos() sin resultados devuelve []');
check(count($blog->buscarArticulos('actualizado', false)) === 1, 'buscarArticulos(false) incluye borradores');
check(count($blog->buscarArticulos('', false)) === 0, 'una búsqueda vacía no devuelve resultados');

check($blog->eliminarArticulo(2) === true, 'eliminarArticulo() devuelve true');
check($blog->obtenerArticulo(2) === null, 'eliminarArticulo() debe borrar el artículo');
check($blog->listarComentarios(2) === [], 'eliminar un artículo debe borrar también sus comentarios');
check($blog->eliminarArticulo(2) === false, 'eliminarArticulo() de un id inexistente devuelve false');
check(count($blog->listarArticulos()) === 1, 'solo debe quedar el artículo borrador');

limpiarTemp($rutaB);

// ============================================================
// 5. AUTH: USUARIOS, SESIÓN Y ROLES
// ============================================================

[$almA, $rutaA] = nuevoAlmacenamiento();
$ref = [];
$sesion = new Sesion($ref);
$auth = new Auth($almA, $sesion);

check($auth->registrar('ana', 'secreto123') === true, 'registrar() debe devolver true');
check(count($auth->listarUsuarios()) === 1, 'debe haber 1 usuario registrado');
check($auth->buscarPorNombre('ana')['rol'] === 'autor', 'el rol por defecto debe ser autor');
check(lanza(fn () => $auth->registrar('ana', 'otraclave'), ValidacionException::class), 'no se puede registrar un nombre duplicado');
check(lanza(fn () => $auth->registrar('x', 'clave123'), ValidacionException::class), 'el registro con nombre inválido debe rechazarse');
check(lanza(fn () => $auth->registrar('valido', '123'), ValidacionException::class), 'el registro con contraseña corta debe rechazarse');

check($auth->registrar('admin', 'clavefuerte', 'admin') === true, 'registrar() debe aceptar el rol admin');
check($auth->buscarPorNombre('admin')['rol'] === 'admin', 'el rol admin debe conservarse');
check($auth->buscarPorNombre('ana')['clave'] !== 'secreto123', 'la contraseña debe guardarse con hash');
check(password_verify('secreto123', $auth->buscarPorNombre('ana')['clave']) === true, 'password_verify debe validar la contraseña');
check($auth->esAdmin('admin') === true, 'esAdmin() reconoce el rol admin');
check($auth->esAdmin('autor') === false, 'esAdmin() rechaza el rol autor');
check($auth->esAdmin() === false, 'sin sesión no se es admin');

check($auth->login('ana', 'secreto123') === true, 'login() con credenciales correctas devuelve true');
check($auth->estaAutenticado() === true, 'tras el login debe haber sesión activa');
check($auth->usuarioActual()['nombre'] === 'ana', 'usuarioActual() debe devolver al usuario logueado');
check($auth->rolActual() === 'autor', 'rolActual() debe devolver el rol de la sesión');
check($ref['usuario_id'] === 1, 'el id del usuario debe escribirse en la sesión');
check($auth->esAdmin() === false, 'un autor no es admin');

check($auth->login('ana', 'clave-incorrecta') === false, 'login() con contraseña incorrecta devuelve false');
check($auth->login('no-existe', 'secreto123') === false, 'login() de un usuario inexistente devuelve false');

$auth->logout();
check($auth->estaAutenticado() === false, 'logout() debe cerrar la sesión');
check($auth->usuarioActual() === null, 'usuarioActual() sin sesión devuelve null');

check($auth->login('admin', 'clavefuerte') === true, 'login() del admin debe funcionar');
check($auth->esAdmin() === true, 'un admin sí es admin');

limpiarTemp($rutaA);

// ============================================================
// 6. ENRUTADOR
// ============================================================

$enrutador = new Enrutador();
$enrutador->get('/inicio', fn (): array => ['status' => 200, 'vista' => 'inicio', 'datos' => []]);
$enrutador->get('/articulo/{id}', fn (array $params): array => ['status' => 200, 'vista' => 'articulo', 'datos' => ['id' => $params['id']]]);
$enrutador->post('/login', function (array $params, array $extra): array {
    return ['status' => 200, 'vista' => 'login', 'datos' => ['body' => $extra]];
});

check($enrutador->despachar('GET', '/inicio')['vista'] === 'inicio', 'despachar() debe llamar al controlador GET');
check($enrutador->despachar('GET', '/articulo/7')['datos']['id'] === '7', 'despachar() debe capturar {id}');
check($enrutador->despachar('POST', '/login', ['nombre' => 'ana'])['datos']['body']['nombre'] === 'ana', 'despachar() debe pasar $extra al controlador');
check($enrutador->despachar('GET', '/login')['status'] === 404, 'GET sobre una ruta solo-POST debe ser 404');
check($enrutador->despachar('POST', '/inicio')['status'] === 404, 'POST sobre una ruta solo-GET debe ser 404');
check($enrutador->despachar('PUT', '/inicio')['status'] === 404, 'un método no registrado debe ser 404');
check($enrutador->despachar('GET', '/no-existe')['status'] === 404, 'una ruta inexistente debe ser 404');
check($enrutador->despachar('GET', '/no-existe')['vista'] === 'no-encontrada', 'el 404 debe usar la vista no-encontrada');
check($enrutador->despachar('GET', '/articulo/7/extra')['status'] === 404, 'un número de segmentos distinto no debe coincidir');

// ============================================================
// 7. INTEGRACIÓN: AUTH + BLOG + ENRUTADOR
// ============================================================

[$almI, $rutaI] = nuevoAlmacenamiento();
$refI = [];
$sesionI = new Sesion($refI);
$blogI = new Blog($almI);
$authI = new Auth($almI, $sesionI);
$app = new Enrutador();

$app->post('/login', function (array $params, array $extra) use ($authI): array {
    return $authI->login($extra['nombre'], $extra['clave'])
        ? ['status' => 200, 'vista' => 'ok']
        : ['status' => 401, 'vista' => 'error'];
});
$app->get('/admin', function (array $params, array $extra) use ($authI, $blogI): array {
    if (!$authI->estaAutenticado() || !$authI->esAdmin()) {
        return ['status' => 403, 'vista' => 'prohibido'];
    }
    return ['status' => 200, 'vista' => 'admin', 'datos' => ['total' => count($blogI->listarArticulos())]];
});

$authI->registrar('jefa', 'clave-secreta', 'admin');
$authI->registrar('lector', 'clave-secreta');

check($app->despachar('POST', '/login', ['nombre' => 'jefa', 'clave' => 'clave-secreta'])['status'] === 200, 'el login del admin debe funcionar a través del enrutador');
check($app->despachar('GET', '/admin')['status'] === 200, 'un admin autenticado accede al panel');
check($app->despachar('GET', '/admin')['datos']['total'] === 0, 'el panel refleja el estado del blog');

$authI->logout();
check($app->despachar('GET', '/admin')['status'] === 403, 'sin sesión el panel está prohibido');

check($app->despachar('POST', '/login', ['nombre' => 'lector', 'clave' => 'clave-secreta'])['status'] === 200, 'el login del lector debe funcionar');
check($app->despachar('GET', '/admin')['status'] === 403, 'un autor no puede entrar al panel');

limpiarTemp($rutaI);

// ============================================================
// RESULTADO
// ============================================================

if ($errores !== []) {
    fwrite(STDERR, "FALLARON " . count($errores) . " aserciones de $aserciones:" . PHP_EOL . PHP_EOL);
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: el proyecto final supera las " . $aserciones . " comprobaciones." . PHP_EOL;
exit(0);