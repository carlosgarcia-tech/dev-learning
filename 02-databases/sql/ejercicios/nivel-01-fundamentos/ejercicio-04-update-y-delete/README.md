# Ejercicio 04 — UPDATE y DELETE

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Actualiza el precio de un producto
2. Incrementa el precio en 10% de todos los productos con stock > 0
3. Elimina un producto específico
4. Elimina productos con stock = 0

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Actualizar un producto
UPDATE productos
SET precio = 320.00
WHERE nombre = 'Monitor';

-- Incrementar precio 10% (solo productos con stock)
UPDATE productos
SET precio = ROUND(precio * 1.1, 2)
WHERE stock > 0;

SELECT * FROM productos;

-- Eliminar producto específico
DELETE FROM productos WHERE id = 5;

-- Eliminar productos sin stock
DELETE FROM productos WHERE stock = 0;

SELECT * FROM productos;
```

</details>
