# Ejercicio 12 — LIMIT y Paginación

- **Nivel:** 2/5
- **Tema:** Básico de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Obtén los 3 productos más caros
2. Obtén la segunda página (2 productos por página)
3. Obtén el cliente con más pedidos

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- 3 productos más caros
SELECT * FROM productos
ORDER BY precio DESC
LIMIT 3;

-- Página 2 (2 por página)
SELECT * FROM productos
ORDER BY id
LIMIT 2 OFFSET 2;

-- Cliente con más pedidos
SELECT
    c.nombre,
    COUNT(p.id) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
ORDER BY total_pedidos DESC
LIMIT 1;
```

</details>
