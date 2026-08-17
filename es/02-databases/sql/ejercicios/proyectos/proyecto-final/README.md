# PROYECTO FINAL — Sistema de e-commerce con SQL

Trabajo integrador que combina **todas** las técnicas del bloque SQL sobre una base de datos realista y **evaluada con tests automáticos**: modelado con constraints, agregaciones, subconsultas, CTEs, window functions, índices, triggers y transacciones.

El esquema y los datos se entregan resueltos. Tu trabajo es resolver las **15 consultas/operaciones** de `consultas/` hasta que **pasen los 17 tests** de `tests/`.

---

## 1. Objetivo

La empresa *TiendaOnline* vende productos por internet. Necesita una base de datos que gestione:

- **Clientes** registrados en la tienda.
- **Productos** del catálogo con su stock actual.
- **Pedidos** con su estado y su **línea de detalle** (qué productos y en qué cantidad).
- **Pagos** asociados a los pedidos.
- **Inventario**: trazabilidad de entradas y salidas de mercancía.

Tu misión: responder las consultas de negocio y construir las operaciones (índices, trigger, transacción) que la tienda necesita, verificando el resultado contra los tests.

## 2. Entorno y requisitos

- **SQLite3** en línea de comandos (versión ≥ 3.38; el proyecto se ha desarrollado y verificado con SQLite 3.50.2).
- Solo se permite el uso de `sqlite3`; no se usan otros SGBD ni drivers.
- **No modificar** `schema.sql` ni `datos.sql`: son la base de datos entregada y la usan los tests.
- Cada ejercicio se resuelve **únicamente** en su archivo de `consultas/`, sustituyendo el `-- TODO`.
- Los tests se ejecutan con `bash tests/<nombre>.sh` y se consideran superados cuando muestran `OK`.

## 3. Estructura del proyecto

```
proyecto-final/
├── README.md           ← esta especificación
├── schema.sql          ← esquema completo (6 tablas, constraints, FKs, CHECKs)
├── datos.sql           ← datos realistas y coherentes
├── consultas/          ← 15 ejercicios (stubs con -- TODO)
│   ├── consulta-01-ingresos-mensuales.sql      … consulta-12-movimientos-inventario.sql
│   └── consulta-13-crear-indices.sql           … consulta-15-transaccion-compra.sql
└── tests/              ← 17 tests + archivos esperados
    ├── test-estructura.sh   · check-estructura.sql   · expected-estructura.txt
    ├── test-datos.sh        · check-datos.sql        · expected-datos.txt
    ├── test-01.sh … test-12.sh (SELECT) · expected-01.txt … expected-12.txt
    ├── test-13.sh  · expected-13.txt
    ├── test-14.sh  · check-14.sql · expected-14.txt
    ├── test-15.sh  · check-15-success.sql · check-15-rollback.sql
    │                 · expected-15-success.txt · expected-15-rollback.txt
```

## 4. Modelo de datos

```
clientes               productos               inventario_movimientos
├── id PK              ├── id PK               ├── id PK
├── nombre             ├── nombre              ├── producto_id FK → productos
├── email UNIQUE       ├── categoria           ├── tipo CHECK (entrada|salida|ajuste)
├── telefono           ├── precio CHECK > 0    ├── cantidad
├── ciudad             ├── stock CHECK >= 0    ├── fecha
└── fecha_registro     └── activo 0|1          └── motivo

pedidos                detalle_pedidos         pagos
├── id PK              ├── pedido_id FK        ├── id PK
├── cliente_id FK      ├── producto_id FK      ├── pedido_id FK → pedidos
├── fecha              ├── cantidad CHECK > 0  ├── metodo CHECK (tarjeta|transferencia|efectivo|paypal)
├── estado CHECK       ├── precio_unitario     ├── monto CHECK > 0
│   (pendiente|pagado| └── PK (pedido_id,      └── fecha
│    enviado|entregado|    producto_id)
│    cancelado)
└── total CHECK >= 0
```

Relaciones: un cliente tiene N pedidos; un pedido tiene N productos (N:M a través de `detalle_pedidos`); un pedido tiene N pagos; un producto tiene N movimientos de inventario.

