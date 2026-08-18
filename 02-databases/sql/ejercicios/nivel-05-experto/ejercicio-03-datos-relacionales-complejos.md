# Ejercicio 03 — Datos relacionales complejos

- **Nivel:** 5/5
- **Tema:** Varias tablas, relaciones N:M, agregados sobre joins múltiples
- **Tiempo estimado:** 35 min

## Enunciado

Un sistema de **streaming** tiene: `usuarios`, `peliculas`, `generos` y la tabla intermedia `pelicula_generos`. Además, cada usuario deja un `rating` (1-5) por película.

Escribe:

1. Una consulta que muestre **cada rating**: nombre de usuario, título de la película, nota.
2. Una consulta que muestre **la nota media por película** (con alias `media`), ordenada de mayor a menor, mostrando solo las películas con 2 o más valoraciones (usa `HAVING COUNT(*) >= 2`).
3. Una consulta que liste **cada película con todos sus géneros**, concatenando géneros con `GROUP_CONCAT` (SQLite) o `STRING_AGG` (PostgreSQL).

## Schema inicial

```sql
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE generos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE
);

CREATE TABLE peliculas (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL
);

CREATE TABLE pelicula_generos (
    pelicula_id INTEGER,
    genero_id INTEGER,
    PRIMARY KEY (pelicula_id, genero_id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

CREATE TABLE ratings (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER,
    pelicula_id INTEGER,
    nota INTEGER CHECK (nota BETWEEN 1 AND 5),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id)
);

INSERT INTO usuarios (id, nombre) VALUES (1, 'Ana'), (2, 'Luis'), (3, 'Marta');

INSERT INTO generos (id, nombre) VALUES
    (1, 'Acción'), (2, 'Comedia'), (3, 'Drama'), (4, 'Ciencia ficción');

INSERT INTO peliculas (id, titulo) VALUES
    (1, 'El viaje'), (2, 'Risas garantizadas'), (3, 'Futuro lejano');

INSERT INTO pelicula_generos (pelicula_id, genero_id) VALUES
    (1, 3), (1, 1), (2, 2), (3, 4), (3, 1);

INSERT INTO ratings (id, usuario_id, pelicula_id, nota) VALUES
    (1, 1, 1, 5),
    (2, 2, 1, 4),
    (3, 1, 2, 3),
    (4, 3, 3, 5),
    (5, 2, 3, 4),
    (6, 3, 2, 2);
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar
- [ ] Los tests pasan: `bash ejercicio-03-datos-relacionales-complejos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Tres `INNER JOIN` en cadena: `ratings → usuarios` y `ratings → peliculas`.
- Pista 2: Agrega sobre `peliculas`: `AVG(r.nota)`, `GROUP BY p.titulo`, `HAVING COUNT(*) >= 2`.
- Pista 3: SQLite: `GROUP_CONCAT(g.nombre, ', ')`. PostgreSQL: `STRING_AGG(g.nombre, ', ')`. Recuerda `GROUP BY p.id, p.titulo`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Cada rating con usuario y película
SELECT u.nombre AS usuario, p.titulo, r.nota
FROM ratings r
INNER JOIN usuarios u ON u.id = r.usuario_id
INNER JOIN peliculas p ON p.id = r.pelicula_id
ORDER BY p.titulo;

-- 2. Nota media por película (solo con 2+ valoraciones)
SELECT p.titulo, ROUND(AVG(r.nota), 2) AS media, COUNT(*) AS valoraciones
FROM ratings r
INNER JOIN peliculas p ON p.id = r.pelicula_id
GROUP BY p.titulo
HAVING COUNT(*) >= 2
ORDER BY media DESC;

-- 3. Películas con sus géneros (SQLite)
SELECT p.titulo, GROUP_CONCAT(g.nombre, ', ') AS generos
FROM peliculas p
INNER JOIN pelicula_generos pg ON pg.pelicula_id = p.id
INNER JOIN generos g ON g.id = pg.genero_id
GROUP BY p.id, p.titulo;

-- PostgreSQL usa STRING_AGG en vez de GROUP_CONCAT:
-- SELECT p.titulo, STRING_AGG(g.nombre, ', ') AS generos ...
````

</details>