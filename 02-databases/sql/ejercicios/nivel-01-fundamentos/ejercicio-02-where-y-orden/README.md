# Ejercicio 02 — WHERE y Orden

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Usando la tabla `productos`:
1. Filtra productos con precio > 100
2. Filtra productos con stock > 0
3. Filtra productos por rango de precio (100-500)
4. Ordena por precio DESC

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Precio > 100
SELECT * FROM productos WHERE precio > 100;

-- Stock > 0
SELECT * FROM productos WHERE stock > 0;

-- Rango de precio
SELECT * FROM productos
WHERE precio BETWEEN 100 AND 500;

-- Ordenar por precio DESC
SELECT * FROM productos ORDER BY precio DESC;
```

</details>
