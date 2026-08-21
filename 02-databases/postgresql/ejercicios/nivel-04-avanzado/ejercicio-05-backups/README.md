# Ejercicio 05 — Backups

- **Nivel:** 4/5
- **Tema:** Avanzado de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Backup completo con pg_dump
2. Backup de solo esquema y de solo datos
3. Restaurar un backup

Estos comandos se ejecutan en la terminal (fuera de una sesión `psql`),
por eso `solucion.sql` aquí es solo documentación y `test.sh` únicamente
verifica que `pg_dump`/`pg_restore` estén disponibles.

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Estos son comandos de shell, no SQL. Se documentan aqui como referencia:
--
-- Backup completo (formato texto plano)
--   pg_dump -U postgres -h localhost -p 5432 mi_biblioteca > backup.sql
--
-- Backup en formato custom (permite restauracion selectiva/paralela)
--   pg_dump -U postgres -Fc mi_biblioteca > backup.dump
--
-- Backup de solo esquema
--   pg_dump -U postgres -s mi_biblioteca > esquema.sql
--
-- Backup de solo datos
--   pg_dump -U postgres -a mi_biblioteca > datos.sql
--
-- Restaurar
--   psql -U postgres mi_biblioteca < backup.sql
--   pg_restore -U postgres -d mi_biblioteca backup.dump
--
-- Backup comprimido
--   pg_dump -U postgres mi_biblioteca | gzip > backup.sql.gz
--   gunzip -c backup.sql.gz | psql -U postgres mi_biblioteca

SELECT 'ver comentarios de este archivo para los comandos de shell' AS nota;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-04-avanzado/ejercicio-05-backups
bash test.sh
```
