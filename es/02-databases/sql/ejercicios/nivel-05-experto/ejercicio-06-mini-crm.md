# Ejercicio 06 — Mini-CRM

- **Nivel:** 5/5
- **Tema:** Proyecto final: schema completo, datos, consultas de reporte
- **Tiempo estimado:** 60 min

## Enunciado

Construye un **mini-CRM** para gestionar clientes, contactos y oportunidades de venta. Entregables:

1. **Schema completo** con estas tablas y relaciones:
   - `clientes`: id, nombre, email único, telefono, empresa, fecha_alta.
   - `oportunidades`: id, cliente_id (FK), nombre_oportunidad, valor (REAL), estado (`'abierta'`, `'ganada'`, `'perdida'`).
   - `contactos`: id, cliente_id (FK), nombre, cargo, email, telefono.
2. **Datos de ejemplo** coherentes (3 clientes, 4 contactos, 5 oportunidades en distintos estados).
3. **Consultas de reporte**:
   - a) Oportunidades **abiertas** por cliente (nombre del cliente, nombre de la oportunidad y valor).
   - b) **Valor total ganado** por cliente (suma de las oportunidades `'ganada'`).
   - c) Número de **oportunidades por estado**.
   - d) Clientes **sin oportunidades** (usa `LEFT JOIN` con `WHERE ... IS NULL`).

Resultado esperado: la consulta (d) debe mostrar al menos un cliente sin oportunidades.

## Schema inicial

El schema es parte del ejercicio (diseñalo tú). Datos sugeridos al crearlo.

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Escribe `CREATE TABLE` en orden de dependencias: primero `clientes`, luego `contactos` y `oportunidades`.
- Pista 2: Añade `CHECK (estado IN ('abierta', 'ganada', 'perdida'))` a `oportunidades`.
- Pista 3: Para (d): `FROM clientes c LEFT JOIN oportunidades o ON o.cliente_id = c.id WHERE o.id IS NULL`.
- Pista 4: Incluye un cliente sin oportunidades en los datos de ejemplo para que (d) devuelva algo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Schema del mini-CRM
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    telefono TEXT,
    empresa TEXT,
    fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE contactos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    cargo TEXT,
    email TEXT,
    telefono TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE oportunidades (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    nombre_oportunidad TEXT NOT NULL,
    valor REAL NOT NULL,
    estado TEXT NOT NULL DEFAULT 'abierta' CHECK (estado IN ('abierta', 'ganada', 'perdida')),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- 2. Datos de ejemplo
INSERT INTO clientes (id, nombre, email, telefono, empresa) VALUES
    (1, 'Ana Gómez', 'ana@tech.com', '600111222', 'TechCorp'),
    (2, 'Luis Pérez', 'luis@soft.com', '600333444', 'SoftLab'),
    (3, 'Marta Ruiz', 'marta@web.com', '600555666', 'WebAgency');

INSERT INTO contactos (id, cliente_id, nombre, cargo, email, telefono) VALUES
    (1, 1, 'Jorge', 'CTO', 'jorge@tech.com', '611111111'),
    (2, 1, 'Sara', 'CFO', 'sara@tech.com', '611111112'),
    (3, 2, 'Iker', 'CEO', 'iker@soft.com', '611111113'),
    (4, 3, 'Nora', 'Directora', 'nora@web.com', '611111114');

INSERT INTO oportunidades (id, cliente_id, nombre_oportunidad, valor, estado) VALUES
    (1, 1, 'Licencias anuales', 12000, 'ganada'),
    (2, 1, 'Soporte premium', 3000, 'abierta'),
    (3, 2, 'Migración de datos', 8000, 'ganada'),
    (4, 2, 'Formación', 1500, 'perdida'),
    (5, 3, 'Rediseño web', 5000, 'abierta');
-- El cliente 3 tiene oportunidad; para probar (d) añade un cliente sin oportunidades:

-- INSERT INTO clientes (id, nombre, email) VALUES (4, 'Carlos Díaz', 'carlos@data.com');

-- 3. Reportes
-- a) Oportunidades abiertas por cliente
SELECT c.nombre, o.nombre_oportunidad, o.valor
FROM oportunidades o
INNER JOIN clientes c ON c.id = o.cliente_id
WHERE o.estado = 'abierta'
ORDER BY c.nombre;

-- b) Valor total ganado por cliente
SELECT c.nombre, SUM(o.valor) AS valor_ganado
FROM clientes c
INNER JOIN oportunidades o ON o.cliente_id = c.id
WHERE o.estado = 'ganada'
GROUP BY c.nombre
ORDER BY valor_ganado DESC;

-- c) Número de oportunidades por estado
SELECT estado, COUNT(*) AS cantidad
FROM oportunidades
GROUP BY estado
ORDER BY cantidad DESC;

-- d) Clientes sin oportunidades
SELECT c.nombre, c.email
FROM clientes c
LEFT JOIN oportunidades o ON o.cliente_id = c.id
WHERE o.id IS NULL;
````

</details>