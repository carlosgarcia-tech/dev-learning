-- Usuarios con más préstamos
SELECT
    u.nombre,
    u.email,
    COUNT(p.id) AS total_prestamos,
    COUNT(CASE WHEN p.estado IN ('activo', 'retrasado') THEN 1 END) AS prestamos_activos
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre, u.email
ORDER BY total_prestamos DESC, u.nombre;
