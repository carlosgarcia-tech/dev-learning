DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'biblioteca') THEN
        RAISE EXCEPTION 'Falta el esquema biblioteca';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM biblioteca.configuracion WHERE clave = 'nombre_biblioteca') THEN
        RAISE EXCEPTION 'Falta el registro de configuracion';
    END IF;
    RAISE NOTICE 'OK: esquema y tabla verificados';
END $$;
