# Ejercicio 07 — GROUP BY

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `ventas` ya tiene datos. Escribe las consultas pedidas, unidas con `UNION ALL`.

1. Total de ventas por `categoria` (columnas: `categoria`, `total`).
2. Cantidad de productos por `categoria` (columnas: `categoria`, `cantidad`).
3. Precio promedio por `categoria`, redondeado a 2 decimales (columnas: `categoria`, `promedio`).
4. Categorías con más de 1 producto (columnas: `categoria`, `cantidad`).

## Requisitos

- [ ] Usas `GROUP BY` y funciones de agregación (`SUM`, `COUNT`, `AVG`)
- [ ] Usas `HAVING` en la consulta 4
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `SUM(total)` calcula el total de un grupo.
- `COUNT(*)` cuenta las filas de cada grupo.
- `ROUND(AVG(precio), 2)` redondea el promedio a 2 decimales.
- `HAVING COUNT(*) > 1` filtra grupos con más de 1 elemento.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT categoria, SUM(total) AS total FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, COUNT(*) AS cantidad FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, ROUND(AVG(precio), 2) AS promedio FROM ventas GROUP BY categoria ORDER BY categoria)
UNION ALL
(SELECT categoria, COUNT(*) AS cantidad FROM ventas GROUP BY categoria HAVING COUNT(*) > 1 ORDER BY categoria);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-07-group-by
bash test.sh
```
