# Ejercicio 02 — INSERT

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 15 minutos

## Enunciado

La tabla `productos` ya existe (ver `schema.sql`). Tu tarea es insertar filas y consultarlas.

1. Inserta estos tres productos:
   - `Mouse`, precio `25.50`, stock `100`
   - `Teclado`, precio `45.00`, stock `50`
   - `Monitor`, precio `300.00`, stock `20`
2. Muestra `id`, `nombre`, `precio` y `stock` de todos los productos ordenados por `id`.

## Requisitos

- [ ] `solucion.sql` inserta exactamente tres productos
- [ ] No indicas el `id` manualmente (lo genera AUTO_INCREMENT)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Puedes insertar múltiples filas con una sola sentencia:
  `INSERT INTO tabla (col1, col2) VALUES (...), (...), (...);`
- La columna `id` es `AUTO_INCREMENT`: no la incluyas en el `INSERT`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
INSERT INTO productos (nombre, precio, stock) VALUES
  ('Mouse',   25.50, 100),
  ('Teclado', 45.00,  50),
  ('Monitor', 300.00, 20);

SELECT id, nombre, precio, stock FROM productos ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-02-insert
bash test.sh
```
