# MySQL — Curso Completo desde Cero hasta Experto

> Ruta de aprendizaje completa de MySQL en español: 5 guías de estudio, 30 ejercicios prácticos por niveles y un proyecto final integrador.

MySQL es el sistema de base de datos relacional open source más popular del mundo. Es el motor de bases de datos de Facebook, Twitter, Wikipedia, WordPress y millones de aplicaciones web. Esta ruta cubre desde la creación de tablas hasta la replicación, optimización y administración en producción.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es MySQL, MariaDB vs MySQL, instalación, cliente `mysql`, CREATE DATABASE/TABLE, tipos de datos, AUTO_INCREMENT, CHARACTER SET y COLLATION, motores (InnoDB, MyISAM), SHOW, DESCRIBE |
| [02 — Consultas y funciones](02-consultas-y-funciones.md) | SELECT, WHERE, ORDER BY, LIMIT, GROUP BY, HAVING, JOINs, subconsultas, funciones MySQL, IF/IFNULL/COALESCE/CASE, CAST/CONVERT |
| [03 — Avanzado](03-avanzado.md) | Índices (B-Tree, Hash, FULLTEXT, SPATIAL), EXPLAIN, vistas, stored procedures, funciones definidas por usuario, triggers, eventos, transacciones, locks, foreign keys |
| [04 — Optimización y rendimiento](04-optimizacion-y-rendimiento.md) | EXPLAIN ANALYZE, hints, buffer pool InnoDB, my.cnf, particionamiento, sharding, slow query log, performance schema |
| [05 — Administración y producción](05-administracion-y-produccion.md) | Usuarios y privilegios, mysqldump, restauración, replicación, clustering, monitoreo, MySQL 8 features, Docker, seguridad |

## Ejercicios por nivel

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Crear BD y tabla, INSERT, SELECT/WHERE/ORDER BY, LIMIT, tipos y AUTO_INCREMENT, SHOW y DESCRIBE |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | GROUP BY, JOIN básico, subconsulta, funciones texto, funciones fecha, UPDATE y DELETE |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | LEFT/RIGHT JOIN, índice, vista, transacción, foreign key, EXPLAIN |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Stored procedure, trigger, función usuario, evento, FULLTEXT index, particionamiento |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | EXPLAIN ANALYZE, replicación, backup mysqldump, usuarios y privilegios, MySQL 8 window functions, my.cnf y tuning |

Índice completo: [ejercicios/README.md](ejercicios/README.md)

## Proyecto final

[**Sistema de inventario y ventas**](ejercicios/proyectos/) — base de datos completa con productos, categorías, clientes, ventas, detalle de ventas, control de stock, stored procedures, triggers de auditoría, vistas de reportes y datos iniciales.

## Cómo usar cada ejercicio

Cada ejercicio es autocontenido:

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-01-crear-bd-y-tabla
bash test.sh
```

`test.sh` crea una base de datos temporal, ejecuta `schema.sql` (el esquema de partida)
y luego `solucion.sql` (la solución propuesta), y compara el resultado con
`expected.txt`. Si MySQL está disponible en el sistema, lo usa directamente; si no,
utiliza SQLite3 como motor de prueba compatible.

## Estadísticas

| Componente | Cantidad |
|---|---|
| Guías de estudio | 5 |
| Ejercicios totales | 30 |
| Archivos por ejercicio | 5 (README.md, schema.sql, solucion.sql, expected.txt, test.sh) |
| Proyecto final | 1 (Sistema de inventario y ventas) |
