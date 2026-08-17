<?php
// Formulario compartido para crear y editar artículos.
$articulo = $datos['articulo'] ?? null;
$esEdicion = $articulo !== null;
$error = $datos['error'] ?? null;

$titulo = $articulo['titulo'] ?? '';
$contenido = $articulo['contenido'] ?? '';
$publicado = isset($articulo['publicado']) ? (bool) $articulo['publicado'] : true;
$accion = $esEdicion ? '/admin/articulos/' . (int) $articulo['id'] : '/admin/articulos';
?>
<h1><?= $esEdicion ? 'Editar artículo' : 'Nuevo artículo' ?></h1>

<?php if ($error !== null): ?>
    <p class="error"><?= htmlspecialchars($error) ?></p>
<?php endif; ?>

<form method="post" action="<?= $accion ?>">
    <label>Título:<br><input type="text" name="titulo" value="<?= htmlspecialchars($titulo) ?>" size="60"></label><br>
    <label>Contenido:<br><textarea name="contenido" rows="10" cols="60"><?= htmlspecialchars($contenido) ?></textarea></label><br>
    <label><input type="checkbox" name="publicado" value="1" <?= $publicado ? 'checked' : '' ?>> Publicar</label><br>
    <button type="submit">Guardar</button>
    <a href="/admin">Cancelar</a>
</form>