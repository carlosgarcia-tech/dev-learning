<?php
// Portada: lista los artículos publicados de $datos['articulos'].
$articulos = $datos['articulos'] ?? [];
?>
<h1>Blog PHP</h1>

<?php if ($articulos === []): ?>
    <p class="muted">Todavía no hay artículos publicados.</p>
<?php endif; ?>

<?php foreach ($articulos as $articulo): ?>
    <article>
        <h2><a href="/articulo/<?= (int) $articulo['id'] ?>"><?= htmlspecialchars($articulo['titulo']) ?></a></h2>
        <p><?= nl2br(htmlspecialchars(substr($articulo['contenido'], 0, 200))) ?>...</p>
        <p class="muted">Por <?= htmlspecialchars($articulo['autor']) ?> · <?= htmlspecialchars($articulo['creado_en']) ?></p>
    </article>
<?php endforeach; ?>