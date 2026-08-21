# Ejercicio 06 — Roles y Permisos

- **Nivel:** 4/5
- **Tema:** Avanzado de PostgreSQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crear roles `administrador`, `bibliotecario` y `usuario_lector`
2. Asignar permisos según el rol
3. Crear un usuario de ejemplo y asignarle un rol

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

Contraseñas en texto plano solo para practicar en local; nunca las uses así en un entorno real. Se envolvió la creación de roles en `DO $$ ... IF NOT EXISTS ...` porque `CREATE ROLE` no admite `IF NOT EXISTS` de forma nativa y, sin esa comprobación, volver a correr el script fallaría con 'el rol ya existe'.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
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
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-04-avanzado/ejercicio-06-roles-y-permisos
bash test.sh
```
