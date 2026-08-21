CREATE VIEW vw_productos_caros AS
  SELECT id, nombre, precio FROM productos WHERE precio > 100;

SELECT * FROM vw_productos_caros ORDER BY precio DESC;
