# 06 — Replicación y Alta Disponibilidad

> Esta guía no tenía contenido en el material original (aparecía en el
> árbol de directorios pero sin desarrollar); se añade aquí para completar
> el curso.

## Objetivos

- [ ] Entender streaming replication vs logical replication
- [ ] Configurar un servidor standby físico
- [ ] Crear y monitorear replication slots
- [ ] Entender failover y promoción de un standby
- [ ] Conocer herramientas de alta disponibilidad (Patroni, repmgr, pgpool-II)

## Apuntes

### Streaming replication vs logical replication

- **Streaming (física)**: replica el WAL byte a byte. El standby es una
  copia exacta del primario (mismo esquema, mismos datos, misma versión de
  PostgreSQL). Ideal para failover y lectura escalable (réplicas de solo
  lectura).
- **Logical**: replica cambios a nivel de fila, publicados por tabla/
  esquema. Permite replicar entre versiones distintas de PostgreSQL,
  replicar solo un subconjunto de tablas, o alimentar un data warehouse.

### Configurar un standby físico (streaming replication)

En el **primario** (`postgresql.conf`):

```conf
wal_level = replica
max_wal_senders = 10
max_replication_slots = 10
```

Crear un rol de replicación y un slot:

```sql
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicapass';
SELECT * FROM pg_create_physical_replication_slot('replica_slot');
```

En `pg_hba.conf` del primario, permitir la conexión de replicación:

```
host    replication     replicator      standby_ip/32       scram-sha-256
```

Clonar el primario hacia el standby:

```bash
pg_basebackup -h primary_host -U replicator -D /var/lib/postgresql/14/main \
  -Fp -Xs -P -R --slot=replica_slot
```

El flag `-R` genera automáticamente la configuración de conexión al
primario (`primary_conninfo`) y crea `standby.signal` (PostgreSQL 12+), que
marca ese nodo como standby.

### Logical replication

```sql
-- En el nodo publicador
CREATE PUBLICATION mi_publicacion FOR TABLE pedidos, clientes;

-- En el nodo suscriptor
CREATE SUBSCRIPTION mi_suscripcion
    CONNECTION 'host=primary_host dbname=mi_bd user=replicator password=replicapass'
    PUBLICATION mi_publicacion;
```

### Monitorear replicación

```sql
-- En el primario: estado de cada standby conectado
SELECT pid, usename, application_name, client_addr, state, sync_state,
       sent_lsn, write_lsn, flush_lsn, replay_lsn, replay_lag
FROM pg_stat_replication;

-- Replication slots (activos u obsoletos)
SELECT slot_name, slot_type, active, restart_lsn, confirmed_flush_lsn
FROM pg_replication_slots;

-- En el standby: ¿estamos en modo recuperación?
SELECT pg_is_in_recovery();

-- Retraso de aplicación de WAL en el standby
SELECT now() - pg_last_xact_replay_timestamp() AS replication_delay;
```

> Cuidado con los replication slots "olvidados": si un standby se cae y su
> slot se queda activo pero nadie consume el WAL, el primario retiene
> segmentos de WAL indefinidamente y puede llenar el disco. Monitorea
> `pg_replication_slots.active` y el tamaño de `pg_wal/`.

### Failover y promoción

```bash
# En el standby, promoverlo a primario
pg_ctl promote -D /var/lib/postgresql/14/main
# o, dentro de psql:
SELECT pg_promote();
```

El failover manual requiere además redirigir a las aplicaciones/clientes
hacia el nuevo primario (DNS, proxy, o un pooler consciente de topología).

### Herramientas de alta disponibilidad

- **Patroni**: orquestador de HA basado en un almacén de consenso (etcd,
  Consul o ZooKeeper) que gestiona failover automático.
- **repmgr**: gestiona y monitorea clusters de streaming replication,
  con soporte de failover asistido/automático.
- **pgpool-II / PgBouncer**: connection pooling; pgpool-II también puede
  hacer balanceo de lectura entre réplicas.

## Ejercicios relacionados

- [Ejercicio 27: Replicación](./ejercicios/nivel-05-experto/ejercicio-03-replica/)
