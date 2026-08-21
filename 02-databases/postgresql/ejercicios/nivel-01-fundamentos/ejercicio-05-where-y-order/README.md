# Ejercicio 05 — WHERE y ORDER

- **Nivel:** 1/5
- **Tema:** Fundamentos de PostgreSQL
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Libros con cantidad > 5
2. Libros publicados después del año 2000
3. Libros ordenados por título
4. Autores ordenados por fecha_nacimiento descendente

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SELECT * FROM libros WHERE cantidad > 5;
SELECT * FROM libros WHERE anio > 2000;
SELECT * FROM libros ORDER BY titulo;
SELECT * FROM autores ORDER BY fecha_nacimiento DESC;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-05-where-y-order
bash test.sh
```
