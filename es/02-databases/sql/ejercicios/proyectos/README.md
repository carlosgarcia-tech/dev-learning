# Proyectos integradores — SQL

Proyectos que combinan **todo** lo aprendido en las guías y ejercicios: modelado, joins, agregaciones, window functions, CTEs, vistas, transacciones, índices y optimización.

Cada proyecto se organiza en **fases**. Completa las fases en orden y verifica cada una ejecutando las consultas en SQLite o PostgreSQL.

## Proyecto 1 — Sistema de blog

Un blog con autores, posts, categorías, etiquetas y comentarios.

### Fase 1 — Modelado

Diseña un schema normalizado en 3FN con:

- `autores`: id, nombre, email único.
- `categorias`: id, nombre único.
- `posts`: id, autor_id (FK), categoria_id (FK), titulo, contenido, fecha_publicacion, publicado (booleano).
- `etiquetas`: id, nombre único.
- `post_etiquetas`: tabla intermedia (N:M entre posts y etiquetas).
- `comentarios`: id, post_id (FK), autor_nombre, texto, fecha.

Requisitos:

- [ ] Todas las tablas con `PRIMARY KEY` y `FOREIGN KEY`.
- [ ] Datos de ejemplo: 3 autores, 4 categorías, 6 posts (2 sin publicar), 5 etiquetas, 8 comentarios.

### Fase 2 — Consultas de lectura

Requisitos:

- [ ] Listar posts publicados con nombre de autor y categoría, ordenados por fecha (descendente).
- [ ] Posts con su número de comentarios (usa `LEFT JOIN` + `COUNT` + `GROUP BY`).
- [ ] Top 5 etiquetas más usadas (cantidad de posts por etiqueta).
- [ ] Posts que contengan una palabra en el título (usa `LIKE '%palabra%'`).

### Fase 3 — Reportes avanzados

Requisitos:

- [ ] Autor con más posts publicados (usa CTE o subconsulta).
- [ ] Posts con más comentarios que la media (subconsulta de `AVG`).
- [ ] Número de posts publicados por mes (agrega con `strftime`/`to_char`).
- [ ] Ranking de autores por comentarios recibidos (usa `RANK()` con window function).

## Proyecto 2 — E-commerce mínimo

Un e-commerce con clientes, productos, pedidos y líneas de pedido.

### Fase 1 — Modelado

Diseña un schema normalizado en 3FN con:

- `clientes`: id, nombre, email único, ciudad.
- `productos`: id, nombre, precio, stock.
- `pedidos`: id, cliente_id (FK), fecha, estado (`'pendiente'`, `'pagado'`, `'enviado'`, `'cancelado'`).
- `lineas_pedido`: pedido_id + producto_id (PK compuesta), cantidad, precio_unitario.

Requisitos:

- [ ] `CHECK` para el estado del pedido y para `cantidad > 0`.
- [ ] Datos de ejemplo: 4 clientes, 6 productos, 5 pedidos, 12 líneas.

### Fase 2 — Consultas de negocio

Requisitos:

- [ ] Total de cada pedido (suma de `cantidad * precio_unitario`) con nombre del cliente.
- [ ] Productos agotados (`stock = 0`).
- [ ] Clientes sin pedidos (`LEFT JOIN` con `WHERE ... IS NULL`).
- [ ] Pedidos pagados con su importe total, ordenados por importe desc.

### Fase 3 — Transacciones y optimización

Requisitos:

- [ ] Simula una compra dentro de una transacción: crear pedido, insertar líneas y **decrementar el stock** de cada producto. Haz `COMMIT`.
- [ ] Simula un pedido que falla a mitad (producto sin stock) y haz `ROLLBACK`, verificando que el stock no cambió.
- [ ] Crea un índice sobre `pedidos (cliente_id)` y otro sobre `lineas_pedido (producto_id)`. Compara `EXPLAIN QUERY PLAN` antes y después.
- [ ] Crea una vista `v_total_pedidos` con el importe total por pedido.

### Fase 4 — Reportes

Requisitos:

- [ ] Ingresos totales por mes.
- [ ] Top 3 productos más vendidos (por cantidad).
- [ ] Valor medio de pedido y pedido máximo.
- [ ] Porcentaje de pedidos cancelados sobre el total.

## Proyecto 3 — Dashboard de ventas

Un panel de métricas para una cadena de tiendas.

### Fase 1 — Modelado

Diseña un schema normalizado en 3FN con:

- `tiendas`: id, nombre, ciudad, region.
- `vendedores`: id, nombre, tienda_id (FK).
- `productos`: id, nombre, categoria, precio.
- `ventas`: id, tienda_id (FK), vendedor_id (FK), producto_id (FK), cantidad, fecha.

Requisitos:

- [ ] Datos de ejemplo realistas: 3 tiendas en 2 regiones, 6 vendedores, 8 productos, 30+ ventas en varios meses.
- [ ] Usa fechas de 2024 repartidas en al menos 3 meses.

### Fase 2 — KPIs

Requisitos:

- [ ] Ventas totales (suma de `cantidad * precio`).
- [ ] Número de ventas y ticket medio por tienda.
- [ ] Vendedor del mes (mayor importe) usando `ROW_NUMBER()`.
- [ ] Ventas por región y por categoría de producto (agregados cruzados con `GROUP BY` doble).

### Fase 3 — Series temporales

Requisitos:

- [ ] Ventas mensuales por tienda (fila por tienda y mes).
- [ ] Comparativa mes a mes: ventas del mes actual frente al anterior usando `LAG()`.
- [ ] Día con mayor facturación de todo el dataset.
- [ ] Acumulado de ventas por tienda a lo largo del tiempo (suma acumulativa con `SUM() OVER (ORDER BY fecha)`).

### Fase 4 — Vistas y optimización

Requisitos:

- [ ] Crea vistas para cada KPI principal (p. ej. `v_ventas_por_tienda`, `v_ventas_mensuales`).
- [ ] Índice compuesto sobre `ventas (tienda_id, fecha)` y verifica con `EXPLAIN`.
- [ ] Consulta con CTE que compute el top 3 de productos por región.
- [ ] Replica un KPI con `GROUPING SETS` (PostgreSQL) o compara el mismo cálculo con y sin window functions.