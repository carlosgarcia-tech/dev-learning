SELECT
    (SELECT COUNT(*) FROM autores) AS total_autores,
    (SELECT COUNT(*) FROM libros) AS total_libros,
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM prestamos) AS total_prestamos;

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM autores) < 3 THEN RAISE EXCEPTION 'Faltan autores'; END IF;
    IF (SELECT COUNT(*) FROM libros) < 5 THEN RAISE EXCEPTION 'Faltan libros'; END IF;
    IF (SELECT COUNT(*) FROM usuarios) < 3 THEN RAISE EXCEPTION 'Faltan usuarios'; END IF;
    IF (SELECT COUNT(*) FROM prestamos) < 4 THEN RAISE EXCEPTION 'Faltan prestamos'; END IF;
    RAISE NOTICE 'OK: cantidades minimas cumplidas';
END $$;
