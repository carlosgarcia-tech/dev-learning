# Ejercicio 06 — Constraints

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Agregar CHECK para año (1900-año actual)
2. Agregar UNIQUE para la combinación (libro_id, usuario_id, fecha_prestamo) en préstamos
3. Confirmar el DEFAULT de fecha_registro en usuarios

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Notas

El material original proponía `UNIQUE (libro_id, usuario_id)`, pero eso impediría que el mismo usuario pidiera prestado el mismo libro dos veces en momentos distintos (un caso perfectamente válido). Se cambia a `UNIQUE (libro_id, usuario_id, fecha_prestamo)` para evitar solo el duplicado exacto.
## Solución

<details>
<summary>Mostrar solución</summary>

```sql
ALTER TABLE libros DROP CONSTRAINT IF EXISTS libros_anio_check;
ALTER TABLE libros
ADD CONSTRAINT libros_anio_check
CHECK (anio >= 1900 AND anio <= EXTRACT(YEAR FROM CURRENT_DATE));

ALTER TABLE prestamos
ADD CONSTRAINT prestamos_libro_usuario_fecha_unique
UNIQUE (libro_id, usuario_id, fecha_prestamo);

ALTER TABLE usuarios
ALTER COLUMN fecha_registro SET DEFAULT CURRENT_TIMESTAMP;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-06-constraints
bash test.sh
```
