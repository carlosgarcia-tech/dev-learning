# Ejercicio 14 — Índice

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `empleados` ya existe con datos. Crea un índice y verifica su uso.

1. Crea un índice llamado `idx_departamento` sobre la columna `departamento`.
2. Consulta los empleados del departamento `IT` (muestra `id`, `nombre`, `departamento`).

## Requisitos

- [ ] Usas `CREATE INDEX`
- [ ] La consulta final filtra por `departamento = 'IT'`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CREATE INDEX idx_departamento ON empleados (departamento);` crea el índice.
- El índice acelera las búsquedas por `departamento`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE INDEX idx_departamento ON empleados (departamento);
SELECT id, nombre, departamento FROM empleados WHERE departamento = 'IT' ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-14-indice
bash test.sh
```
