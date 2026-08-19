# Ejercicio 18 — Normalización

- **Nivel:** 3/5
- **Tema:** Intermedio de SQL
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Normaliza una tabla no normalizada
2. Crea relaciones 1:N y N:N
3. Aplica reglas de normalización (1FN, 2FN, 3FN)

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Después de normalizar (1FN, 2FN, 3FN)
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER NOT NULL,
    fecha TEXT DEFAULT CURRENT_TIMESTAMP,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL
);

CREATE TABLE detalle_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

SELECT name FROM sqlite_master WHERE type = 'table';
```

</details>
