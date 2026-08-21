# Ejercicio 18 — EXPLAIN

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 25 minutos

## Enunciado

La tabla `productos` ya existe con datos y un índice sobre `categoria`. Usa `EXPLAIN`
para inspeccionar el plan de ejecución, y luego una consulta normal.

1. Ejecuta `EXPLAIN SELECT * FROM productos WHERE categoria = 'electronica';`
   (la salida de EXPLAIN varía entre versiones, así que el test no la compara exactamente).
2. Muestra `id`, `nombre`, `categoria`, `precio` de los productos de `electronica`,
   ordenados por `precio DESC`.

## Requisitos

- [ ] La solución incluye una sentencia `EXPLAIN` (MySQL la ejecuta; SQLite también la soporta)
- [ ] La consulta final devuelve los productos de electrónica
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `EXPLAIN SELECT ...` muestra el plan de ejecución sin ejecutar la consulta realmente.
- En el plan, la columna `type` debería ser `ref` (uso de índice) en lugar de `ALL` (full scan).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
EXPLAIN SELECT * FROM productos WHERE categoria = 'electronica';
SELECT id, nombre, categoria, precio FROM productos
WHERE categoria = 'electronica' ORDER BY precio DESC;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-18-explain
bash test.sh
```
