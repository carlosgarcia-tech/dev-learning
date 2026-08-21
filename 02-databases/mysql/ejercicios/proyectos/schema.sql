-- ============================================================
-- Proyecto Final: Sistema de Inventario y Ventas (MySQL)
-- schema.sql — Esquema completo de la base de datos
-- ============================================================

-- Categorías de productos
CREATE TABLE categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  creada_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_categoria_nombre (nombre)
) ENGINE=InnoDB;

-- Productos del inventario
CREATE TABLE productos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  descripcion TEXT,
  categoria_id INT UNSIGNED NOT NULL,
  precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  costo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock INT NOT NULL DEFAULT 0,
  stock_minimo INT NOT NULL DEFAULT 5,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_producto_codigo (codigo),
  INDEX idx_producto_nombre (nombre),
  INDEX idx_producto_categoria (categoria_id),
  CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria_id)
    REFERENCES categorias(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Clientes
CREATE TABLE clientes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  email VARCHAR(150),
  telefono VARCHAR(30),
  direccion VARCHAR(300),
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_cliente_email (email),
  INDEX idx_cliente_nombre (nombre)
) ENGINE=InnoDB;

-- Cabecera de ventas
CREATE TABLE ventas (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT UNSIGNED NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  estado ENUM('pendiente', 'pagada', 'enviada', 'cancelada') DEFAULT 'pendiente',
  notas TEXT,
  INDEX idx_venta_cliente (cliente_id),
  INDEX idx_venta_fecha (fecha),
  CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id)
    REFERENCES clientes(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Detalle de ventas (items de cada venta)
CREATE TABLE detalle_ventas (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  venta_id INT UNSIGNED NOT NULL,
  producto_id INT UNSIGNED NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  INDEX idx_detalle_venta (venta_id),
  INDEX idx_detalle_producto (producto_id),
  CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id)
    REFERENCES ventas(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id)
    REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Movimientos de inventario (entradas y salidas)
CREATE TABLE movimientos_inventario (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  producto_id INT UNSIGNED NOT NULL,
  tipo ENUM('entrada', 'salida', 'ajuste') NOT NULL,
  cantidad INT NOT NULL,
  motivo VARCHAR(200),
  referencia VARCHAR(100),
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_mov_producto (producto_id),
  INDEX idx_mov_fecha (fecha),
  CONSTRAINT fk_mov_producto FOREIGN KEY (producto_id)
    REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla de auditoría para cambios en productos
CREATE TABLE auditoria (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tabla VARCHAR(50) NOT NULL,
  registro_id INT UNSIGNED NOT NULL,
  accion VARCHAR(20) NOT NULL,
  descripcion TEXT,
  usuario VARCHAR(100),
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_aud_tabla_registro (tabla, registro_id)
) ENGINE=InnoDB;