## 5. Fases de trabajo

### Fase 0 — Exploración
Carga la base y conoce los datos:

```bash
cd proyectos/proyecto-final
sqlite3 tmp.db < schema.sql
sqlite3 tmp.db < datos.sql
sqlite3 -header -column tmp.db "SELECT * FROM clientes;"
```

Verifica que la base entregada es correcta:

```bash
bash tests/test-estructura.sh   # estructura: tablas, FKs, PK compuesta, CHECKs
bash tests/test-datos.sh        # integridad: totales, emails, pagos, stock
```

Debes ver `OK` en ambos. No sigas hasta que sea así.

### Fase 1 — Consultas SELECT (consulta-01 … consulta-12)
Resuelve los ejercicios en orden, de menor a mayor dificultad:

1. **01 ingresos mensuales** — `GROUP BY` + `strftime` + filtro por estado.
2. **02 total de cada pedido con cliente** — CTE + `INNER JOIN`.
3. **03 top 3 productos** — ventana `ROW_NUMBER()`.
4. **04 ticket medio vs media global** — subconsulta escalar.
5. **05 stock crítico** — subconsulta correlacionada.
6. **06 ranking de clientes** — ventana `RANK()`.
7. **07 clientes inactivos** — `NOT EXISTS`.
8. **08 métodos de pago** — agregación con `GROUP BY`.
9. **09 comparativa mensual** — `LAG()` y variación porcentual.
10. **10 saldo pendiente** — subconsulta + `LEFT JOIN` + `HAVING`.
11. **11 panel KPI** — varias subconsultas escalares en una fila.
12. **12 stock acumulado** — `SUM() OVER (PARTITION BY … ORDER BY …)`.

Para cada ejercicio, al terminar:

```bash
bash tests/test-0N.sh
```

### Fase 2 — Operaciones (consulta-13 … consulta-15)

13. **Crear índices** — los tres índices que aceleran las consultas (`test-13.sh` comprueba que existen en `sqlite_master`).
14. **Trigger de inventario** — `AFTER INSERT` en `detalle_pedidos`: descuenta stock y registra una salida de forma atómica. El test inserta una línea nueva y comprueba el stock y el movimiento (`test-14.sh`).
15. **Transacción de compra** — compra completa atómica con `COMMIT` (pedido + líneas + descuento de stock + pago). El test verifica el estado final **y** que una transacción con un producto inexistente se deshace con `ROLLBACK` (`test-15.sh`).

### Fase 3 — Cierre

```bash
cd tests
./test-estructura.sh && ./test-datos.sh
for t in test-{01..15}.sh; do bash "$t"; done
```

Los 17 tests deben mostrar `OK`. Ningún test debe dejar archivos temporales ni bases de datos residuales.

## 6. Criterios de aceptación

### A. Estructura (tests `test-estructura.sh` y `test-datos.sh`)
- [ ] CA-01 El esquema crea exactamente 6 tablas de negocio.
- [ ] CA-02 Todas las tablas objetivo están presentes (`clientes`, `productos`, `pedidos`, `detalle_pedidos`, `pagos`, `inventario_movimientos`).
- [ ] CA-03 `pedidos` tiene 1 clave foránea a `clientes`.
- [ ] CA-04 `detalle_pedidos` tiene 2 claves foráneas (a `pedidos` y a `productos`).
- [ ] CA-05 `detalle_pedidos` usa clave primaria compuesta de 2 columnas (`pedido_id`, `producto_id`).
- [ ] CA-06 `pedidos` define al menos 2 restricciones `CHECK` (estado y total ≥ 0).
- [ ] CA-07 Los 12 pedidos tienen un total coherente con la suma de sus líneas de detalle.
- [ ] CA-08 No hay pedidos sin líneas de detalle.
- [ ] CA-09 No hay emails de cliente duplicados.
- [ ] CA-10 No hay pagos asociados a pedidos en estado `pendiente` o `cancelado`.
- [ ] CA-11 El stock de cada producto coincide con la suma de sus movimientos de inventario.

