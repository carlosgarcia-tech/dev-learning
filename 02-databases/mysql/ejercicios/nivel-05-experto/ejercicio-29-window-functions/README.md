# Ejercicio 29 — Window functions (MySQL 8)

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL 8.0+ o SQLite 3.25+**: las window functions están disponibles
> en MySQL 8.0+ y en SQLite 3.25+. El `test.sh` funciona con ambos.

## Enunciado

La tabla `empleados` ya existe con datos. Usa window functions de MySQL 8.

1. Muestra `nombre`, `departamento`, `salario` y el ranking de salario dentro de cada
   departamento usando `RANK() OVER (PARTITION BY departamento ORDER BY salario DESC)`.
2. Ordena el resultado por `departamento` ascendente y luego por `salario` descendente.

## Requisitos

- [ ] Usas `RANK() OVER (PARTITION BY ... ORDER BY ...)`
- [ ] El resultado incluye el ranking como columna `ranking`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS ranking`
- Esta función asigna un ranking dentro de cada grupo (departamento).
- Los empates reciben el mismo ranking y se salta el siguiente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT
    nombre,
    departamento,
    salario,
    RANK() OVER (PARTITION BY departamento ORDER BY salario DESC) AS ranking
FROM empleados
ORDER BY departamento ASC, salario DESC;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-29-window-functions
bash test.sh
```
