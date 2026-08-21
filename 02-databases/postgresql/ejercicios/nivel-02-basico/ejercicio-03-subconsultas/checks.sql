SELECT COUNT(*) FROM libros WHERE anio = (SELECT MAX(anio) FROM libros);
