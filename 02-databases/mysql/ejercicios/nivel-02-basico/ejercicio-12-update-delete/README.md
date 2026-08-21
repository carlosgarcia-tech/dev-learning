# Ejercicio 12 — UPDATE y DELETE

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `productos` ya tiene datos. Modifica y elimina filas, luego consulta el resultado final.

1. Sube el precio de todos los productos de la categoría `electronica` un 10%.
2. Elimina los productos con `stock = 0`.
3. Muestra `id`, `nombre`, `precio`, `stock` ordenados por `id`.

## Requisitos

- [ ] Usas `UPDATE` con cálculo (`precio = precio * 1.10`)
- [ ] Usas `DELETE` con condición (`WHERE stock = 0`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `UPDATE productos SET precio = precio * 1.10 WHERE categoria = 'electronica';`
- `DELETE FROM productos WHERE stock = 0;`
- Ejecuta el `SELECT` final después de las modificaciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
UPDATE productos SET precio = precio * 1.10 WHERE categoria = 'electronica';
DELETE FROM productos WHERE stock = 0;
SELECT id, nombre, precio, stock FROM productos ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-12-update-delete
bash test.sh
```
