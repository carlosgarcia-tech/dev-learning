<?php
// Página de error 404.
$error = $datos['error'] ?? 'La página que buscas no existe.';
?>
<h1>404</h1>
<p class="error"><?= htmlspecialchars($error) ?></p>
<p><a href="/">Volver al inicio</a></p>