### B. Consultas SELECT (tests `test-01.sh` … `test-12.sh`)
- [ ] CA-12 `consulta-01`: ingresos por mes solo de pedidos válidos, ordenados por mes.
- [ ] CA-13 `consulta-02`: total por pedido recalculado con CTE desde `detalle_pedidos`, con nombre del cliente.
- [ ] CA-14 `consulta-03`: top 3 de productos por unidades con `ROW_NUMBER()` y desempate alfabético.
- [ ] CA-15 `consulta-04`: ticket medio por cliente frente a la media global (subconsulta escalar).
- [ ] CA-16 `consulta-05`: productos activos con stock ≤ 8 y unidades vendidas (subconsulta correlacionada).
- [ ] CA-17 `consulta-06`: ranking de clientes por gasto con `RANK()`.
- [ ] CA-18 `consulta-07`: clientes sin pedidos en marzo 2024 con `NOT EXISTS`.
- [ ] CA-19 `consulta-08`: número de pagos y total cobrado por método de pago.
- [ ] CA-20 `consulta-09`: comparativa mensual con `LAG()` y variación porcentual.
- [ ] CA-21 `consulta-10`: clientes con saldo pendiente > 0 (subconsulta + `HAVING`).
- [ ] CA-22 `consulta-11`: una única fila con 5 KPIs (clientes, pedidos, ingresos, ticket medio, unidades).
- [ ] CA-23 `consulta-12`: stock acumulado por producto con `SUM() OVER (PARTITION BY …)`.

### C. Operaciones (tests `test-13.sh` … `test-15.sh`)
- [ ] CA-24 `consulta-13`: existen los índices `idx_pedidos_cliente`, `idx_detalle_producto` e `idx_pedidos_fecha`.
- [ ] CA-25 `consulta-14`: el trigger `trg_descontar_stock` descuenta el stock (25 → 23) y registra la salida en `inventario_movimientos`.
- [ ] CA-26 `consulta-15`: la transacción crea el pedido 13, sus 2 líneas, descuenta stock de los productos 1 y 3, y registra el pago, todo tras un único `COMMIT`.
- [ ] CA-27 El rollback de una transacción fallida deja `0` pedidos parciales y el stock intacto.

### D. Entrega final
- [ ] CA-28 Todos los archivos de `consultas/` resueltos (sin `-- TODO`).
- [ ] CA-29 Los 17 tests muestran `OK`.
- [ ] CA-30 `schema.sql` y `datos.sql` no han sido modificados.
- [ ] CA-31 La verificación es reproducible: al volver a ejecutar los tests no quedan bases de datos ni archivos temporales.

## 7. Rúbrica de evaluación

| Criterio | Peso | Descripción |
|---|---|---|
| Base entregada | 10 % | `test-estructura` y `test-datos` en verde sin tocar `schema.sql`/`datos.sql`. |
| Consultas SELECT | 40 % | `test-01` … `test-12` en verde (técnica correcta y salida exacta). |
| Operaciones | 25 % | `test-13` (índices), `test-14` (trigger) y `test-15` (transacción + rollback) en verde. |
| Consistencia interna | 15 % | Los 12 totales de pedido coinciden con sus líneas; stock y movimientos coherentes. |
| Documentación y entrega | 10 % | Archivos de `consultas/` sin `TODO`, proyecto reproducible y sin residuos. |

Cada test en verde contribuye a su bloque; **el proyecto se aprueba cuando los 17 tests pasan**.

## 8. Consejos

- Empieza cargando la base y entendiendo los datos antes de escribir SQL.
- Respeta el orden de columnas y los `ROUND(..., 2)` que pide cada enunciado: la salida se compara exacta.
- En `consulta-10`, el `HAVING` actúa sobre la columna calculada `saldo_pendiente`.
- Si un test falla, ejecuta la consulta a mano contra `tmp.db` y compara con el `expected-*.txt`.
- Usa `sqlite3 -header -column` para leer resultados y `sqlite3 -header -list -separator '|'` para ver exactamente qué compara el test.
