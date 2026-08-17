# Ejercicio 06 — Normalización

- **Nivel:** 3/5
- **Tema:** Diseño de esquema, 1FN, 2FN, 3FN
- **Tiempo estimado:** 25 min

## Enunciado

Tienes una tabla desnormalizada `pedidos_planos` con datos repetidos:

```sql
CREATE TABLE pedidos_planos (
    pedido_id INTEGER,
    cliente_nombre TEXT,
    cliente_email TEXT,
    producto TEXT,
    cantidad INTEGER,
    precio_unitario REAL,
    categoria TEXT
);

INSERT INTO pedidos_planos VALUES
    (1, 'Ana', 'ana@example.com', 'Teclado', 2, 45.00, 'informatica'),
    (1, 'Ana', 'ana@example.com', 'Mouse', 1, 19.90, 'informatica'),
    (2, 'Luis', 'luis@example.com', 'Monitor', 1, 149.00, 'informatica');
```

Tu tarea es **diseñar un esquema normalizado en 3FN**:

1. Escribe los `CREATE TABLE` para: `clientes`, `productos`, `pedidos` y `pedidos_productos` (tabla intermedia), aplicando **1FN** (sin grupos repetidos), **2FN** (sin dependencias parciales) y **3FN** (sin dependencias transitivas: el email del cliente y la categoría del producto no deben vivir en la misma tabla).
2. Escribe los `INSERT` correspondientes para migrar los datos del ejemplo (2 clientes, 2 pedidos, 3 productos, 3 líneas de pedido).

No es necesario ejecutar una consulta final, pero verifica que cada tabla tiene `PRIMARY KEY` y `FOREIGN KEY` coherentes.

## Schema inicial

Parte del ejercicio de la tabla `pedidos_planos` de arriba (ya incluida).

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `clientes` → `id`, `nombre`, `email`. `productos` → `id`, `nombre`, `precio`, `categoria`.
- Pista 2: `pedidos` → `id`, `cliente_id` (FK). `pedidos_productos` → `pedido_id`, `producto_id`, `cantidad` (con `PRIMARY KEY (pedido_id, producto_id)`).
- Pista 3: En 3FN, `categoria` depende de `producto`, no del pedido. El `email` depende del cliente, no del pedido.
- Pista 4: Los `INSERT` deben respetar las FK: primero clientes y productos, luego pedidos y líneas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Esquema normalizado en 3FN
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio_unitario REAL NOT NULL,
    categoria TEXT
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE pedidos_productos (
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 2. Migración de datos
INSERT INTO clientes (id, nombre, email) VALUES
    (1, 'Ana', 'ana@example.com'),
    (2, 'Luis', 'luis@example.com');

INSERT INTO productos (id, nombre, precio_unitario, categoria) VALUES
    (1, 'Teclado', 45.00, 'informatica'),
    (2, 'Mouse', 19.90, 'informatica'),
    (3, 'Monitor', 149.00, 'informatica');

INSERT INTO pedidos (id, cliente_id) VALUES
    (1, 1),
    (2, 2);

INSERT INTO pedidos_productos (pedido_id, producto_id, cantidad) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 3, 1);
````

</details>