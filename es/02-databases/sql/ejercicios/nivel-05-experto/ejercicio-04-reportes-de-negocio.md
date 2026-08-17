# Ejercicio 04 — Reportes de negocio

- **Nivel:** 5/5
- **Tema:** Reportes agregados, ventas por período, KPI
- **Tiempo estimado:** 35 min

## Enunciado

Un comercio quiere reportes de ventas. Dadas las tablas `ventas`, `productos` y `vendedores`, escribe:

1. **Ventas totales por mes**: agrupa por mes/año de `fecha` y muestra suma y número de ventas.
2. **Top 3 productos más vendidos** (por cantidad total vendida).
3. **Comisión por vendedor**: el 8% de sus ventas totales, mostrando nombre y comisión redondeada a 2 decimales.
4. **Día con más ventas**: el día con mayor suma total (usa `ORDER BY` + `LIMIT 1` sobre el agregado).

## Schema inicial

```sql
CREATE TABLE vendedores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL
);

CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    producto_id INTEGER,
    vendedor_id INTEGER,
    cantidad INTEGER NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

INSERT INTO vendedores (id, nombre) VALUES (1, 'Ana'), (2, 'Luis'), (3, 'Marta');

INSERT INTO productos (id, nombre, precio) VALUES
    (1, 'Teclado', 45.00),
    (2, 'Mouse', 19.90),
    (3, 'Monitor', 149.00);

INSERT INTO ventas (id, producto_id, vendedor_id, cantidad, fecha) VALUES
    (1, 1, 1, 2, '2024-01-05'),
    (2, 2, 1, 5, '2024-01-05'),
    (3, 3, 2, 1, '2024-01-06'),
    (4, 1, 2, 1, '2024-02-10'),
    (5, 2, 3, 3, '2024-02-11'),
    (6, 3, 1, 2, '2024-02-12'),
    (7, 1, 3, 1, '2024-03-01'),
    (8, 3, 2, 1, '2024-03-02');
```

## Requisitos

- [ ] La consulta devuelve el resultado esperado
- [ ] Ejecutarlo localmente (SQLite o PostgreSQL) y verificar

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: Usa `strftime('%Y-%m', fecha)` en SQLite o `to_char(fecha, 'YYYY-MM')` en PostgreSQL, con `GROUP BY` de ese mismo expresión.
- Pista 2: Suma `cantidad` con join a `productos`, ordena desc y `LIMIT 3`.
- Pista 3: La comisión se calcula sobre el importe: `cantidad * precio` → `SUM(v.cantidad * p.precio) * 0.08`.
- Pista 4: `GROUP BY fecha`, `ORDER BY total DESC LIMIT 1`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````sql
-- 1. Ventas por mes (SQLite)
SELECT strftime('%Y-%m', fecha) AS mes, COUNT(*) AS ventas, SUM(cantidad) AS unidades
FROM ventas
GROUP BY mes
ORDER BY mes;

-- PostgreSQL: SELECT to_char(fecha, 'YYYY-MM') AS mes, ...

-- 2. Top 3 productos más vendidos (por cantidad)
SELECT p.nombre, SUM(v.cantidad) AS unidades_vendidas
FROM ventas v
INNER JOIN productos p ON p.id = v.producto_id
GROUP BY p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 3;

-- 3. Comisión del 8% por vendedor
SELECT ve.nombre, ROUND(SUM(v.cantidad * p.precio) * 0.08, 2) AS comision
FROM ventas v
INNER JOIN vendedores ve ON ve.id = v.vendedor_id
INNER JOIN productos p ON p.id = v.producto_id
GROUP BY ve.nombre
ORDER BY comision DESC;

-- 4. Día con más ventas (por importe)
SELECT fecha, SUM(cantidad * (SELECT precio FROM productos WHERE id = ventas.producto_id)) AS importe
FROM ventas
GROUP BY fecha
ORDER BY importe DESC
LIMIT 1;
````

</details>