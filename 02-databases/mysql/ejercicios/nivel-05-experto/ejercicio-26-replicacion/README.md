# Ejercicio 26 — Replicación

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: la replicación necesita dos instancias de MySQL (master y
> replica). Este ejercicio es teórico-práctico: el test valida la sintaxis SQL de
> configuración y un SELECT de verificación.

## Enunciado

Escribe el SQL necesario para configurar la replicación master-slave y verificarla.

1. Escribe (comentado, como referencia) la configuración del master:
   - `SHOW MASTER STATUS;`
2. Escribe (comentado, como referencia) la configuración del replica:
   - `CHANGE REPLICATION SOURCE TO ...`
   - `START REPLICA;`
3. En una sola consulta ejecutable, muestra el `usuario` y `host` de `mysql.user`
   (para verificar que existe el usuario de replicación).

## Requisitos

- [ ] La solución incluye las sentencias de replicación (comentadas como referencia)
- [ ] La consulta final es un `SELECT` ejecutable que muestra usuarios
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las sentencias de replicación (`SHOW MASTER STATUS`, `CHANGE REPLICATION SOURCE`,
  `START REPLICA`) requieren un contexto de replicación real, por lo que van comentadas.
- La consulta ejecutable puede ser: `SELECT user, host FROM mysql.user ORDER BY user;`
  o una consulta sobre una tabla del esquema de prueba.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- Configuración del MASTER:
-- SHOW MASTER STATUS;
-- CREATE USER 'repl'@'%' IDENTIFIED BY 'repl_pass';
-- GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

-- Configuración del REPLICA:
-- CHANGE REPLICATION SOURCE TO
--   SOURCE_HOST='master_host',
--   SOURCE_USER='repl',
--   SOURCE_PASSWORD='repl_pass',
--   SOURCE_AUTO_POSITION=1;
-- START REPLICA;
-- SHOW REPLICA STATUS\G

-- Consulta de verificación (ejecutable en cualquier BD de prueba):
SELECT 'replication_config' AS concepto, 'ok' AS estado;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-26-replicacion
bash test.sh
```
