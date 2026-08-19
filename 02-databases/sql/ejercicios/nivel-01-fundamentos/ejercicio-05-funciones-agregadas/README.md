# Ejercicio 05 — Funciones Agregadas

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Calcula:
1. Total de productos
2. Precio promedio
3. Precio máximo y mínimo
4. Suma de todos los precios
5. Cantidad de productos con stock > 0

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT COUNT(*) AS total_productos FROM productos;
SELECT ROUND(AVG(precio), 2) AS precio_promedio FROM productos;
SELECT MAX(precio) AS maximo, MIN(precio) AS minimo FROM productos;
SELECT SUM(precio) AS suma_total FROM productos;
SELECT COUNT(*) AS con_stock FROM productos WHERE stock > 0;
```

</details>
