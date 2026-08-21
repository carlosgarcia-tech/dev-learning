# Ejercicio 11 — Funciones de fecha

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

> ⚠️ **Requiere MySQL**: este ejercicio usa funciones de fecha específicas de MySQL
> (`YEAR`, `MONTH`) que no existen en SQLite. Si no tienes MySQL instalado,
> `test.sh` intenta una adaptación con `strftime` de SQLite.

## Enunciado

La tabla `pedidos` ya tiene datos con fechas. Usa funciones de fecha de MySQL.

1. Muestra el `id` y el `año` de la fecha del pedido (columnas: `id`, `anio`).
2. Muestra el `id` y el `mes` de la fecha del pedido (columnas: `id`, `mes`).

Une los dos resultados con `UNION ALL`.

## Requisitos

- [ ] Usas `YEAR()` y `MONTH()`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `YEAR(fecha)` extrae el año de una fecha.
- `MONTH(fecha)` extrae el mes (1-12).
- Como `UNION ALL` requiere el mismo tipo en todas las columnas, convierte los
  números a texto con `CAST(... AS CHAR)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT id, CAST(YEAR(fecha) AS CHAR) AS anio FROM pedidos ORDER BY id)
UNION ALL
(SELECT id, CAST(MONTH(fecha) AS CHAR) AS mes FROM pedidos ORDER BY id);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-11-funciones-fecha
bash test.sh
```
