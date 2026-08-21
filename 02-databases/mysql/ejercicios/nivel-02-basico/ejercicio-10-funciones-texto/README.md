# Ejercicio 10 — Funciones de texto

- **Nivel:** 2/5
- **Tema:** Básico de MySQL
- **Tiempo estimado:** 20 minutos

## Enunciado

La tabla `usuarios` ya tiene datos. Aplica funciones de texto de MySQL.

1. Muestra el `nombre` en mayúsculas y la longitud del `email` (columnas: `nombre_mayus`, `email_len`).
2. Muestra las 3 primeras letras del `nombre` y el `email` en minúsculas (columnas: `iniciales`, `email_lower`).
3. Muestra el `nombre` con la letra 'a' reemplazada por '@' (columnas: `nombre_mod`).

Une los tres resultados con `UNION ALL` (todas devuelven 2 columnas de texto).

## Requisitos

- [ ] Usas `UPPER()`, `LOWER()`, `LENGTH()`, `SUBSTR()`, `REPLACE()`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `UPPER(nombre)` convierte a mayúsculas.
- `LENGTH(email)` devuelve la longitud en caracteres.
- `SUBSTR(nombre, 1, 3)` extrae los primeros 3 caracteres.
- `LOWER(email)` convierte a minúsculas.
- `REPLACE(nombre, 'a', '@')` reemplaza todas las 'a' por '@'.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
(SELECT UPPER(nombre) AS nombre_mayus, CAST(LENGTH(email) AS CHAR) AS email_len FROM usuarios ORDER BY id)
UNION ALL
(SELECT SUBSTR(nombre, 1, 3) AS iniciales, LOWER(email) AS email_lower FROM usuarios ORDER BY id)
UNION ALL
(SELECT REPLACE(nombre, 'a', '@') AS nombre_mod, nombre FROM usuarios ORDER BY id);
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-02-basico/ejercicio-10-funciones-texto
bash test.sh
```
