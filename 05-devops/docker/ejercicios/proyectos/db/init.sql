-- db/init.sql — esquema inicial de la base de datos de tareas
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO tasks (title) VALUES ('Tarea de ejemplo'), ('Otra tarea') ON CONFLICT DO NOTHING;
