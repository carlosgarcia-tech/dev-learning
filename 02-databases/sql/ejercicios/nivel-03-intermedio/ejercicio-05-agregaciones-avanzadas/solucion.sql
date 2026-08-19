-- Cuartiles de precios
WITH precios_ordenados AS (
    SELECT
        precio,
        ROW_NUMBER() OVER (ORDER BY precio) AS rn,
        COUNT(*) OVER () AS n
    FROM productos
)
SELECT
    MAX(CASE WHEN rn = CAST(ROUND(n * 0.25) AS INTEGER) THEN precio END) AS q1,
    MAX(CASE WHEN rn = CAST(ROUND(n * 0.50) AS INTEGER) THEN precio END) AS mediana,
    MAX(CASE WHEN rn = CAST(ROUND(n * 0.75) AS INTEGER) THEN precio END) AS q3
FROM precios_ordenados;

-- Percentiles
WITH precios_ordenados AS (
    SELECT
        precio,
        ROW_NUMBER() OVER (ORDER BY precio) AS rn,
        COUNT(*) OVER () AS n
    FROM productos
)
SELECT
    MAX(CASE WHEN rn = CAST(ROUND(n * 0.90) AS INTEGER) THEN precio END) AS percentil_90,
    MAX(CASE WHEN rn = CAST(ROUND(n * 0.95) AS INTEGER) THEN precio END) AS percentil_95
FROM precios_ordenados;

-- Desviación estándar
SELECT
    AVG(precio) AS promedio,
    SQRT(AVG(CAST(precio AS REAL) * CAST(precio AS REAL))
         - AVG(CAST(precio AS REAL)) * AVG(CAST(precio AS REAL))) AS desviacion_std,
    SQRT(AVG(CAST(precio AS REAL) * CAST(precio AS REAL))
         - AVG(CAST(precio AS REAL)) * AVG(CAST(precio AS REAL)))
      / AVG(precio) * 100 AS coeficiente_variacion
FROM productos;