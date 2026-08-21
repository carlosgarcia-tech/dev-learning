CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO usuarios (nombre, email) VALUES
    ('Ana Perez', 'ana@email.com'),
    ('Juan Garcia', 'juan@email.com');
