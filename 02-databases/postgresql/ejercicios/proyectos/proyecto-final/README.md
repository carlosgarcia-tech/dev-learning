# Proyecto Final: Sistema de Biblioteca con PostgreSQL

## Contexto

Sistema completo de biblioteca: gestión de libros, autores y usuarios,
préstamos y devoluciones, auditoría, funciones/triggers, y reportes.

## Estructura

```
proyecto-final/
├── README.md
├── schema.sql          -- todo el esquema base (tablas + constraints + indices)
├── datos.sql            -- datos de ejemplo
├── functions/
│   ├── calcular_multa.sql
│   └── obtener_estadisticas_libro.sql
├── triggers/
│   ├── validar_stock.sql
│   └── auditoria.sql
├── procedures/
│   └── registrar_prestamo.sql
└── tests/
    └── test_proyecto.sh
```

## Cómo correrlo

```bash
cd ejercicios/proyectos/proyecto-final
bash tests/test_proyecto.sh
```

## Criterios de aceptación

1. Modelo relacional correcto, con FKs y CHECKs
2. Datos de ejemplo cargables sin errores
3. Función `calcular_multa`
4. Trigger que valida y descuenta stock antes de un préstamo
5. Trigger de auditoría genérico
6. Procedimiento `registrar_prestamo` con manejo de errores
7. Reporte de libros más prestados
8. Reporte de usuarios con préstamos activos
9. Índices sobre las columnas más consultadas
10. Todo el flujo se ejecuta sin intervención manual vía `tests/test_proyecto.sh`

## Rúbrica

| Criterio | Peso |
|----------|------|
| Modelado | 20% |
| Funciones/Procedimientos | 20% |
| Triggers | 15% |
| Reportes | 15% |
| Optimización | 15% |
| Documentación | 15% |
