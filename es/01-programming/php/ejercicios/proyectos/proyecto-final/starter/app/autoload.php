<?php

declare(strict_types=1);

// Autoload simple PSR-4 para la carpeta app/:
// la clase "Blog" se busca en app/Blog.php, "Sesion" en app/Sesion.php, etc.
// Este archivo está completo a propósito: sin él, nada carga.
spl_autoload_register(function (string $clase): void {
    $archivo = __DIR__ . '/' . $clase . '.php';
    if (is_file($archivo)) {
        require $archivo;
    }
});