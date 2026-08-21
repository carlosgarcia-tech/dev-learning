# Ejercicio 25 — EXPLAIN ANALYZE

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL 8.0+**: `EXPLAIN ANALYZE` es exclusivo de MySQL 8.0+. El
> `test.sh` requiere MySQL para validar este ejercicio.

## Enunciado

La tabla `productos` ya existe con datos y un índice sobre `categoria`. Usa
`EXPLAIN ANALYZE` y luego consulta los datos.

1. Ejecuta `EXPLAIN ANALYZE SELECT * FROM productos WHERE categoria = 'electronica';`
   (la salida de EXPLAIN ANALYZE es descriptiva y no se compara exactamente).
2. Muestra `id`, `nombre`, `precio` de los productos de `electronica`, ordenados por `precio DESC`.

## Requisitos

- [ ] La solución incluye `EXPLAIN ANALYZE`
- [ ] La consulta final devuelve los productos de electrónica
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `EXPLAIN ANALYZE SELECT ...` ejecuta la consulta y muestra tiempos reales.
- La salida es un árbol de operaciones con `actual time`, `rows`, `loops`.
- El test ejecuta EXPLAIN ANALYZE por separado (descarta su salida) y compara
  solo la consulta de datos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
EXPLAIN ANALYZE SELECT * FROM productos WHERE categoria = 'electronica';
SELECT id, nombre, precio FROM productos WHERE categoria = 'electronica' ORDER BY precio DESC;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-25-explain-analyze
bash test.sh
```
