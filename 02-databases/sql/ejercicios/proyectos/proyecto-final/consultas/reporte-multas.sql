-- Multas totales por usuario
SELECT
    u.nombre,
    u.email,
    COUNT(CASE WHEN p.multa > 0 THEN 1 END) AS prestamos_con_multa,
    COALESCE(SUM(p.multa), 0) AS multas_totales
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre, u.email
HAVING COALESCE(SUM(p.multa), 0) > 0
ORDER BY multas_totales DESC, u.nombre;
