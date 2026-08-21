# Ejercicio 04 — Vistas

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Vista de libros disponibles (cantidad > 0)
2. Vista de préstamos activos
3. Vista de reporte por autor

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE VIEW vista_libros_disponibles AS
SELECT l.id, l.titulo, a.nombre AS autor, l.genero, l.cantidad AS ejemplares
FROM libros l
INNER JOIN autores a ON l.autor_id = a.id
WHERE l.cantidad > 0;

CREATE VIEW vista_prestamos_activos AS
SELECT
    p.id, u.nombre AS usuario, u.email, l.titulo AS libro,
    p.fecha_prestamo, CURRENT_DATE - p.fecha_prestamo::DATE AS dias_prestamo
FROM prestamos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN libros l ON p.libro_id = l.id
WHERE p.fecha_devolucion IS NULL;

CREATE VIEW vista_reporte_autores AS
SELECT
    a.nombre AS autor, a.nacionalidad,
    COUNT(l.id) AS total_libros,
    SUM(l.cantidad) AS total_ejemplares,
    AVG(l.anio)::INT AS anio_promedio
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
GROUP BY a.id, a.nombre, a.nacionalidad
ORDER BY total_libros DESC;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-04-vistas
bash test.sh
```
