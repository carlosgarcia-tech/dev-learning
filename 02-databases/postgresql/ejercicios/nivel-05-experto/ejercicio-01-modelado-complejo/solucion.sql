CREATE SCHEMA ventas;

CREATE TABLE ventas.clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE ventas.proveedores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE ventas.categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    parent_id INT REFERENCES ventas.categorias(id)
);

CREATE TABLE ventas.productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10,2) NOT NULL CHECK (precio_base >= 0),
    categoria_id INT REFERENCES ventas.categorias(id),
    proveedor_id INT REFERENCES ventas.proveedores(id),
    stock_minimo INT DEFAULT 0,
    stock_actual INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ventas.pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES ventas.clientes(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pendiente'
        CHECK (estado IN ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado')),
    subtotal DECIMAL(10,2) DEFAULT 0,
    descuento DECIMAL(5,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    notas TEXT
);

CREATE TABLE ventas.detalle_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES ventas.pedidos(id) ON DELETE CASCADE,
    producto_id INT NOT NULL REFERENCES ventas.productos(id),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_linea DECIMAL(5,2) DEFAULT 0
);

CREATE TABLE ventas.movimientos_inventario (
    id SERIAL PRIMARY KEY,
    producto_id INT NOT NULL REFERENCES ventas.productos(id),
    tipo VARCHAR(20) CHECK (tipo IN ('entrada', 'salida', 'ajuste')),
    cantidad INT NOT NULL,
    motivo TEXT,
    referencia_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50)
);

CREATE INDEX idx_pedidos_cliente ON ventas.pedidos(cliente_id);
CREATE INDEX idx_pedidos_fecha ON ventas.pedidos(fecha);
CREATE INDEX idx_productos_categoria ON ventas.productos(categoria_id);
CREATE INDEX idx_movimientos_producto ON ventas.movimientos_inventario(producto_id);

CREATE VIEW ventas.vista_stock_bajo AS
SELECT p.id, p.codigo, p.nombre, p.stock_actual, p.stock_minimo, pr.nombre AS proveedor
FROM ventas.productos p
INNER JOIN ventas.proveedores pr ON p.proveedor_id = pr.id
WHERE p.stock_actual <= p.stock_minimo;
