# Ejercicio 01 — Window Functions

- **Nivel:** 3/5
- **Tema:** Intermedio de PostgreSQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Ranking de libros por año
2. Ranking de libros por año dentro de cada género
3. Préstamos más recientes por usuario

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT titulo, anio, RANK() OVER (ORDER BY anio DESC) AS ranking
FROM libros;

SELECT
    titulo, genero, anio,
    RANK() OVER (PARTITION BY genero ORDER BY anio DESC) AS ranking_genero
FROM libros
ORDER BY genero, ranking_genero;

SELECT
    u.nombre, l.titulo, p.fecha_prestamo,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY p.fecha_prestamo DESC) AS orden
FROM prestamos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN libros l ON p.libro_id = l.id;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-03-intermedio/ejercicio-01-window-functions
bash test.sh
```
