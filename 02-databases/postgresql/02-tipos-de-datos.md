# 02 — Tipos de Datos Especiales en PostgreSQL

## Objetivos

- [ ] Usar tipos de datos JSON y JSONB
- [ ] Trabajar con arrays
- [ ] Usar tipos de datos geométricos
- [ ] Trabajar con rangos
- [ ] Usar tipos de datos de red
- [ ] Crear tipos de datos personalizados
- [ ] Usar enumeraciones

## Apuntes

### JSON y JSONB

```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    especificaciones JSON,
    metadata JSONB
);

INSERT INTO productos (nombre, especificaciones, metadata)
VALUES (
    'Laptop',
    '{"procesador": "Intel i7", "ram": 16, "almacenamiento": "512GB SSD"}',
    '{"creado": "2024-01-01", "actualizado": "2024-01-15", "version": 1}'
);

SELECT nombre, especificaciones->>'procesador' AS procesador FROM productos;

SELECT * FROM productos WHERE especificaciones @> '{"ram": 16}';
SELECT * FROM productos WHERE metadata ? 'creado';
SELECT * FROM productos WHERE especificaciones->>'ram' = '16';

UPDATE productos
SET metadata = jsonb_set(metadata, '{version}', '2')
WHERE nombre = 'Laptop';

CREATE INDEX idx_productos_especificaciones ON productos USING GIN (especificaciones);
```

> `JSON` guarda el texto tal cual (reprocesa en cada lectura); `JSONB` lo
> guarda en formato binario, permite indexar con GIN y es normalmente la
> opción recomendada salvo que necesites preservar el orden/formato exacto
> del texto original.

### Arrays

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    productos_ids INTEGER[],
    cantidades INTEGER[],
    etiquetas TEXT[]
);

INSERT INTO pedidos (productos_ids, cantidades, etiquetas)
VALUES (ARRAY[1, 2, 3], ARRAY[2, 1, 3], ARRAY['urgente', 'pago_contraentrega']);

INSERT INTO pedidos (productos_ids, cantidades)
VALUES ('{4, 5, 6}', '{1, 1, 2}');

SELECT * FROM pedidos WHERE productos_ids @> ARRAY[1, 3]; -- contiene ambos
SELECT * FROM pedidos WHERE productos_ids && ARRAY[2, 5]; -- contiene alguno

SELECT unnest(productos_ids) AS producto_id FROM pedidos;

CREATE INDEX idx_pedidos_productos ON pedidos USING GIN (productos_ids);
```

### Rangos

```sql
CREATE TABLE promociones (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    periodo DATERANGE,
    descuento DECIMAL(5,2)
);

INSERT INTO promociones (nombre, periodo, descuento)
VALUES ('Descuento verano', '[2024-06-01, 2024-08-31]', 15.00);

SELECT * FROM promociones WHERE periodo @> '2024-07-15'::DATE;
SELECT * FROM promociones WHERE periodo && '[2024-05-01, 2024-07-01]'::DATERANGE;

-- Tipos de rango disponibles: INT4RANGE, INT8RANGE, NUMRANGE, TSRANGE, TSTZRANGE, DATERANGE
```

### Tipos geométricos

```sql
CREATE TABLE tiendas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    ubicacion POINT,
    direccion TEXT
);

-- POINT(x, y) usa (longitud, latitud) o (x, y) según tu convención; sé
-- consistente en todo el esquema para no mezclar los ejes.
INSERT INTO tiendas (nombre, ubicacion) VALUES ('Tienda Norte', POINT(-3.7033, 40.4167));

-- Distancia entre dos puntos con el operador <->
SELECT nombre, ubicacion <-> POINT(-3.7033, 40.4167) AS distancia
FROM tiendas
ORDER BY distancia
LIMIT 5;

-- Tipos geométricos disponibles: POINT, LINE, LSEG, BOX, PATH, POLYGON, CIRCLE
-- Para trabajo geoespacial serio (coordenadas reales, proyecciones, distancias
-- en metros) usa la extensión PostGIS en vez de los tipos geométricos nativos.
```

### Enumeraciones

```sql
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado');
CREATE TYPE prioridad AS ENUM ('baja', 'media', 'alta', 'urgente');

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    estado estado_pedido DEFAULT 'pendiente',
    prioridad prioridad DEFAULT 'media'
);

INSERT INTO pedidos (estado, prioridad) VALUES ('pagado', 'alta');

ALTER TYPE estado_pedido ADD VALUE 'devuelto'; -- PostgreSQL 12+

SELECT enum_range(NULL::estado_pedido);
```

### Tipos de red

```sql
CREATE TABLE servidores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    ip_direccion INET,
    mascara CIDR,
    mac_address MACADDR
);

INSERT INTO servidores (nombre, ip_direccion, mascara, mac_address)
VALUES ('Servidor Web', '192.168.1.100', '192.168.1.0/24', '08:00:2b:01:02:03');

SELECT * FROM servidores WHERE ip_direccion << '192.168.1.0/24'; -- dentro de la red
SELECT * FROM servidores WHERE ip_direccion >> '192.168.1.0/24'; -- contiene la red
```

### Tipo UUID

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- provee gen_random_uuid()

CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100)
);

INSERT INTO usuarios (nombre) VALUES ('Ana Pérez');

CREATE TABLE sesiones (
    id SERIAL PRIMARY KEY,
    usuario_id UUID REFERENCES usuarios(id),
    token VARCHAR(255)
);
```

> En PostgreSQL 13+, `gen_random_uuid()` viene con la extensión `pgcrypto`
> (y desde PG13 también sin extensión, como función incorporada). La
> extensión histórica `uuid-ossp` (`uuid_generate_v4()`) también funciona
> pero ya no es necesaria en versiones recientes.

### Tipos de datos personalizados (compuestos)

```sql
CREATE TYPE direccion AS (
    calle VARCHAR(100),
    ciudad VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(50)
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    direccion direccion
);

INSERT INTO clientes (nombre, direccion)
VALUES ('Ana Pérez', ROW('Calle Mayor 1', 'Madrid', '28001', 'España')::direccion);

SELECT nombre, (direccion).calle, (direccion).ciudad FROM clientes;
```

## Ejercicios relacionados

- [Ejercicio 15: JSONB](./ejercicios/nivel-03-intermedio/ejercicio-03-jsonb/)
- [Ejercicio 16: Full-Text Search](./ejercicios/nivel-03-intermedio/ejercicio-04-full-text-search/)
