# Ejercicio 04 — SELECT Básico

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Obtener todos los libros
2. Obtener título y autor de todos los libros
3. Obtener libros del género 'Fantasia'
4. Obtener autores colombianos
5. Obtener préstamos activos (sin fecha_devolucion)

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Todos los libros
SELECT * FROM libros;

-- Titulo y autor
SELECT l.titulo, a.nombre AS autor
FROM libros l
INNER JOIN autores a ON l.autor_id = a.id;

-- Libros de fantasia
SELECT * FROM libros WHERE genero = 'Fantasia';

-- Autores colombianos
SELECT * FROM autores WHERE nacionalidad = 'Colombiana';

-- Prestamos activos
SELECT * FROM prestamos WHERE fecha_devolucion IS NULL;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-04-select-basico
bash test.sh
```
