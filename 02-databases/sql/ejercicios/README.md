# Ejercicios — SQL

Cada ejercicio tiene enunciado, schema inicial, requisitos, pistas plegables y solución al final (plegable). Resuélvelos en orden dentro de cada nivel; los niveles son progresivos.

> Todos los ejercicios usan SQL estándar (SQLite/PostgreSQL). Cuando un ejercicio depende de un motor concreto (stored procedures, triggers, RIGHT JOIN), se indica en el enunciado.

## Nivel 1 — Fundamentos

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [select-basico](nivel-01-fundamentos/ejercicio-01-select-basico.md) | SELECT, columnas, `*`, DISTINCT |
| 02 | [where-y-orden](nivel-01-fundamentos/ejercicio-02-where-y-orden.md) | WHERE, operadores, ORDER BY, LIMIT |
| 03 | [insert](nivel-01-fundamentos/ejercicio-03-insert.md) | INSERT, valores múltiples |
| 04 | [update-y-delete](nivel-01-fundamentos/ejercicio-04-update-y-delete.md) | UPDATE, DELETE, WHERE |
| 05 | [funciones-agregadas](nivel-01-fundamentos/ejercicio-05-funciones-agregadas.md) | COUNT, SUM, AVG, MIN, MAX |
| 06 | [like-y-filtros](nivel-01-fundamentos/ejercicio-06-like-y-filtros.md) | LIKE, IN, BETWEEN, NULL |

## Nivel 2 — Básico

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [inner-join](nivel-02-basico/ejercicio-01-inner-join.md) | INNER JOIN |
| 02 | [left-y-right-join](nivel-02-basico/ejercicio-02-left-y-right-join.md) | LEFT JOIN, RIGHT JOIN (simulado en SQLite) |
| 03 | [group-by-y-having](nivel-02-basico/ejercicio-03-group-by-y-having.md) | GROUP BY, HAVING |
| 04 | [subconsultas](nivel-02-basico/ejercicio-04-subconsultas.md) | Subconsultas en WHERE, IN, comparaciones |
| 05 | [alias-y-case](nivel-02-basico/ejercicio-05-alias-y-case.md) | Alias, CASE WHEN |
| 06 | [limit-y-paginacion](nivel-02-basico/ejercicio-06-limit-y-paginacion.md) | LIMIT, OFFSET, paginación |

## Nivel 3 — Intermedio

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [joins-multiples](nivel-03-intermedio/ejercicio-01-joins-multiples.md) | Varios INNER JOIN, relación N:M |
| 02 | [window-functions](nivel-03-intermedio/ejercicio-02-window-functions.md) | ROW_NUMBER, RANK, LAG/LEAD |
| 03 | [ctes](nivel-03-intermedio/ejercicio-03-ctes.md) | Common Table Expressions (WITH) |
| 04 | [vistas](nivel-03-intermedio/ejercicio-04-vistas.md) | CREATE VIEW |
| 05 | [agregaciones-avanzadas](nivel-03-intermedio/ejercicio-05-agregaciones-avanzadas.md) | GROUP BY compuesto, window functions |
| 06 | [normalizacion](nivel-03-intermedio/ejercicio-06-normalizacion.md) | Diseño de esquema en 3FN |

## Nivel 4 — Avanzado

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [constraints](nivel-04-avanzado/ejercicio-01-constraints.md) | PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL |
| 02 | [indexes](nivel-04-avanzado/ejercicio-02-indexes.md) | CREATE INDEX, UNIQUE INDEX, EXPLAIN QUERY PLAN |
| 03 | [transacciones](nivel-04-avanzado/ejercicio-03-transacciones.md) | BEGIN, COMMIT, ROLLBACK |
| 04 | [stored-procedures](nivel-04-avanzado/ejercicio-04-stored-procedures.md) | Funciones/procedimientos (PostgreSQL) |
| 05 | [triggers](nivel-04-avanzado/ejercicio-05-triggers.md) | CREATE TRIGGER, automatización |
| 06 | [optimizacion-de-queries](nivel-04-avanzado/ejercicio-06-optimizacion-de-queries.md) | EXPLAIN, índices, reescritura |

## Nivel 5 — Experto

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [modelado-de-schema](nivel-05-experto/ejercicio-01-modelado-de-schema.md) | Diseño de bases de datos, integridad referencial |
| 02 | [migraciones](nivel-05-experto/ejercicio-02-migraciones.md) | ALTER TABLE, migración de datos |
| 03 | [datos-relacionales-complejos](nivel-05-experto/ejercicio-03-datos-relacionales-complejos.md) | N:M, agregados sobre joins múltiples |
| 04 | [reportes-de-negocio](nivel-05-experto/ejercicio-04-reportes-de-negocio.md) | Reportes agregados, KPIs |
| 05 | [transacciones-y-concurrencia](nivel-05-experto/ejercicio-05-transacciones-y-concurrencia.md) | Niveles de aislamiento, bloqueos |
| 06 | [mini-crm](nivel-05-experto/ejercicio-06-mini-crm.md) | Proyecto final: schema + reportes |

## Proyectos integradores

Proyectos que combinan todo lo aprendido en sistemas completos.

| Proyecto | Descripción |
|---|---|
| [Sistema de blog](proyectos/README.md#proyecto-1-sistema-de-blog) | Autores, posts, categorías, comentarios y reportes |
| [E-commerce mínimo](proyectos/README.md#proyecto-2-e-commerce-mínimo) | Clientes, productos, pedidos y líneas de pedido |
| [Dashboard de ventas](proyectos/README.md#proyecto-3-dashboard-de-ventas) | Ventas, métricas y reportes agregados |