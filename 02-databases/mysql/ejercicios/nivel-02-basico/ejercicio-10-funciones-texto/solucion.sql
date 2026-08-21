(SELECT UPPER(nombre) AS nombre_mayus, CAST(LENGTH(email) AS CHAR) AS email_len FROM usuarios ORDER BY id)
UNION ALL
(SELECT SUBSTR(nombre, 1, 3) AS iniciales, LOWER(email) AS email_lower FROM usuarios ORDER BY id)
UNION ALL
(SELECT REPLACE(nombre, 'a', '@') AS nombre_mod, nombre FROM usuarios ORDER BY id);
