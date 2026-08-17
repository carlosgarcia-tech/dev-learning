-- ============================================================
-- PROYECTO FINAL — Sistema de e-commerce (SQLite)
-- schema.sql: estructura del sistema (tablas, constraints, claves)
-- ============================================================

PRAGMA foreign_keys = ON;

-- Clientes registrados en la tienda
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    telefono TEXT,
    ciudad TEXT NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Catálogo de productos con su stock actual
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    categoria TEXT NOT NULL,
    precio REAL NOT NULL CHECK (precio > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))
);

-- Pedidos: cada pedido pertenece a un cliente y está en un estado
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    estado TEXT NOT NULL DEFAULT 'pendiente'
        CHECK (estado IN ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado')),
    total REAL NOT NULL DEFAULT 0 CHECK (total >= 0),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Líneas de pedido (relación N:M entre pedidos y productos)
CREATE TABLE detalle_pedidos (
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (pedido_id, producto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Pagos asociados a los pedidos
CREATE TABLE pagos (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL,
    metodo TEXT NOT NULL CHECK (metodo IN ('tarjeta', 'transferencia', 'efectivo', 'paypal')),
    monto REAL NOT NULL CHECK (monto > 0),
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

-- Trazabilidad del inventario (entradas, salidas y ajustes)
CREATE TABLE inventario_movimientos (
    id INTEGER PRIMARY KEY,
    producto_id INTEGER NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('entrada', 'salida', 'ajuste')),
    cantidad INTEGER NOT NULL,
    fecha TEXT NOT NULL DEFAULT (datetime('now')),
    motivo TEXT,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);
