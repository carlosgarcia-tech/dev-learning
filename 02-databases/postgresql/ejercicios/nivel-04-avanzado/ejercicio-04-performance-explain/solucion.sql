EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT u.nombre, COUNT(p.id) AS total_prestamos
FROM usuarios u
INNER JOIN prestamos p ON u.id = p.usuario_id
WHERE p.fecha_prestamo >= '2024-01-01'
GROUP BY u.id, u.nombre
ORDER BY total_prestamos DESC;

CREATE INDEX idx_prestamos_fecha ON prestamos(fecha_prestamo);
CREATE INDEX idx_prestamos_usuario_fecha ON prestamos(usuario_id, fecha_prestamo);

EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT * FROM prestamos
WHERE usuario_id = 1 AND fecha_prestamo >= '2024-01-01';
