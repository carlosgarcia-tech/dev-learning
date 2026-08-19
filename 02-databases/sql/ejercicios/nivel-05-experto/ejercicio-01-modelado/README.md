# Ejercicio 25 — Modelado

- **Nivel:** 5/5
- **Tema:** Experto en SQL
- **Tiempo estimado:** 45 minutos

## Enunciado

Diseña un modelo de base de datos para un e-commerce con:
- Productos con categorías y proveedores
- Clientes con direcciones y métodos de pago
- Pedidos con estados y seguimiento
- Carrito de compras

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Modelo completo en SQLite (ver schema.sql con los INSERTs de ejemplo).
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
```

Para comprobar que el modelo funciona se consultan las relaciones (ver `solucion.sql`):

```sql
-- Productos con su categoría y proveedor (N:1)
SELECT p.nombre, p.sku, p.precio, p.stock, c.nombre AS categoria, pr.nombre AS proveedor
FROM productos p
INNER JOIN categorias c ON c.id = p.categoria_id
INNER JOIN proveedores pr ON pr.id = p.proveedor_id
ORDER BY p.id;
```

</details>
