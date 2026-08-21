# Ejercicio 04 — Optimización de Schema

- **Nivel:** 5/5
- **Tema:** Experto en PostgreSQL
- **Tiempo estimado:** 40 minutos

## Enunciado

1. Detectar tablas con muchos seq_scan y pocos/ningún index_scan
2. Detectar índices sin uso
3. Proponer índices nuevos

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

La consulta original que intentaba generar sugerencias de índices con `regexp_matches` sobre `pg_stat_statements.query` es frágil (depende de que esa extensión esté precargada a nivel de servidor) y el regex no captura de forma fiable columnas reales de un WHERE arbitrario. Se sustituye por el flujo real que usan los DBAs: mirar `pg_stat_user_tables`/`pg_stat_user_indexes` y decidir el índice manualmente.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Genera algo de actividad de lectura para tener estadisticas que analizar
SELECT * FROM prestamos WHERE usuario_id = 1;
SELECT * FROM libros WHERE genero = 'Fantasia';

-- Tablas con muchos seq_scan y pocos index_scan (candidatas a indexar)
-- Nota: pg_stat_user_tables usa "relname", no "tablename" (ese nombre de
-- columna es de pg_tables/pg_indexes, una familia de vistas distinta).
SELECT schemaname, relname AS tabla, seq_scan, seq_tup_read, idx_scan
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- Indices existentes que nunca se han usado
SELECT schemaname, relname AS tabla, indexrelname AS indice, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY relname;

-- Ejemplo de indice sugerido a partir del analisis anterior
CREATE INDEX IF NOT EXISTS idx_libros_genero ON libros(genero);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-05-experto/ejercicio-04-optimizacion-schema
bash test.sh
```
