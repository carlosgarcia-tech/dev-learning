<?php
// Panel de administración: lista todos los artículos (borradores y publicados).
$articulos = $datos['articulos'] ?? [];
?>
<h1>Administración</h1>

<p><a href="/admin/articulos/nuevo">+ Nuevo artículo</a></p>

<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>ID</th><th>Título</th><th>Estado</th><th>Comentarios</th><th>Acciones</th></tr>
    <?php foreach ($articulos as $articulo): ?>
        <tr>
            <td><?= (int) $articulo['id'] ?></td>
            <td><?= htmlspecialchars($articulo['titulo']) ?></td>
            <td><?= $articulo['publicado'] ? 'Publicado' : 'Borrador' ?></td>
            <td><?= (int) $articulo['comentarios'] ?></td>
            <td>
                <a href="/admin/articulos/<?= (int) $articulo['id'] ?>/editar">Editar</a>
                <form method="post" action="/admin/articulos/<?= (int) $articulo['id'] ?>/eliminar"
                      onsubmit="return confirm('¿Eliminar?');" style="display:inline;">
                    <button type="submit">Eliminar</button>
                </form>
            </td>
        </tr>
    <?php endforeach; ?>
</table>