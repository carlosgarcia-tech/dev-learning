DO $$
BEGIN
    PERFORM 1 FROM information_schema.tables WHERE table_name = 'autores';
    IF NOT FOUND THEN RAISE EXCEPTION 'Falta tabla autores'; END IF;
    PERFORM 1 FROM information_schema.tables WHERE table_name = 'libros';
    IF NOT FOUND THEN RAISE EXCEPTION 'Falta tabla libros'; END IF;
    PERFORM 1 FROM information_schema.tables WHERE table_name = 'usuarios';
    IF NOT FOUND THEN RAISE EXCEPTION 'Falta tabla usuarios'; END IF;
    PERFORM 1 FROM information_schema.tables WHERE table_name = 'prestamos';
    IF NOT FOUND THEN RAISE EXCEPTION 'Falta tabla prestamos'; END IF;
    RAISE NOTICE 'OK: las 4 tablas existen';
END $$;
