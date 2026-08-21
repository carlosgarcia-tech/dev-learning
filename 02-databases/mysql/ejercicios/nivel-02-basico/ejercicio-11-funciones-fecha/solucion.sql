(SELECT id, CAST(YEAR(fecha) AS CHAR) AS anio FROM pedidos ORDER BY id)
UNION ALL
(SELECT id, CAST(MONTH(fecha) AS CHAR) AS mes FROM pedidos ORDER BY id);
