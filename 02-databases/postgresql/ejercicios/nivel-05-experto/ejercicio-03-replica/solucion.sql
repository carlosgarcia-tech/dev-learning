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
