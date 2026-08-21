# Ejercicio 27 — Backup con mysqldump

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 25 minutos

> ⚠️ **Requiere MySQL**: `mysqldump` es una herramienta de línea de comandos de MySQL.
> Este ejercicio es teórico-práctico: el test valida la estructura de la BD y un
-- SELECT de verificación, simulando un ciclo de backup/restore.

## Enunciado

La tabla `clientes` ya existe con datos. Simula un ciclo de backup y restore.

1. La solución crea una tabla `clientes_backup` con la misma estructura que `clientes`
   y copia todos los datos (simulando un dump + restore).
2. Muestra `id`, `nombre`, `email` de `clientes_backup` ordenados por `id`.

## Requisitos

- [ ] Usas `CREATE TABLE ... LIKE` o `CREATE TABLE` equivalente para el backup
- [ ] Copias los datos con `INSERT INTO ... SELECT`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CREATE TABLE clientes_backup LIKE clientes;` crea una tabla con la misma estructura.
- `INSERT INTO clientes_backup SELECT * FROM clientes;` copia todos los datos.
- En la práctica real, harías `mysqldump -u root -p tienda clientes > backup.sql`
  y luego `mysql -u root -p tienda < backup.sql`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
CREATE TABLE clientes_backup LIKE clientes;
INSERT INTO clientes_backup SELECT * FROM clientes;
SELECT id, nombre, email FROM clientes_backup ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-27-backup-mysqldump
bash test.sh
```
