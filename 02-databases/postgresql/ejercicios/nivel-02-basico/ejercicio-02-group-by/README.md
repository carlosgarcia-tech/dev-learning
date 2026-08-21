# Ejercicio 02 — GROUP BY

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Cantidad de libros por género
2. Libros por autor
3. Préstamos por usuario

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

Se reemplazó `COUNT(CASE WHEN ... THEN 1 END)` por `COUNT(*) FILTER (WHERE ...)`, la forma idiomática en PostgreSQL (más legible y evaluada igual de eficiente).
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT genero, COUNT(*) AS total_libros, SUM(cantidad) AS total_ejemplares
FROM libros
GROUP BY genero
ORDER BY total_libros DESC;

SELECT a.nombre AS autor, COUNT(l.id) AS total_libros, AVG(l.anio) AS anio_promedio
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
GROUP BY a.id, a.nombre
ORDER BY total_libros DESC;

SELECT
    u.nombre AS usuario,
    COUNT(p.id) AS total_prestamos,
    COUNT(*) FILTER (WHERE p.fecha_devolucion IS NULL) AS activos,
    COUNT(*) FILTER (WHERE p.fecha_devolucion IS NOT NULL) AS devueltos
FROM usuarios u
LEFT JOIN prestamos p ON u.id = p.usuario_id
GROUP BY u.id, u.nombre
ORDER BY total_prestamos DESC;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-02-group-by
bash test.sh
```
