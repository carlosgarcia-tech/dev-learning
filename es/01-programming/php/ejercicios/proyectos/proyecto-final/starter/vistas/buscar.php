<?php
// Resultados de búsqueda sobre artículos publicados.
$texto = $datos['texto'] ?? '';
$articulos = $datos['articulos'] ?? [];
?>
<h1>Buscar</h1>

<form method="get" action="/buscar">
    <input type="text" name="q" value="<?= htmlspecialchars($texto) ?>" placeholder="Buscar artículos...">
    <button type="submit">Buscar</button>
</form>

<?php if ($articulos === []): ?>
    <p class="muted">Sin resultados para «<?= htmlspecialchars($texto) ?>».</p>
<?php endif; ?>

<?php foreach ($articulos as $articulo): ?>
    <article>
        <h2><a href="/articulo/<?= (int) $articulo['id'] ?>"><?= htmlspecialchars($articulo['titulo']) ?></a></h2>
        <p class="muted">Por <?= htmlspecialchars($articulo['autor']) ?></p>
    </article>
<?php endforeach; ?>