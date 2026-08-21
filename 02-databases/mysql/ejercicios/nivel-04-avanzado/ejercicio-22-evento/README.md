# Ejercicio 22 — Evento

- **Nivel:** 4/5
- **Tema:** Avanzado de MySQL
- **Tiempo estimado:** 25 minutos

> ⚠️ **Requiere MySQL**: los eventos programados son específicos de MySQL. El `test.sh`
> requiere MySQL para validar este ejercicio.

## Enunciado

La tabla `logs` ya existe. Crea un evento que elimine logs antiguos y verifica la creación.

1. Activa el event scheduler con `SET GLOBAL event_scheduler = ON;`.
2. Crea un evento `ev_limpiar_logs` que se ejecute cada hora (`EVERY 1 HOUR`) y borre
   los logs con más de 7 días: `DELETE FROM logs WHERE fecha < DATE_SUB(NOW(), INTERVAL 7 DAY);`.
3. Muestra los eventos creados con `SELECT event_name FROM information_schema.events;`.
4. Muestra todos los logs restantes (columnas: `id`, `mensaje`, `fecha`).

## Requisitos

- [ ] Usas `SET GLOBAL event_scheduler = ON`
- [ ] Usas `CREATE EVENT ... ON SCHEDULE EVERY 1 HOUR`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `SET GLOBAL event_scheduler = ON;` activa el planificador.
- `CREATE EVENT nombre ON SCHEDULE EVERY 1 HOUR DO DELETE FROM ...;`
- La consulta a `information_schema.events` lista los eventos creados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
SET GLOBAL event_scheduler = ON;
CREATE EVENT ev_limpiar_logs
ON SCHEDULE EVERY 1 HOUR
DO
  DELETE FROM logs WHERE fecha < DATE_SUB(NOW(), INTERVAL 7 DAY);
SELECT event_name FROM information_schema.events;
SELECT id, mensaje, fecha FROM logs ORDER BY id;
```

</details>

## Ejecutar localmente

```bash
cd 02-databases/mysql/ejercicios/nivel-04-avanzado/ejercicio-22-evento
bash test.sh
```
