-- Datos del mini CRM (compatible con SQLite).
-- Relaciones: contactos 1:N interacciones, contactos 1:N oportunidades,
-- oportunidades 1:N actividades. Sara Díaz (contacto 6) no tiene
-- interacciones, para demostrar el ordenamiento NULLS FIRST.

CREATE TABLE contactos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE,
    telefono TEXT,
    empresa TEXT,
    cargo TEXT,
    fecha_creacion TEXT
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE interacciones (
    id INTEGER PRIMARY KEY,
    contacto_id INTEGER REFERENCES contactos(id),
    tipo TEXT CHECK (tipo IN ('llamada', 'email', 'reunion', 'nota')),
    fecha TEXT,
    descripcion TEXT,
    duracion INTEGER,
    creado_por INTEGER REFERENCES usuarios(id)
);

CREATE TABLE oportunidades (
    id INTEGER PRIMARY KEY,
    contacto_id INTEGER REFERENCES contactos(id),
    nombre TEXT NOT NULL,
    monto REAL,
    etapa TEXT CHECK (etapa IN ('prospeccion', 'cualificacion', 'propuesta', 'negociacion', 'cerrada_ganada', 'cerrada_perdida')),
    fecha_cierre_estimada TEXT,
    fecha_creacion TEXT
);

CREATE TABLE actividades (
    id INTEGER PRIMARY KEY,
    oportunidad_id INTEGER REFERENCES oportunidades(id),
    tipo TEXT CHECK (tipo IN ('demo', 'propuesta', 'reunion', 'llamada')),
    fecha TEXT,
    descripcion TEXT,
    completada INTEGER DEFAULT 0
);

INSERT INTO contactos (id, nombre, email, telefono, empresa, cargo, fecha_creacion) VALUES
    (1, 'María Fernández', 'maria@acme.com', '600111222', 'Acme Corp', 'Directora', '2024-01-05'),
    (2, 'Pedro Sánchez', 'pedro@beta.com', '600333444', 'Beta SL', 'CTO', '2024-01-20'),
    (3, 'Lucía Ortega', 'lucia@acme.com', '600555666', 'Acme Corp', 'Comercial', '2024-02-05'),
    (4, 'Jorge Vidal', 'jorge@gamma.com', '600777888', 'Gamma SA', 'CEO', '2024-02-20'),
    (5, 'Elena Ruiz', 'elena@delta.com', '600999000', 'Delta Group', 'Jefa de compras', '2024-03-10'),
    (6, 'Sara Díaz', 'sara@kappa.com', '600000111', 'Kappa SL', 'Analista', '2024-03-20');

INSERT INTO usuarios (id, nombre, email) VALUES
    (1, 'Ana Pérez', 'ana@crm.com'),
    (2, 'Luis Torres', 'luis@crm.com');

INSERT INTO interacciones (id, contacto_id, tipo, fecha, descripcion, duracion, creado_por) VALUES
    (1, 1, 'llamada', '2024-01-10', 'Primera llamada', 15, 1),
    (2, 1, 'reunion', '2024-01-20', 'Reunión de propuesta', 60, 1),
    (3, 2, 'email', '2024-02-01', 'Envío de catálogo', NULL, 2),
    (4, 3, 'llamada', '2024-02-10', 'Seguimiento', 10, 1),
    (5, 4, 'reunion', '2024-03-05', 'Demo de producto', 90, 2),
    (6, 5, 'nota', '2024-03-15', 'Interesada en renovación', NULL, 1),
    (7, 1, 'email', '2024-03-25', 'Reenvío de presupuesto', NULL, 1);

INSERT INTO oportunidades (id, contacto_id, nombre, monto, etapa, fecha_cierre_estimada, fecha_creacion) VALUES
    (1, 1, 'Licencia Enterprise', 25000, 'negociacion', '2024-04-30', '2024-01-05'),
    (2, 2, 'Soporte Premium', 8000, 'propuesta', '2024-05-15', '2024-02-01'),
    (3, 3, 'Ampliación licencias', 12000, 'cerrada_ganada', '2024-03-20', '2024-02-10'),
    (4, 4, 'Proyecto piloto', 15000, 'prospeccion', '2024-06-01', '2024-03-05'),
    (5, 5, 'Renovación anual', 5000, 'cerrada_perdida', '2024-04-01', '2024-03-15'),
    (6, 1, 'Formación equipo', 3000, 'cualificacion', '2024-06-15', '2024-03-25'),
    (7, 6, 'Consultoría', 4000, 'propuesta', '2024-07-01', '2024-04-01');

INSERT INTO actividades (id, oportunidad_id, tipo, fecha, descripcion, completada) VALUES
    (1, 1, 'reunion', '2024-01-18', 'Reunión inicial', 1),
    (2, 3, 'demo', '2024-02-12', 'Demo del producto', 1),
    (3, 2, 'propuesta', '2024-02-20', 'Envío de propuesta', 0);