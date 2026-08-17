<?php
// Layout común: abre el HTML, muestra la navegación y renderiza la vista
// indicada en $archivoVista con los datos de $datos.
if (!isset($datos)) {
    $datos = [];
}
$usuario = $datos['usuario'] ?? null;
$titulo = htmlspecialchars((string) ($datos['titulo'] ?? 'Blog PHP'));
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $titulo ?></title>
    <style>
        body { font-family: system-ui, sans-serif; margin: 0; background: #f4f4f5; color: #18181b; }
        header { background: #18181b; color: #fff; padding: 0.75rem 1.5rem; }
        nav a { color: #fff; text-decoration: none; margin-right: 1rem; }
        main { max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
        article { background: #fff; border-radius: 8px; padding: 1rem 1.25rem; margin-bottom: 1rem; }
        .error { color: #b91c1c; background: #fee2e2; padding: 0.5rem 1rem; border-radius: 6px; }
        .muted { color: #71717a; font-size: 0.9rem; }
        button, input, textarea { font: inherit; padding: 0.4rem 0.6rem; margin: 0.2rem 0; }
    </style>
</head>
<body>
<header>
    <nav>
        <a href="/">Inicio</a>
        <a href="/buscar">Buscar</a>
        <?php if ($usuario !== null): ?>
            <a href="/admin">Admin</a>
            <a href="/logout">Salir (<?= htmlspecialchars($usuario['nombre']) ?>)</a>
        <?php else: ?>
            <a href="/login">Entrar</a>
            <a href="/registro">Registrarse</a>
        <?php endif; ?>
    </nav>
</header>
<main>
<?php require $archivoVista; ?>
</main>
</body>
</html>