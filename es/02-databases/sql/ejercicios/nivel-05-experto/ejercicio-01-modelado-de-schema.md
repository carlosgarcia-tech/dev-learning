# Ejercicio 01 — Modelado de schema

- **Nivel:** 5/5
- **Tema:** Diseño de bases de datos, relaciones, integridad referencial
- **Tiempo estimado:** 30 min

## Enunciado

Diseña el **schema completo** de una biblioteca con las siguientes reglas de negocio:

- Una **biblioteca** tiene muchos **libros**. Cada libro tiene un ISBN único, título, autor y año de publicación.
- Los libros se agrupan en **categorías** (un libro pertenece a una categoría, una categoría tiene muchos libros).
- Un **socio** (id, nombre, email único, fecha de alta) puede tomar prestados libros.
- Un **préstamo** relaciona un socio con un libro: fecha de préstamo, fecha de devolución (NULL si aún no lo ha devuelto) y estado (`'prestado'` / `'devuelto'`).

Entregables:

1. Escribe los `CREATE TABLE` con `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL` y valores por defecto donde corresponda.
2. Escribe `INSERT` de ejemplo coherentes (2 categorías, 4 libros, 2 socios, 3 préstamos, uno sin devolver).
3. Escribe una consulta que muestre los libros **actualmente prestados** (sin fecha de devolución) con el nombre del socio.

## Schema inicial

Parte del ejercicio es diseñar el schema desde cero (no hay tabla inicial).

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Relación categoría→libro es 1:N (FK en `libros`). Préstamo es N:M entre socios y libros (la tabla `prestamos` lleva ambas FKs).
- Pista 2: `estado` puede tener `CHECK (estado IN ('prestado', 'devuelto'))`.
- Pista 3: Los libros prestados son los que tienen `fecha_devolucion IS NULL`.
- Pista 4: Escribe los `INSERT` respetando el orden de las FKs: categorías, libros, socios y por último préstamos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Schema de la biblioteca
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE
);

CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    isbn TEXT NOT NULL UNIQUE,
    titulo TEXT NOT NULL,
    autor TEXT NOT NULL,
    anio INTEGER,
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE socios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INTEGER NOT NULL,
    socio_id INTEGER NOT NULL,
    fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_devolucion DATE,
    estado TEXT NOT NULL DEFAULT 'prestado' CHECK (estado IN ('prestado', 'devuelto')),
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (socio_id) REFERENCES socios(id)
);

-- 2. Datos de ejemplo
INSERT INTO categorias (id, nombre) VALUES (1, 'Novela'), (2, 'Tecnología');

INSERT INTO libros (id, isbn, titulo, autor, anio, categoria_id) VALUES
    (1, '978-1', 'Cien años de soledad', 'Gabriel García', 1967, 1),
    (2, '978-2', 'Don Quijote', 'Cervantes', 1605, 1),
    (3, '978-3', 'SQL para todos', 'Ana López', 2023, 2),
    (4, '978-4', 'Bases de datos', 'Luis Pérez', 2021, 2);

INSERT INTO socios (id, nombre, email) VALUES
    (1, 'Marta', 'marta@example.com'),
    (2, 'Carlos', 'carlos@example.com');

INSERT INTO prestamos (id, libro_id, socio_id, fecha_prestamo, fecha_devolucion, estado) VALUES
    (1, 1, 1, '2024-02-01', '2024-02-15', 'devuelto'),
    (2, 3, 1, '2024-02-20', NULL, 'prestado'),
    (3, 2, 2, '2024-02-21', NULL, 'prestado');

-- 3. Libros actualmente prestados
SELECT l.titulo, s.nombre AS socio, p.fecha_prestamo
FROM prestamos p
INNER JOIN libros l ON l.id = p.libro_id
INNER JOIN socios s ON s.id = p.socio_id
WHERE p.fecha_devolucion IS NULL;
````

</details>