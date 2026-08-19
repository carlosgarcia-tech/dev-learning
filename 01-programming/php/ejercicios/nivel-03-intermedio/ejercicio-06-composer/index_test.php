<?php

declare(strict_types=1);

require __DIR__ . '/index.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(rutaPsr4('App\\Nucleo\\Usuario') === 'App/Nucleo/Usuario.php', 'rutaPsr4 debe convertir backslashes');
check(rutaPsr4('Usuario') === 'Usuario.php', 'rutaPsr4 sin namespace');

$jsonOk = '{"name":"x/y","autoload":{"psr-4":{"App\\\\":"src/"}}}';
$jsonMal = '{"name":"x/y","require":{"php":">=8.1"}}';
check(autoloadCorrecto($jsonOk) === true, 'autoloadCorrecto debe detectar psr-4');
check(autoloadCorrecto($jsonMal) === false, 'autoloadCorrecto debe ser false sin psr-4');
check(autoloadCorrecto('no json') === false, 'autoloadCorrecto debe manejar JSON inválido');

$raiz = sys_get_temp_dir() . '/php-autoload-' . bin2hex(random_bytes(4));
mkdir($raiz . '/App/Nucleo', 0777, true);
file_put_contents(
    $raiz . '/App/Nucleo/Usuario.php',
    "<?php\nnamespace App\\Nucleo;\nclass Usuario { public function nombre(): string { return 'ana'; } }"
);

$loader = generarAutoloader($raiz);
check($loader('App\\Nucleo\\Usuario') === true, 'generarAutoloader debe cargar una clase existente');
check($loader('App\\Nucleo\\Inexistente') === false, 'generarAutoloader debe devolver false si no existe');

$instalado = instalarAutoloader($raiz);
check(is_callable($instalado), 'instalarAutoloader debe devolver la closure');
$usuario = new \App\Nucleo\Usuario();
check($usuario->nombre() === 'ana', 'el autoloader registrado debe permitir instanciar sin require');

array_map('unlink', glob($raiz . '/App/Nucleo/*'));
rmdir($raiz . '/App/Nucleo');
rmdir($raiz . '/App');
rmdir($raiz);

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);