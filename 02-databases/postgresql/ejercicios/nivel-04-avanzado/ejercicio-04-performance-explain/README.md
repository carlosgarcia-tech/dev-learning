# Ejercicio 04 — Performance con EXPLAIN

- **Nivel:** 4/5
- **Tema:** Avanzado de PostgreSQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Analizar una consulta con EXPLAIN ANALYZE
2. Crear índices que la optimicen
3. Comparar el plan antes y después

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

`pg_stat_statements` (usado en el material original para listar las consultas más lentas) requiere `shared_preload_libraries` configurado a nivel de servidor, algo que no se puede activar desde dentro de un script `-f`; se deja fuera de `solucion.sql` y se documenta como paso de configuración manual en 05-administracion.md.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT u.nombre, COUNT(p.id) AS total_prestamos
FROM usuarios u
INNER JOIN prestamos p ON u.id = p.usuario_id
WHERE p.fecha_prestamo >= '2024-01-01'
GROUP BY u.id, u.nombre
ORDER BY total_prestamos DESC;

CREATE INDEX idx_prestamos_fecha ON prestamos(fecha_prestamo);
CREATE INDEX idx_prestamos_usuario_fecha ON prestamos(usuario_id, fecha_prestamo);

EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT * FROM prestamos
WHERE usuario_id = 1 AND fecha_prestamo >= '2024-01-01';
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-04-avanzado/ejercicio-04-performance-explain
bash test.sh
```
