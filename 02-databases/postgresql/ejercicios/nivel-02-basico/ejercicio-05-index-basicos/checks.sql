DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_usuarios_email') THEN
        RAISE EXCEPTION 'Falta idx_usuarios_email';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_libros_isbn') THEN
        RAISE EXCEPTION 'Falta idx_libros_isbn';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_prestamos_usuario_fecha') THEN
        RAISE EXCEPTION 'Falta idx_prestamos_usuario_fecha';
    END IF;
    RAISE NOTICE 'OK: los 3 indices existen';
END $$;
