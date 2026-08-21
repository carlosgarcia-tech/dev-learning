# Ejercicio 06 — SHOW y DESCRIBE

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 15 minutos

## Enunciado

La tabla `libros` ya existe con datos. Escribe consultas de inspección con `SHOW` y `DESCRIBE`.

1. Muestra el `nombre` y `autor` de todos los libros (consulta normal con SELECT).
2. Haz `SELECT COUNT(*) AS total FROM libros;` para ver cuántos hay.

> Nota: `SHOW TABLES`, `DESCRIBE` y `SHOW CREATE TABLE` son comandos de metadata
> cuya salida varía entre MySQL y SQLite, por lo que el test valida únicamente las
> dos consultas SELECT anteriores.

## Requisitos

- [ ] `solucion.sql` contiene un SELECT de datos y un SELECT COUNT
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `SELECT nombre, autor FROM libros ORDER BY id;` lista los libros.
- `SELECT COUNT(*) AS total FROM libros;` cuenta las filas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT nombre, autor FROM libros ORDER BY id;
SELECT COUNT(*) AS total FROM libros;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-06-show-describe
bash test.sh
```
