# Ejercicio 01 — Joins múltiples

- **Nivel:** 3/5
- **Tema:** Varios INNER JOIN, muchas-a-muchas, tabla intermedia
- **Tiempo estimado:** 20 min

## Enunciado

Dadas las tablas `estudiantes`, `cursos` y la tabla intermedia `matriculas`, escribe:

1. Una consulta que muestre **cada matrícula**: nombre del estudiante, título del curso y nota.
2. Una consulta que muestre el **número de estudiantes matriculados por curso** (usa `GROUP BY` con el join).

Resultado esperado: la consulta 1 devuelve 6 filas, la consulta 2 devuelve 3 cursos con sus conteos.

## Schema inicial

```sql
CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE cursos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL
);

CREATE TABLE matriculas (
    estudiante_id INTEGER,
    curso_id INTEGER,
    nota REAL,
    PRIMARY KEY (estudiante_id, curso_id),
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

INSERT INTO estudiantes (id, nombre) VALUES
    (1, 'Ana'),
    (2, 'Luis'),
    (3, 'Marta'),
    (4, 'Carlos');

INSERT INTO cursos (id, titulo) VALUES
    (10, 'SQL desde cero'),
    (11, 'Bases de datos'),
    (12, 'Programación');

INSERT INTO matriculas (estudiante_id, curso_id, nota) VALUES
    (1, 10, 8.5),
    (1, 11, 7.0),
    (2, 10, 6.5),
    (3, 11, 9.0),
    (3, 12, 8.0),
    (4, 10, 5.5);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Encadena dos `INNER JOIN`: `estudiantes → matriculas → cursos`.
- Pista 2: `FROM cursos c JOIN matriculas m ON m.curso_id = c.id JOIN estudiantes e ON e.id = m.estudiante_id`.
- Pista 3: Para el conteo, `COUNT(m.estudiante_id)` agrupando por `c.titulo`.
- Pista 4: Da alias a cada tabla (`e`, `c`, `m`) para no repetir nombres largos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Cada matrícula con estudiante y curso
SELECT e.nombre AS estudiante, c.titulo AS curso, m.nota
FROM matriculas m
INNER JOIN estudiantes e ON e.id = m.estudiante_id
INNER JOIN cursos c ON c.id = m.curso_id
ORDER BY c.titulo, e.nombre;

-- 2. Número de matriculados por curso
SELECT c.titulo AS curso, COUNT(m.estudiante_id) AS matriculados
FROM cursos c
INNER JOIN matriculas m ON m.curso_id = c.id
GROUP BY c.titulo
ORDER BY matriculados DESC;
````

</details>