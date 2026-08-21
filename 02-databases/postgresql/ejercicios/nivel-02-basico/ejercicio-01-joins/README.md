# Ejercicio 01 — Joins

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Libros con autores (INNER JOIN)
2. Autores sin libros (LEFT JOIN)
3. Préstamos con usuarios y libros

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT l.titulo, a.nombre AS autor, l.anio, l.genero
FROM libros l
INNER JOIN autores a ON l.autor_id = a.id
ORDER BY a.nombre;

SELECT a.*
FROM autores a
LEFT JOIN libros l ON a.id = l.autor_id
WHERE l.id IS NULL;

SELECT
    p.id, u.nombre AS usuario, l.titulo AS libro,
    p.fecha_prestamo, p.fecha_devolucion,
    CASE WHEN p.fecha_devolucion IS NULL THEN 'Activo' ELSE 'Devuelto' END AS estado
FROM prestamos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN libros l ON p.libro_id = l.id
ORDER BY p.fecha_prestamo DESC;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-01-joins
bash test.sh
```
