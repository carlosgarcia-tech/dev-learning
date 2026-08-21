# Ejercicio 03 — SELECT, WHERE y ORDER BY

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `empleados` ya contiene datos (ver `schema.sql`). Escribe las consultas solicitadas.
Concatena los resultados con `UNION ALL` para que `test.sh` valide todo en una sola salida.

1. Empleados del departamento `Ventas`, ordenados por `salario` descendente.
2. Empleados con salario mayor a `3000`, ordenados por `nombre` ascendente.
3. Empleados cuyo nombre empieza con `M`, ordenados por `id`.
4. Empleados activos (`activo = 1`), ordenados por `departamento` y luego por `nombre`.

## Requisitos

- [ ] Cada consulta devuelve `id`, `nombre`, `departamento`, `salario`
- [ ] Todas las consultas van separadas por `UNION ALL` en `solucion.sql`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `WHERE departamento = 'Ventas'` filtra por departamento.
- `ORDER BY salario DESC` ordena de mayor a menor.
- `LIKE 'M%'` filtra nombres que empiezan con M.
- Como las cuatro consultas tienen la misma forma de columnas, puedes unirlas con
  `UNION ALL`. Recuerda que `ORDER BY` aplica a cada subconsulta entre paréntesis
  cuando usas `UNION`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE departamento = 'Ventas' ORDER BY salario DESC)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE salario > 3000 ORDER BY nombre)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE nombre LIKE 'M%' ORDER BY id)
UNION ALL
(SELECT id, nombre, departamento, salario FROM empleados
 WHERE activo = 1 ORDER BY departamento, nombre);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-03-select-where-order
bash test.sh
```
