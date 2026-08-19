# Ejercicio 08 — LEFT y RIGHT JOIN

- **Nivel:** 2/5
- **Tema:** Básico de SQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Muestra todos los clientes con sus pedidos (LEFT JOIN)
2. Encuentra clientes sin pedidos
3. Muestra todos los pedidos con sus clientes (RIGHT JOIN)

> **Nota:** `RIGHT JOIN` sólo está disponible en SQLite 3.39 o superior;
> en motores más antiguos puede reescribirse invirtiendo el orden de las
> tablas y usando `LEFT JOIN`.

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Todos los clientes con pedidos (o sin)
SELECT
    c.nombre,
    c.email,
    p.id AS pedido_id,
    p.total
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;

-- Clientes sin pedidos
SELECT
    c.nombre,
    c.email
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;

-- Todos los pedidos con clientes (equivalente sin RIGHT JOIN)
SELECT
    p.id AS pedido_id,
    c.nombre AS cliente,
    p.total
FROM pedidos p
LEFT JOIN clientes c ON p.cliente_id = c.id;
```

</details>
