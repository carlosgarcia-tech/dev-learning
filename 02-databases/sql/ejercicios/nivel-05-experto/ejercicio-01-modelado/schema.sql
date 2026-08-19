-- Modelo de datos de un e-commerce (compatible con SQLite).
-- Cada tabla modela una entidad del dominio y sus relaciones:
--   categorias/proveedores/productos (1:N), clientes/direcciones (1:N),
--   clientes/metodos_pago (1:N), pedidos/detalle_pedido (1:N),
--   pedidos/seguimiento_pedido (1:N) y carrito (N:N clientes-productos).

CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    parent_id INTEGER REFERENCES categorias(id)
);

CREATE TABLE proveedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    contacto TEXT,
    email TEXT,
    telefono TEXT
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio REAL NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id INTEGER REFERENCES categorias(id),
    proveedor_id INTEGER REFERENCES proveedores(id),
    sku TEXT UNIQUE NOT NULL
);

CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    nombre TEXT NOT NULL,
    telefono TEXT,
    fecha_registro TEXT
);

CREATE TABLE direcciones (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    calle TEXT NOT NULL,
    ciudad TEXT NOT NULL,
    codigo_postal TEXT,
    pais TEXT DEFAULT 'España',
    principal INTEGER DEFAULT 0
);

CREATE TABLE metodos_pago (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    tipo TEXT CHECK (tipo IN ('tarjeta', 'paypal', 'transferencia')),
    ultimos_digitos TEXT,
    token TEXT,
    activo INTEGER DEFAULT 1
);

CREATE TABLE carrito (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    fecha_agregado TEXT
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    direccion_id INTEGER NOT NULL REFERENCES direcciones(id),
    metodo_pago_id INTEGER NOT NULL REFERENCES metodos_pago(id),
    fecha TEXT,
    total REAL NOT NULL DEFAULT 0,
    estado TEXT CHECK (estado IN ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado'))
);

CREATE TABLE detalle_pedido (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL CHECK (precio_unitario >= 0)
);

CREATE TABLE seguimiento_pedido (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos(id),
    estado TEXT,
    fecha TEXT,
    notas TEXT
);

INSERT INTO categorias (id, nombre, descripcion, parent_id) VALUES
    (1, 'Electrónica', 'Productos electrónicos', NULL),
    (2, 'Hogar', 'Artículos para el hogar', NULL),
    (3, 'Informática', 'Periféricos y equipos', 1);

INSERT INTO proveedores (id, nombre, contacto, email, telefono) VALUES
    (1, 'TechSource', 'Laura Gómez', 'ventas@techsource.com', '910000001'),
    (2, 'HomeCenter', 'Pedro Ruiz', 'contacto@homecenter.com', '910000002');

INSERT INTO productos (id, nombre, descripcion, precio, stock, categoria_id, proveedor_id, sku) VALUES
    (1, 'Portátil Pro', 'Portátil 15.6" 16GB RAM', 1299.99, 15, 3, 1, 'SKU-PRO-001'),
    (2, 'Monitor 27"', 'Monitor IPS 2K', 299.99, 25, 3, 1, 'SKU-MON-001'),
    (3, 'Teclado Mecánico', 'Teclado mecánico RGB', 89.99, 50, 3, 1, 'SKU-TEC-001'),
    (4, 'Robot Aspirador', 'Aspirador automático', 499.99, 8, 2, 2, 'SKU-ROB-001'),
    (5, 'Cafetera', 'Cafetera espresso', 129.99, 20, 2, 2, 'SKU-CAF-001');

INSERT INTO clientes (id, email, password_hash, nombre, telefono, fecha_registro) VALUES
    (1, 'ana@email.com', 'hash_ana', 'Ana Pérez', '600111222', '2024-01-05'),
    (2, 'juan@email.com', 'hash_juan', 'Juan García', '600333444', '2024-02-10');

INSERT INTO direcciones (id, cliente_id, calle, ciudad, codigo_postal, pais, principal) VALUES
    (1, 1, 'Calle Mayor 1', 'Madrid', '28001', 'España', 1),
    (2, 1, 'Calle Sol 5', 'Valencia', '46001', 'España', 0),
    (3, 2, 'Avenida Central 10', 'Barcelona', '08001', 'España', 1);

INSERT INTO metodos_pago (id, cliente_id, tipo, ultimos_digitos, token, activo) VALUES
    (1, 1, 'tarjeta', '4242', 'tok_ana_1', 1),
    (2, 1, 'paypal', NULL, 'tok_paypal_ana', 1),
    (3, 2, 'tarjeta', '1111', 'tok_juan_1', 1);

INSERT INTO carrito (id, cliente_id, producto_id, cantidad, fecha_agregado) VALUES
    (1, 1, 3, 2, '2024-03-01'),
    (2, 2, 2, 1, '2024-03-02');

INSERT INTO pedidos (id, cliente_id, direccion_id, metodo_pago_id, fecha, total, estado) VALUES
    (1, 1, 1, 1, '2024-03-05', 1479.97, 'pagado'),
    (2, 1, 1, 2, '2024-04-01', 499.99, 'enviado'),
    (3, 2, 3, 3, '2024-04-10', 299.99, 'entregado'),
    (4, 2, 3, 3, '2024-05-02', 219.98, 'pendiente');

INSERT INTO detalle_pedido (id, pedido_id, producto_id, cantidad, precio_unitario) VALUES
    (1, 1, 1, 1, 1299.99),
    (2, 1, 3, 2, 89.99),
    (3, 2, 4, 1, 499.99),
    (4, 3, 2, 1, 299.99),
    (5, 4, 3, 1, 89.99),
    (6, 4, 5, 1, 129.99);

INSERT INTO seguimiento_pedido (id, pedido_id, estado, fecha, notas) VALUES
    (1, 1, 'pagado', '2024-03-05', 'Pago recibido'),
    (2, 1, 'enviado', '2024-03-06', 'Enviado con GLS'),
    (3, 3, 'entregado', '2024-04-12', 'Entregado al destinatario');