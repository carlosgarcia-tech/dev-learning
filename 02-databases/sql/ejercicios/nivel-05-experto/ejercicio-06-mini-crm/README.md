# Ejercicio 30 — Mini CRM

- **Nivel:** 5/5
- **Tema:** Experto en SQL
- **Tiempo estimado:** 60 minutos

## Enunciado

Desarrolla un sistema CRM completo con:
- Gestión de contactos
- Interacciones (llamadas, emails, reuniones)
- Oportunidades de negocio
- Seguimiento de ventas
- Dashboard de indicadores

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Modelo en SQLite (ver schema.sql con los INSERTs de ejemplo).
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

-- Dashboard como vista. SQLite no tiene CURRENT_DATE - INTERVAL;
-- la ventana de 30 días se expresa con un literal de fecha (determinista).
CREATE VIEW vista_dashboard_crm AS
SELECT
    (SELECT COUNT(*) FROM contactos) AS total_contactos,
    (SELECT COUNT(DISTINCT empresa) FROM contactos) AS total_empresas,
    (SELECT COUNT(*) FROM oportunidades WHERE etapa = 'cerrada_ganada') AS ventas_cerradas,
    ROUND(COALESCE((SELECT SUM(monto) FROM oportunidades WHERE etapa = 'cerrada_ganada'), 0), 2) AS total_ventas,
    (SELECT COUNT(*) FROM interacciones WHERE fecha > '2024-03-01') AS interacciones_30d;

-- Consulta de seguimiento: oportunidades activas por contacto, con el
-- número y la fecha de su última interacción. Los contactos sin interacción
-- aparecen primero (NULLS FIRST, soportado por SQLite 3.30+).
SELECT
    c.nombre,
    c.empresa,
    o.nombre AS oportunidad,
    o.etapa,
    ROUND(o.monto, 2) AS monto,
    (SELECT COUNT(*) FROM interacciones WHERE contacto_id = c.id) AS total_interacciones,
    (SELECT MAX(fecha) FROM interacciones WHERE contacto_id = c.id) AS ultima_interaccion
FROM contactos c
INNER JOIN oportunidades o ON c.id = o.contacto_id
WHERE o.etapa NOT IN ('cerrada_ganada', 'cerrada_perdida')
ORDER BY ultima_interaccion NULLS FIRST, c.nombre, o.id;
```

</details>
