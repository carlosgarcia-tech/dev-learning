DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'administrador') THEN
        CREATE ROLE administrador LOGIN PASSWORD 'admin123';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bibliotecario') THEN
        CREATE ROLE bibliotecario LOGIN PASSWORD 'biblio123';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'usuario_lector') THEN
        CREATE ROLE usuario_lector LOGIN PASSWORD 'user123';
    END IF;
END $$;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrador;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO administrador;

GRANT SELECT, INSERT, UPDATE ON libros, autores, usuarios, prestamos TO bibliotecario;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO bibliotecario;

GRANT SELECT ON libros, autores, prestamos TO usuario_lector;

ALTER DEFAULT PRIVILEGES FOR ROLE administrador IN SCHEMA public
    GRANT SELECT ON TABLES TO usuario_lector;
