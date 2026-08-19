# Ejercicio 16 — Vistas

- **Nivel:** 3/5
- **Tema:** Intermedio de SQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Crea vista de clientes activos
2. Crea vista de productos disponibles
3. Crea vista de ventas por mes
4. Usa las vistas en consultas

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Vista de clientes activos
CREATE VIEW vista_clientes_activos AS
SELECT * FROM clientes WHERE activo = true;

-- Vista de productos disponibles
CREATE VIEW vista_productos_disponibles AS
SELECT * FROM productos WHERE stock > 0;

-- Vista de ventas por mes
CREATE VIEW vista_ventas_mes AS
SELECT
    strftime('%Y-%m', fecha) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS total_ventas
FROM pedidos
GROUP BY strftime('%Y-%m', fecha)
ORDER BY mes;

-- Usar vistas
SELECT * FROM vista_clientes_activos;
SELECT * FROM vista_productos_disponibles ORDER BY precio DESC;
SELECT * FROM vista_ventas_mes;
```

</details>
