(SELECT categoria, SUM(total) AS total FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, COUNT(*) AS cantidad FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, ROUND(AVG(precio), 2) AS promedio FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, COUNT(*) AS cantidad FROM ventas GROUP BY categoria HAVING COUNT(*) > 1 ORDER BY categoria);
