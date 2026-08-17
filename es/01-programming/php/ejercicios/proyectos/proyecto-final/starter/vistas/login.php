<?php
// Formulario de inicio de sesión.
$error = $datos['error'] ?? null;
?>
<h1>Iniciar sesión</h1>

<?php if ($error !== null): ?>
    <p class="error"><?= htmlspecialchars($error) ?></p>
<?php endif; ?>

<form method="post" action="/login">
    <label>Usuario: <input type="text" name="nombre"></label><br>
    <label>Contraseña: <input type="password" name="clave"></label><br>
    <button type="submit">Entrar</button>
</form>

<p class="muted">¿No tienes cuenta? <a href="/registro">Regístrate</a>.</p>