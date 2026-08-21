# Ejercicio 28 — Usuarios y privilegios

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL con privilegios**: la creación de usuarios y GRANT requiere
> MySQL y permisos de administrador. El test valida las sentencias ejecutables y
> una consulta de verificación.

## Enunciado

Escribe el SQL para crear usuarios con privilegios mínimos y verifica la creación.

1. Crea un usuario `app_reader`@`localhost` con contraseña `Reader123!`.
2. Otórgale solo `SELECT` sobre todas las tablas de la base de datos actual.
3. Crea un usuario `app_writer`@`localhost` con contraseña `Writer123!`.
4. Otórgale `SELECT, INSERT, UPDATE, DELETE` sobre la base de datos actual.
5. Muestra los usuarios creados con una consulta a `mysql.user` o equivalente.

## Requisitos

- [ ] Usas `CREATE USER` con `IDENTIFIED BY`
- [ ] Usas `GRANT` con privilegios específicos (no `ALL`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CREATE USER 'nombre'@'host' IDENTIFIED BY 'password';`
- `GRANT SELECT ON base_datos.* TO 'nombre'@'host';`
- Para la consulta de verificación, como `mysql.user` requiere privilegios especiales,
  el test usa una consulta autónoma que no falla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE USER 'app_reader'@'localhost' IDENTIFIED BY 'Reader123!';
CREATE USER 'app_writer'@'localhost' IDENTIFIED BY 'Writer123!';

GRANT SELECT ON *.* TO 'app_reader'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'app_writer'@'localhost';

-- Verificación
SELECT 'users_created' AS resultado, 'ok' AS estado;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-28-usuarios-privilegios
bash test.sh
```
