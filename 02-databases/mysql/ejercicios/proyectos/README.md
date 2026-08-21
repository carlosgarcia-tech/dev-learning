# Proyecto Final — Sistema de Inventario y Ventas (MySQL)

Proyecto integrador que combina todo lo aprendido: modelado relacional, stored
procedures, triggers de auditoría, vistas de reportes, control de stock y datos
iniciales, todo sobre MySQL con motor InnoDB.

## Objetivos

- Modelar una base de datos real de inventario y ventas con foreign keys.
- Implementar stored procedures para registrar ventas y ajustar stock.
- Crear triggers de auditoría para cambios críticos.
- Construir vistas de reportes (ventas por cliente, productos más vendidos, stock bajo).
- Cargar datos iniciales coherentes.

## Archivos

| Archivo | Contenido |
|---|---|
| `schema.sql` | Tablas: categorias, productos, clientes, ventas, detalle_ventas, movimientos_inventario, auditoria |
| `datos-iniciales.sql` | Carga de categorías, productos, clientes y ventas de ejemplo |
| `procedures.sql` | `sp_registrar_venta`, `sp_actualizar_stock`, `sp_reabastecer` |
| `triggers.sql` | `trg_audit_producto` (auditoría de precios), `trg_verificar_stock` (validación en venta) |
| `views.sql` | `vw_inventario_actual`, `vw_ventas_por_cliente`, `vw_productos_mas_vendidos`, `vw_stock_bajo` |
| `test.sh` | Runner que valida el proyecto (MySQL real o fallback SQLite) |

## Cómo ejecutarlo

```bash
cd 02-databases/mysql/ejercicios/proyectos
bash test.sh
```

`test.sh` crea una base de datos temporal `test_proyecto_inventario`, ejecuta
`schema.sql` + `datos-iniciales.sql` + `procedures.sql` + `triggers.sql` + `views.sql`
en MySQL y verifica conteos y una vista de reporte. Si MySQL no está disponible,
usa SQLite3 para validar al menos el esquema, los datos y las vistas (omitiendo
procedures y triggers, que son específicos de MySQL).

## Modelo de datos

```
categorias 1──* productos 1──* detalle_ventas *──1 ventas *──1 clientes
                  │
                  └──* movimientos_inventario
                  └──* auditoria
```

## Entregable sugerido

1. Ejecuta `schema.sql` y `datos-iniciales.sql` en tu MySQL local.
2. Registra una venta nueva con `CALL sp_registrar_venta(...)`.
3. Verifica que el stock bajó y que `movimientos_inventario` registró la salida.
4. Consulta `vw_productos_mas_vendidos` y `vw_stock_bajo`.
5. Cambia el precio de un producto y revisa la auditoría generada por el trigger.
