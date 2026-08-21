# Ejercicio 15 — Vista

- **Nivel:** 3/5
- **Tema:** Intermedio de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `productos` ya existe con datos. Crea una vista y consúltala.

1. Crea una vista llamada `vw_productos_caros` que seleccione `id`, `nombre` y `precio`
   de los productos con `precio > 100`.
2. Consulta la vista: `SELECT * FROM vw_productos_caros ORDER BY precio DESC;`

## Requisitos

- [ ] Usas `CREATE VIEW`
- [ ] La vista filtra por `precio > 100`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CREATE VIEW nombre AS SELECT ... WHERE ...;` define la vista.
- Después puedes hacer `SELECT * FROM nombre_vista` como si fuera una tabla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE VIEW vw_productos_caros AS
  SELECT id, nombre, precio FROM productos WHERE precio > 100;

SELECT * FROM vw_productos_caros ORDER BY precio DESC;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-03-intermedio/ejercicio-15-vista
bash test.sh
```
