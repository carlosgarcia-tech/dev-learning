# Ejercicio 01 — INNER JOIN

- **Nivel:** 2/5
- **Tema:** INNER JOIN
- **Tiempo estimado:** 15 min

## Enunciado

Dadas las tablas `autores` y `libros`, escribe una consulta que muestre **para cada libro: su título y el nombre de su autor**, usando `INNER JOIN`.

Resultado esperado: 5 filas (cada libro tiene autor). Luego escribe una segunda consulta que cuente **cuántos libros tiene cada autor**, usando `GROUP BY` junto al `INNER JOIN`.

## Schema inicial

```sql
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor_id INTEGER,
    FOREIGN KEY (autor_id) REFERENCES autores(id)
);

INSERT INTO autores (id, nombre) VALUES
    (1, 'Gabriel García'),
    (2, 'Isabel Allende'),
    (3, 'Mario Vargas');

INSERT INTO libros (id, titulo, autor_id) VALUES
    (101, 'Cien años de soledad', 1),
    (102, 'El amor en tiempos de cólera', 1),
    (103, 'La casa de los espíritus', 2),
    (104, 'Eva Luna', 2),
    (105, 'La ciudad y los perros', 3);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `INNER JOIN libros l ON l.autor_id = a.id`.
- Pista 2: Califica las columnas con el alias de tabla para evitar ambigüedad (`a.nombre`, `l.titulo`).
- Pista 3: Para el conteo: `COUNT(l.id)` con `GROUP BY a.nombre`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- Libros con su autor
SELECT l.titulo, a.nombre AS autor
FROM libros l
INNER JOIN autores a ON a.id = l.autor_id;

-- Libros por autor
SELECT a.nombre AS autor, COUNT(l.id) AS num_libros
FROM autores a
INNER JOIN libros l ON l.autor_id = a.id
GROUP BY a.nombre;
````

</details>