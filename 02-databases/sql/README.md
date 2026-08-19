# SQL

> Guía de estudio + ejercicios por niveles para aprender SQL desde cero hasta nivel experto.

SQL (Structured Query Language) es el lenguaje estándar para consultar y manipular bases de datos relacionales. Todos los ejemplos y ejercicios de esta sección funcionan en **SQLite** (cliente `sqlite3`), con esquemas y datos de ejemplo incluidos en cada carpeta.

## Cómo usar esta sección

1. Lee las **guías** en orden: `01-fundamentos` → `02-consultas-basicas` → `03-joins-y-subconsultas` → `04-funciones-y-agregaciones` → `05-avanzado` → `06-administracion`.
2. Resuelve los **ejercicios** de cada nivel antes de pasar al siguiente.
3. Ejecuta cada ejercicio localmente: cada carpeta tiene `schema.sql`, `solucion.sql` y un `test.sh` que verifica la salida contra `expected.txt` con SQLite.
4. Al final, completa los **proyectos integradores**.

## Guías

| # | Guía | Contenido |
|---|---|---|
| 1 | [01-fundamentos.md](01-fundamentos.md) | Qué es SQL, tipos de datos, DDL (CREATE, ALTER, DROP), DML (INSERT, UPDATE, DELETE), constraints |
| 2 | [02-consultas-basicas.md](02-consultas-basicas.md) | SELECT, WHERE, ORDER BY, LIMIT, operadores, LIKE, agregados básicos |
| 3 | [03-joins-y-subconsultas.md](03-joins-y-subconsultas.md) | INNER, LEFT, RIGHT, CROSS JOIN, subconsultas, GROUP BY/HAVING |
| 4 | [04-funciones-y-agregaciones.md](04-funciones-y-agregaciones.md) | Funciones de texto/fecha/matemáticas, agregaciones avanzadas, window functions |
| 5 | [05-avanzado.md](05-avanzado.md) | CTEs, vistas, transacciones, índices, triggers, optimización |
| 6 | [06-administracion.md](06-administracion.md) | Gestión de usuarios, permisos, backup/restore, buenas prácticas |

## Ejercicios

Cada ejercicio es una **carpeta** con: `README.md` (enunciado + requisitos + solución plegable), `schema.sql` (esquema + datos de ejemplo), `solucion.sql`, `expected.txt` y `test.sh` (verifica la salida con SQLite).

| Nivel | Qué cubre | Enlaces |
|---|---|---|
| Nivel 1 — Fundamentos | SELECT, WHERE, ORDER BY, INSERT/UPDATE/DELETE, agregados, LIKE | [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) |
| Nivel 2 — Básico | Joins, GROUP BY/HAVING, subconsultas, CASE, paginación | [ejercicios/nivel-02-basico/](ejercicios/nivel-02-basico/) |
| Nivel 3 — Intermedio | Joins múltiples, window functions, CTEs, vistas, normalización | [ejercicios/nivel-03-intermedio/](ejercicios/nivel-03-intermedio/) |
| Nivel 4 — Avanzado | Constraints, índices, transacciones, triggers, optimización | [ejercicios/nivel-04-avanzado/](ejercicios/nivel-04-avanzado/) |
| Nivel 5 — Experto | Modelado, migraciones, reportes, concurrencia, mini CRM | [ejercicios/nivel-05-experto/](ejercicios/nivel-05-experto/) |

## Proyectos integradores

| Proyecto | Descripción |
|---|---|
| [Proyecto final: Biblioteca](ejercicios/proyectos/proyecto-final/) | Sistema de gestión de biblioteca con SQLite: autores, libros, usuarios, préstamos, multas, triggers de auditoría y tests automatizados |

## Cómo ejecutar un ejercicio

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-select-basico
bash test.sh        # aplica schema + solución y compara con expected.txt
```

## Cómo crear un nuevo ejercicio

```bash
scripts/new-exercise-sql.sh nivel-01-fundamentos 07 mi-consulta
```