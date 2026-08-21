# Ejercicio 03 — Replicación

- **Nivel:** 5/5
- **Tema:** Experto en PostgreSQL
- **Tiempo estimado:** 45 minutos

## Enunciado

1. Crear un rol de replicación y un replication slot
2. Consultar el estado de replicación y el lag

Este ejercicio requiere un segundo servidor/standby real para completarse
de punta a punta; aquí se practica la parte que sí se puede verificar en
un solo servidor: creación del rol, del slot, y las consultas de monitoreo
(que devuelven vacío si no hay standbys conectados, pero deben ejecutar sin
error).

## Requisitos

- [ ] El script `init.sql` crea el esquema necesario
- [ ] `solucion.sql` resuelve el enunciado
- [ ] Los tests pasan: `bash test.sh`

## Solución

<details>
<summary>Mostrar solución</summary>

```sql
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'replicator') THEN
        CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicapass';
    END IF;
END $$;

SELECT * FROM pg_create_physical_replication_slot('replica_slot')
WHERE NOT EXISTS (
    SELECT 1 FROM pg_replication_slots WHERE slot_name = 'replica_slot'
);

-- Monitoreo (vacio si no hay standbys conectados; eso es esperado en este entorno)
SELECT pid, usename, application_name, client_addr, state, sync_state
FROM pg_stat_replication;

SELECT slot_name, slot_type, active, restart_lsn
FROM pg_replication_slots;
```

</details>

## Ejecutar localmente

```bash
cd ejercicios/nivel-05-experto/ejercicio-03-replica
bash test.sh
```
