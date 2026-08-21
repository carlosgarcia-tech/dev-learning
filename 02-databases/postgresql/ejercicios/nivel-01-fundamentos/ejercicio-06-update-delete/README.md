# Ejercicio 06 — UPDATE y DELETE

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Actualizar la cantidad de un libro
2. Incrementar la cantidad de todos los libros en 1
3. Marcar un préstamo como devuelto
4. Eliminar un libro

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
UPDATE libros SET cantidad = cantidad + 2 WHERE id = 1;

UPDATE libros SET cantidad = cantidad + 1;

UPDATE prestamos SET fecha_devolucion = CURRENT_DATE WHERE id = 2;

-- Antes de borrar el libro 5, sus prestamos se eliminan en cascada
-- (ON DELETE CASCADE en la FK de prestamos.libro_id)
DELETE FROM libros WHERE id = 5;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-06-update-delete
bash test.sh
```
