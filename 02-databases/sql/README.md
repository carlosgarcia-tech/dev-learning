# SQL

> Guía de estudio + ejercicios por niveles para aprender SQL desde cero hasta nivel experto.

SQL (Structured Query Language) es el lenguaje estándar para consultar y manipular bases de datos relacionales. Todos los ejemplos de esta guía funcionan en **SQL estándar**, compatible con SQLite y PostgreSQL, y cada ejercicio incluye su `CREATE TABLE` + `INSERT` para que puedas practicar localmente.

## Cómo usar esta guía

1. Lee las **guías** en orden: `01-fundamentos` → `02-joins` → `03-indexes` → `04-transactions`.
2. Resuelve los **ejercicios** de cada nivel antes de pasar al siguiente.
3. Ejecuta cada ejercicio localmente con SQLite o PostgreSQL para verificar el resultado.
4. Al final, completa los **proyectos integradores**.

## Guías

| # | Guía | Contenido |
|---|---|---|
| 1 | [01-fundamentos.md](01-fundamentos.md) | SELECT, WHERE, ORDER BY, LIMIT, INSERT, UPDATE, DELETE, tipos de datos |
| 2 | [02-joins.md](02-joins.md) | INNER, LEFT, RIGHT, CROSS JOIN, llaves primarias y foráneas |
| 3 | [03-indexes.md](03-indexes.md) | Índices, cómo crearlos, cuándo usarlos, EXPLAIN |
| 4 | [04-transactions.md](04-transactions.md) | BEGIN, COMMIT, ROLLBACK, ACID, niveles de aislamiento |

## Ejercicios

Cada ejercicio incluye: enunciado, schema inicial (CREATE TABLE + INSERT), requisitos, pistas plegables y solución plegable.

| Nivel | Qué cubre | Enlaces |
|---|---|---|
| Nivel 1 — Fundamentos | SELECT, WHERE, ORDER BY, INSERT/UPDATE/DELETE, agregados, LIKE | [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) |
| Nivel 2 — Básico | Joins, GROUP BY/HAVING, subconsultas, CASE, paginación | [ejercicios/nivel-02-basico/](ejercicios/nivel-02-basico/) |
| Nivel 3 — Intermedio | Joins múltiples, window functions, CTEs, vistas, normalización | [ejercicios/nivel-03-intermedio/](ejercicios/nivel-03-intermedio/) |
| Nivel 4 — Avanzado | Constraints, índices, transacciones, stored procedures, triggers, optimización | [ejercicios/nivel-04-avanzado/](ejercicios/nivel-04-avanzado/) |
| Nivel 5 — Experto | Modelado, migraciones, datos complejos, reportes, concurrencia, mini-CRM | [ejercicios/nivel-05-experto/](ejercicios/nivel-05-experto/) |

Índice completo por ejercicio: [ejercicios/README.md](ejercicios/README.md)

## Proyectos integradores

Proyectos que combinan todo lo aprendido en sistemas reales.

| Proyecto | Descripción |
|---|---|
| [Sistema de blog](ejercicios/proyectos/README.md#proyecto-1-sistema-de-blog) | Autores, posts, categorías, comentarios y reportes |
| [E-commerce mínimo](ejercicios/proyectos/README.md#proyecto-2-e-commerce-mínimo) | Clientes, productos, pedidos, líneas de pedido |
| [Dashboard de ventas](ejercicios/proyectos/README.md#proyecto-3-dashboard-de-ventas) | Ventas, métricas y reportes agregados |

## Herramientas recomendadas

- **SQLite**: no requiere instalación de servidor. Con la CLI basta con `sqlite3 archivo.db`.
- **PostgreSQL**: servidor completo con funciones avanzadas (`pgAdmin`, `psql`).

## Recursos externos

- [SQLite Docs](https://www.sqlite.org/docs.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Teaching (interactivo)](https://www.sqlteaching.com/)
- [SQLZoo](https://sqlzoo.net/)