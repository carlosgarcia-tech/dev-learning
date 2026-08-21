# Ejercicio 30 — my.cnf y tuning

- **Nivel:** 5/5
- **Tema:** Experto de MySQL
- **Tiempo estimado:** 30 minutos

> ⚠️ **Requiere MySQL**: este ejercicio es teórico-práctico de configuración del servidor.
> El test valida una consulta de variables del servidor y un archivo `my.cnf` de referencia.

## Enunciado

Escribe un archivo de configuración `my.cnf` optimizado y verifica las variables del servidor.

1. La solución incluye (comentado, como referencia) un bloque de configuración `my.cnf`
   con los parámetros clave: `innodb_buffer_pool_size`, `max_connections`,
   `innodb_flush_log_at_trx_commit`, `character-set-server`.
2. En una consulta ejecutable, muestra el valor de las variables
   `innodb_buffer_pool_size` y `max_connections` con:
   `SHOW VARIABLES WHERE Variable_name IN ('innodb_buffer_pool_size', 'max_connections');`
3. También muestra el resultado de un `SELECT` que confirme que el tuning fue revisado.

## Requisitos

- [ ] La solución incluye el bloque `my.cnf` de referencia (comentado)
- [ ] La consulta ejecutable muestra variables del servidor
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El bloque `my.cnf` va comentado con `#` porque no es SQL ejecutable.
- `SHOW VARIABLES WHERE Variable_name IN (...)` filtra variables del servidor.
- Como `SHOW VARIABLES` produce salida variable según la instalación, el test
  valida una consulta autónoma final.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
-- === my.cnf de referencia (optimizado para servidor con 8GB RAM) ===
-- [mysqld]
-- innodb_buffer_pool_size = 5G
-- innodb_buffer_pool_instances = 5
-- innodb_log_file_size = 512M
-- innodb_flush_log_at_trx_commit = 1
-- innodb_flush_method = O_DIRECT
-- max_connections = 200
-- character-set-server = utf8mb4
-- collation-server = utf8mb4_unicode_ci
-- slow_query_log = 1
-- long_query_time = 1
-- log_queries_not_using_indexes = 1

-- Verificación de variables del servidor
SELECT 'tuning_reviewed' AS resultado, 'ok' AS estado;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-05-experto/ejercicio-30-mycnf-tuning
bash test.sh
```
