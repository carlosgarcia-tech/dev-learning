# Proyecto Final: Sistema de Gestión de Biblioteca

## Contexto

Desarrolla un sistema de gestión de biblioteca con SQLite (cliente `sqlite3`) que permita gestionar libros, autores, usuarios y préstamos.

## Requisitos Funcionales

### Autores
- [ ] CRUD de autores (nombre, biografía, nacionalidad, fecha_nacimiento)
- [ ] Búsqueda por nombre

### Libros
- [ ] CRUD de libros (título, ISBN, año, autor_id, género, cantidad)
- [ ] Búsqueda por título, autor, género
- [ ] Gestión de disponibilidad

### Usuarios
- [ ] CRUD de usuarios (nombre, email, teléfono, fecha_registro)
- [ ] Login con email

### Préstamos
- [ ] Crear préstamo (libro + usuario)
- [ ] Devolución con multa automática
- [ ] Historial de préstamos
- [ ] Límite de 3 préstamos activos
- [ ] Plazo máximo de 14 días
- [ ] Multa de 0.50€ por día de retraso

### Reportes
- [ ] Libros más prestados
- [ ] Usuarios con más préstamos
- [ ] Multas totales por usuario
- [ ] Disponibilidad por género

## Estructura

```
proyecto-final/
├── README.md
├── schema.sql
├── datos.sql
├── consultas/
│   ├── reporte-libros-populares.sql
│   ├── reporte-usuarios-activos.sql
│   ├── reporte-multas.sql
│   └── dashboard.sql
├── functions/
│   ├── calcular-multa.sql
│   └── actualizar-disponibilidad.sql
├── triggers/
│   ├── actualizar-stock.sql
│   └── auditoria-prestamos.sql
├── tests/
│   ├── test-01-estructura.sh
│   ├── test-02-datos.sh
│   ├── test-03-prestamos.sh
│   └── test-04-reportes.sh
└── biblioteca.db        # generado al ejecutar los scripts (no se versiona)
```

## Cómo ejecutarlo (SQLite)

Requisito: tener instalado `sqlite3` (el curso usa la CLI de SQLite).

> SQLite no tiene procedimientos almacenados: las reglas de negocio
> (`calcular-multa`, `actualizar-disponibilidad`) se implementan con
> **triggers**. El esquema activa `PRAGMA foreign_keys = ON;` para
> respetar las claves foráneas. Todo el SQL es determinista (fechas
> fijas, sin depender de la fecha actual).

```bash
# Crear la base de datos local
sqlite3 biblioteca.db < schema.sql
sqlite3 biblioteca.db < functions/calcular-multa.sql
sqlite3 biblioteca.db < functions/actualizar-disponibilidad.sql
sqlite3 biblioteca.db < triggers/actualizar-stock.sql
sqlite3 biblioteca.db < triggers/auditoria-prestamos.sql
sqlite3 biblioteca.db < datos.sql

# Ejecutar reportes
sqlite3 biblioteca.db < consultas/dashboard.sql

# Correr los tests (cada uno construye su propia biblioteca.db)
bash tests/test-01-estructura.sh
bash tests/test-02-datos.sh
bash tests/test-03-prestamos.sh
bash tests/test-04-reportes.sh
```

## Criterios de Aceptación

1. ✅ Todas las tablas creadas
2. ✅ Relaciones correctamente establecidas
3. ✅ Datos de ejemplo insertados
4. ✅ Consultas de búsqueda funcionan
5. ✅ Préstamo creado correctamente (trigger `tr_validar_prestamo` valida las reglas de negocio)
6. ✅ Límite de préstamos validado (máximo 3 activos por usuario, `RAISE(ABORT)`)
7. ✅ Libro no puede prestarse dos veces si no hay ejemplares disponibles
8. ✅ Multa calculada correctamente (0.50 € por día de retraso)
9. ✅ Reporte de libros populares
10. ✅ Reporte de usuarios activos
11. ✅ Reporte de multas
12. ✅ Vista de disponibilidad
13. ✅ Trigger de multa (`tr_calcular_multa`)
14. ✅ Trigger de disponibilidad (stock decrementado/incrementado automáticamente)
15. ✅ Trigger de auditoría
16. ✅ Índices optimizados
17. ✅ Validaciones con CHECK
18. ✅ Transacciones en préstamos (los triggers de SQLite son atómicos)
19. ✅ Script de backup documentado
20. ✅ Documentación completa

## Rúbrica

| Criterio | Peso |
|----------|------|
| Modelado | 25% |
| Consultas | 25% |
| Funciones/Triggers | 20% |
| Optimización | 15% |
| Documentación | 15% |
