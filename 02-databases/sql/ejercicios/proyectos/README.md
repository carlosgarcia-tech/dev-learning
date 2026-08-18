# Proyectos integradores — SQL

Proyectos que combinan **todo** lo aprendido en las guías y ejercicios: modelado, joins, agregaciones, window functions, CTEs, vistas, transacciones, triggers, índices y optimización.

Cada proyecto se organiza en **fases**. Completa las fases en orden y verifica cada una ejecutando las consultas en SQLite o PostgreSQL.

Los dos primeros proyectos son de dificultad creciente. El **Proyecto 3 es el PROYECTO FINAL**: el más exigente, con base de datos real entregada (`schema.sql` + `datos.sql`), 15 consultas/operaciones para resolver y una batería de **tests automatizados** que evalúan el resultado.

---

## Proyecto 1 — Sistema de blog

Blog con autores, posts, categorías, etiquetas y comentarios. Se modela y consulta a mano (sin tests).

Fases:
1. **Modelado 3FN**: `autores`, `categorias`, `posts`, `etiquetas`, `post_etiquetas` (N:M), `comentarios`. Todas con PK y FK. Datos de ejemplo: 3 autores, 4 categorías, 6 posts (2 sin publicar), 5 etiquetas, 8 comentarios.
2. **Consultas de lectura**: posts publicados con autor y categoría; nº de comentarios por post (`LEFT JOIN` + `COUNT` + `GROUP BY`); top 5 etiquetas; búsqueda con `LIKE`.
3. **Reportes avanzados**: autor con más posts (CTE); posts con más comentarios que la media (subconsulta de `AVG`); posts por mes (`strftime`/`to_char`); ranking de autores por comentarios (`RANK()`).

Requisitos mínimos:
- [ ] Todas las tablas con `PRIMARY KEY` y `FOREIGN KEY`.
- [ ] Datos de ejemplo indicados en la Fase 1.
- [ ] Cada fase completada con consultas correctas y resultados revisados a mano.

---

## Proyecto 2 — E-commerce mínimo

E-commerce con clientes, productos, pedidos y líneas de pedido. Se modela, consulta y optimiza a mano (sin tests).

Fases:
1. **Modelado 3FN**: `clientes`, `productos`, `pedidos` (estado con `CHECK`), `lineas_pedido` (PK compuesta). Datos: 4 clientes, 6 productos, 5 pedidos, 12 líneas.
2. **Consultas de negocio**: total por pedido con cliente; productos agotados; clientes sin pedidos (`LEFT JOIN` + `IS NULL`); pedidos pagados ordenados por importe.
3. **Transacciones y optimización**: compra atómica con `COMMIT` (crear pedido, líneas y decrementar stock); pedido que falla con `ROLLBACK`; índices sobre `pedidos(cliente_id)` y `lineas_pedido(producto_id)` comparando `EXPLAIN QUERY PLAN`; vista `v_total_pedidos`.
4. **Reportes**: ingresos por mes; top 3 productos; ticket medio y pedido máximo; % de pedidos cancelados.

Requisitos mínimos:
- [ ] `CHECK` para el estado del pedido y para `cantidad > 0`.
- [ ] Datos de ejemplo indicados en la Fase 1.
- [ ] Demostración en la Fase 3 de que el `ROLLBACK` deja el stock intacto.

---

## Proyecto 3 — PROYECTO FINAL: Sistema de e-commerce completo

El proyecto que integra **todas** las técnicas del bloque SQL sobre una base de datos real y evaluada con tests automáticos. Ver [su especificación completa](./proyecto-final/README.md).

Qué incluye:
- **Base de datos entregada**: `schema.sql` (6 tablas con constraints, FKs, CHECKs) y `datos.sql` (6 clientes, 10 productos, 12 pedidos, 9 pagos, 10 movimientos de inventario) con datos coherentes entre sí.
- **15 ejercicios en `consultas/`**: 12 consultas SELECT (agregaciones, subconsultas, CTEs, window functions con `ROW_NUMBER`, `RANK`, `LAG` y `SUM() OVER`) + 3 operaciones (crear índices, trigger de inventario, transacción de compra con rollback).
- **Batería de tests** en `tests/`: 17 scripts (`test-estructura`, `test-datos` y `test-01`…`test-15`) que construyen la base, ejecutan la solución y comparan la salida contra `expected-*.txt`.
- **Evaluación objetiva**: todos los tests deben quedar en verde (`OK`) contra la solución de referencia.

Fases:
1. **Exploración** (Fase 0): cargar `schema.sql` + `datos.sql`, revisar el modelo y ejecutar `test-estructura.sh` y `test-datos.sh`.
2. **Consultas SELECT** (consulta-01 a 12): de agregaciones y subconsultas a CTEs y window functions.
3. **Operaciones** (consulta-13 a 15): índices, trigger de inventario y transacción atómica.
4. **Cierre**: ejecutar los 17 tests hasta que todos pasen; el test de rollback debe confirmar que las transacciones fallidas no dejan cambios parciales.

Requisitos mínimos (resumen; los criterios completos están en `proyecto-final/README.md`):
- [ ] No modificar `schema.sql` ni `datos.sql`.
- [ ] Resolver las 15 consultas en `consultas/` (cada archivo sin el texto `TODO`).
- [ ] `bash tests/test-estructura.sh` y `bash tests/test-datos.sh` en verde.
- [ ] `bash tests/test-01.sh` … `bash tests/test-15.sh` en verde (17/17 `OK`).
