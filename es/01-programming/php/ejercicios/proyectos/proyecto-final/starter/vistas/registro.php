<?php
// Formulario de registro de un usuario con rol 'autor'.
$error = $datos['error'] ?? null;
?>
<h1>Crear cuenta</h1>

<?php if ($error !== null): ?>
    <p class="error"><?= htmlspecialchars($error) ?></p>
<?php endif; ?>

<form method="post" action="/registro">
    <label>Usuario: <input type="text" name="nombre"></label><br>
    <label>Contraseña: <input type="password" name="clave"></label><br>
    <button type="submit">Registrarse</button>
</form>