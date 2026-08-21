WITH prestamos_activos AS (
    SELECT usuario_id, COUNT(*) AS total_activos
    FROM prestamos
    WHERE fecha_devolucion IS NULL
    GROUP BY usuario_id
)
SELECT u.nombre, COALESCE(pa.total_activos, 0) AS prestamos_activos
FROM usuarios u
LEFT JOIN prestamos_activos pa ON u.id = pa.usuario_id
ORDER BY prestamos_activos DESC;

WITH ranking_libros AS (
    SELECT l.id, l.titulo, COUNT(p.id) AS total_prestamos,
           RANK() OVER (ORDER BY COUNT(p.id) DESC) AS ranking
    FROM libros l
    LEFT JOIN prestamos p ON l.id = p.libro_id
    GROUP BY l.id, l.titulo
)
SELECT * FROM ranking_libros WHERE ranking <= 3;

WITH RECURSIVE generos_jerarquia AS (
    SELECT id, nombre, padre_id, 1 AS nivel, nombre::VARCHAR AS ruta
    FROM generos
    WHERE padre_id IS NULL

    UNION ALL

    SELECT g.id, g.nombre, g.padre_id, gj.nivel + 1, gj.ruta || ' > ' || g.nombre
    FROM generos g
    INNER JOIN generos_jerarquia gj ON g.padre_id = gj.id
)
SELECT * FROM generos_jerarquia ORDER BY ruta;
