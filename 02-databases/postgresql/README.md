# PostgreSQL — Curso Completo desde Cero hasta Experto

> Ruta de aprendizaje completa de PostgreSQL en español: 6 guías de estudio, 30 ejercicios prácticos por niveles y un proyecto final.

PostgreSQL es el sistema de base de datos relacional open source más avanzado y robusto del mundo. Soporta tipos de datos complejos, funciones definidas por el usuario en PL/pgSQL, replicación, particionamiento y características de nivel empresarial. Esta ruta cubre desde la creación de tablas hasta la replicación y la alta disponibilidad.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Instalación, psql, CREATE DATABASE/TABLE, tipos de datos, NULL, SERIAL, DEFAULT |
| [02 — Tipos de datos](02-tipos-de-datos.md) | Numéricos, texto, fecha/hora, booleanos, UUID, JSON/JSONB, arrays, enumerados, compuestos |
| [03 — Consultas avanzadas](03-consultas-avanzadas.md) | JOINs, subconsultas, CTE, window functions, vistas, índices, EXPLAIN |
| [04 — Funciones y PL/pgSQL](04-funciones-y-plpgsql.md) | Funciones, procedimientos, triggers, PL/pgSQL, control de flujo, cursores |
| [05 — Administración](05-administracion.md) | Usuarios, privilegios, backups, pg_dump, restauración, vacuum, tuning |
| [06 — Replicación y alta disponibilidad](06-replicacion-y-alta-disponibilidad.md) | Streaming replication, failover, pooler, clustering, Patroni |

## Ejercicios por nivel

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Conexión, CREATE TABLE, INSERT, SELECT, WHERE, UPDATE/DELETE |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | JOINs, GROUP BY, subconsultas, vistas, índices, constraints |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Window functions, CTE, transacciones, triggers, funciones |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | JSON/JSONB, índices avanzados, EXPLAIN, particionamiento |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | Modelado complejo, auditoría, réplicas, optimización, performance tuning |

Índice completo: [ejercicios/README.md](ejercicios/README.md)

## Proyecto final

[**Sistema de biblioteca**](ejercicios/proyectos/proyecto-final/) — base de datos completa con préstamos, reservas, multas, catálogo, usuarios y reportes.

## Cómo usar cada ejercicio

Cada ejercicio es autocontenido:

```bash
cd 02-databases/postgresql/ejercicios/nivel-01-fundamentos/ejercicio-01-connect-create-db
bash test.sh
```

`test.sh` crea una base de datos de pruebas, ejecuta `init.sql` (el esquema
de partida), luego `solucion.sql` (la solución propuesta) y por último
`checks.sql` (comprobaciones automáticas). Requiere tener `psql` en el PATH
y acceso a un servidor PostgreSQL (por defecto `localhost:5432`, usuario
`postgres`; puedes sobreescribir con las variables de entorno `DB_HOST`,
`DB_PORT`, `DB_USER`).

## Estadísticas

| Componente | Cantidad |
|---|---|
| Guías de estudio | 6 |
| Ejercicios totales | 30 |
| Archivos por ejercicio | 6 (README.md, init.sql, solucion.sql, checks.sql, expected.txt, test.sh) |
| Proyecto final | 1 (Sistema de biblioteca) |
