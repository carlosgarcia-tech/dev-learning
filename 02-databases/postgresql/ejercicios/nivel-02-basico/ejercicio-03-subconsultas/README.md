# Ejercicio 03 — Subconsultas

- **Nivel:** 2/5
- **Tema:** Básico de PostgreSQL
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Libro(s) más reciente(s)
2. Autores con libros publicados después del 2000
3. Usuarios con préstamos activos

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT * FROM libros WHERE anio = (SELECT MAX(anio) FROM libros);

SELECT * FROM autores
WHERE id IN (SELECT autor_id FROM libros WHERE anio > 2000);

SELECT * FROM usuarios u
WHERE EXISTS (
    SELECT 1 FROM prestamos p
    WHERE p.usuario_id = u.id AND p.fecha_devolucion IS NULL
);
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-02-basico/ejercicio-03-subconsultas
bash test.sh
```
