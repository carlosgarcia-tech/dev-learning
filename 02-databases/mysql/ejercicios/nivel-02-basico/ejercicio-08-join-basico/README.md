# Ejercicio 08 — JOIN básico

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Las tablas `clientes` y `pedidos` ya existen con datos. Escribe una consulta `INNER JOIN`.

1. Muestra `cliente`, `pedido_id` y `total` uniendo `clientes` y `pedidos` por `cliente_id`.
2. Ordena por `pedido_id` ascendente.

## Requisitos

- [ ] Usas `INNER JOIN`
- [ ] El resultado muestra el nombre del cliente (no su ID)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `INNER JOIN pedidos p ON c.id = p.cliente_id` une por la clave foránea.
- Usa alias para las tablas: `clientes c`, `pedidos p`.
- Selecciona `c.nombre AS cliente` para mostrar el nombre.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT c.nombre AS cliente, p.id AS pedido_id, p.total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
ORDER BY p.id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-08-join-basico
bash test.sh
```
