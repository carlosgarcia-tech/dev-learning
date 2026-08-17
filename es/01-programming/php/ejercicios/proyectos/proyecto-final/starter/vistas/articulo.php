<?php
// Detalle de un artículo publicado + sus comentarios.
$articulo = $datos['articulo'] ?? null;
$comentarios = $datos['comentarios'] ?? [];
$error = $datos['error'] ?? null;

if ($articulo === null): ?>
    <p class="muted">El artículo no existe.</p>
<?php else: ?>
    <article>
        <h1><?= htmlspecialchars($articulo['titulo']) ?></h1>
        <p class="muted">Por <?= htmlspecialchars($articulo['autor']) ?> · <?= htmlspecialchars($articulo['creado_en']) ?></p>
        <div><?= nl2br(htmlspecialchars($articulo['contenido'])) ?></div>
    </article>

    <h2>Comentarios (<?= count($comentarios) ?>)</h2>

    <?php if ($error !== null): ?>
        <p class="error"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>

    <form method="post" action="/articulo/<?= (int) $articulo['id'] ?>/comentar">
        <label>Autor: <input type="text" name="autor"></label><br>
        <label>Comentario:<br><textarea name="texto" rows="3" cols="50"></textarea></label><br>
        <button type="submit">Comentar</button>
    </form>

    <?php foreach ($comentarios as $comentario): ?>
        <p><strong><?= htmlspecialchars($comentario['autor']) ?></strong> · <?= htmlspecialchars($comentario['creado_en']) ?><br>
        <?= nl2br(htmlspecialchars($comentario['texto'])) ?></p>
    <?php endforeach; ?>
<?php endif; ?>