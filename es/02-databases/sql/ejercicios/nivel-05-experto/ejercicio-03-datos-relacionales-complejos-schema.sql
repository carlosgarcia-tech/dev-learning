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