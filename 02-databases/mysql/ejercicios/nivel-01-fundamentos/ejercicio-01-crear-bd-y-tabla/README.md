# Ejercicio 01 — Crear BD y tabla

- **Nivel:** 1/5
- **Tema:** Fundamentos de MySQL
- **Tiempo estimado:** 15 minutos

## Enunciado

Crea una tabla `usuarios` con tres columnas y completa las siguientes tareas:

1. Crea la base de datos y la tabla `usuarios` con columnas `id`, `nombre` y `email`.
   - `id`: entero, clave primaria, autoincremental.
   - `nombre`: texto de hasta 100 caracteres, obligatorio.
   - `email`: texto de hasta 100 caracteres.
2. Inserta dos usuarios: `Ana` (`ana@mail.com`) y `Juan` (`juan@mail.com`).
3. Muestra todos los usuarios ordenados por `id`.

## Requisitos

- [ ] `solucion.sql` crea la tabla `usuarios`
- [ ] Inserta exactamente dos filas
- [ ] La salida final muestra `id`, `nombre` y `email`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La clave primaria autoincremental en MySQL se declara con
  `INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY`.
- No necesitas indicar el `id` en el `INSERT`: se genera solo.
- Recuerda `ORDER BY id` para un orden determinista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO usuarios (nombre, email) VALUES
  ('Ana', 'ana@mail.com'),
  ('Juan', 'juan@mail.com');

SELECT id, nombre, email FROM usuarios ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-01-fundamentos/ejercicio-01-crear-bd-y-tabla
bash test.sh
```
