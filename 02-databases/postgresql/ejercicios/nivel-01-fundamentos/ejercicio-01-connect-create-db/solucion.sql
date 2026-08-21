-- Crear esquema
CREATE SCHEMA IF NOT EXISTS biblioteca;

-- Crear tabla mínima dentro del esquema
CREATE TABLE biblioteca.configuracion (
    clave VARCHAR(50) PRIMARY KEY,
    valor VARCHAR(200) NOT NULL
);

-- Insertar un registro de ejemplo
INSERT INTO biblioteca.configuracion (clave, valor)
VALUES ('nombre_biblioteca', 'Biblioteca Municipal');
