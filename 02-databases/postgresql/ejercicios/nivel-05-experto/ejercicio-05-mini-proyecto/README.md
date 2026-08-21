# Ejercicio 05 — Mini Proyecto

- **Nivel:** 5/5
- **Tema:** Experto en PostgreSQL
- **Tiempo estimado:** 60 minutos

## Enunciado

Implementa un sistema de gestión de proyectos: proyectos, tareas,
asignaciones, y una vista/función de métricas.

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE proyectos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(20) DEFAULT 'activo'
);

CREATE TABLE tareas (
    id SERIAL PRIMARY KEY,
    proyecto_id INT REFERENCES proyectos(id),
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    prioridad VARCHAR(10) CHECK (prioridad IN ('baja','media','alta','urgente')),
    estado VARCHAR(20) DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATE
);

CREATE TABLE asignaciones (
    id SERIAL PRIMARY KEY,
    tarea_id INT REFERENCES tareas(id),
    usuario_id INT REFERENCES usuarios(id),
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin) VALUES
    ('Migracion a PostgreSQL', 'Migrar el sistema legado', '2024-01-01', '2024-06-30');

INSERT INTO tareas (proyecto_id, titulo, prioridad, estado, fecha_vencimiento) VALUES
    (1, 'Disenar el esquema', 'alta', 'completada', '2024-01-15'),
    (1, 'Escribir scripts de migracion', 'urgente', 'pendiente', '2024-02-01');

INSERT INTO asignaciones (tarea_id, usuario_id) VALUES (1, 1), (2, 2);

CREATE VIEW vista_proyectos_activos AS
SELECT
    p.id, p.nombre,
    COUNT(DISTINCT t.id) AS total_tareas,
    COUNT(*) FILTER (WHERE t.estado = 'completada') AS tareas_completadas,
    ROUND(
        COUNT(*) FILTER (WHERE t.estado = 'completada')::DECIMAL /
        GREATEST(COUNT(DISTINCT t.id), 1) * 100, 2
    ) AS porcentaje_completado
FROM proyectos p
LEFT JOIN tareas t ON p.id = t.proyecto_id
GROUP BY p.id, p.nombre;

CREATE OR REPLACE FUNCTION obtener_metricas_usuario(p_usuario_id INT)
RETURNS TABLE(
    total_asignadas BIGINT,
    completadas BIGINT,
    pendientes BIGINT,
    vencidas BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*) AS total_asignadas,
        COUNT(*) FILTER (WHERE t.estado = 'completada') AS completadas,
        COUNT(*) FILTER (WHERE t.estado != 'completada') AS pendientes,
        COUNT(*) FILTER (WHERE t.estado != 'completada' AND t.fecha_vencimiento < CURRENT_DATE) AS vencidas
    FROM asignaciones a
    INNER JOIN tareas t ON a.tarea_id = t.id
    WHERE a.usuario_id = p_usuario_id;
END;
$$;

SELECT * FROM vista_proyectos_activos;
SELECT * FROM obtener_metricas_usuario(1);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-05-experto/ejercicio-05-mini-proyecto
bash test.sh
```
