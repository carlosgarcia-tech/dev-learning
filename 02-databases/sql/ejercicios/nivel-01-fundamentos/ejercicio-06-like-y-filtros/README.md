# Ejercicio 06 — LIKE y Filtros

- **Nivel:** 1/5
- **Tema:** Fundamentos de SQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Busca productos que empiecen con 'Te'
2. Busca productos que contengan 'ra'
3. Busca productos que terminen con 'o'
4. Busca productos con exactamente 6 caracteres en el nombre

## Requisitos

- [ ] La tabla/consulta se ajusta a lo pedido en el enunciado
- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Empiezan con 'Te'
SELECT * FROM productos WHERE nombre LIKE 'Te%';

-- Contienen 'ra'
SELECT * FROM productos WHERE nombre LIKE '%ra%';

-- Terminan con 'o'
SELECT * FROM productos WHERE nombre LIKE '%o';

-- Exactamente 6 caracteres
SELECT * FROM productos WHERE nombre LIKE '______';
```

</details>
