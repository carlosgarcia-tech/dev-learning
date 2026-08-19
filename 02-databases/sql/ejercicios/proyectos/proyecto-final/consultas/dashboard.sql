-- Dashboard general de la biblioteca
SELECT
    (SELECT COUNT(*) FROM libros) AS total_titulos,
    (SELECT SUM(cantidad_total) FROM libros) AS ejemplares_totales,
    (SELECT SUM(cantidad_disponible) FROM libros) AS ejemplares_disponibles,
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM prestamos WHERE estado IN ('activo', 'retrasado')) AS prestamos_activos,
    (SELECT COUNT(*) FROM prestamos WHERE estado = 'retrasado') AS prestamos_retrasados,
    (SELECT COALESCE(SUM(multa), 0) FROM prestamos) AS multas_acumuladas;

-- Disponibilidad por género
SELECT * FROM vista_disponibilidad_genero ORDER BY genero;
