DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'administrador') THEN
        RAISE EXCEPTION 'Falta rol administrador';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bibliotecario') THEN
        RAISE EXCEPTION 'Falta rol bibliotecario';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'usuario_lector') THEN
        RAISE EXCEPTION 'Falta rol usuario_lector';
    END IF;
    RAISE NOTICE 'OK: 3 roles creados';
END $$;
