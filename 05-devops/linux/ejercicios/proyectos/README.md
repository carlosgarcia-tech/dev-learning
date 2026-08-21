# Proyecto Final — Sistema de monitorización y backups automatizados

- **Nivel:** Integrador (aplica todo lo aprendido)
- **Tiempo estimado:** 3-5 horas
- **Temas:** shell scripting, procesos, systemd timers, logs, backups, monitorización, rotación

## Contexto

Eres el administrador de un servidor Linux y necesitas construir un sistema **automatizado** que:

1. **Monitorice** el sistema (CPU, memoria, disco, procesos) y genere **alertas** cuando algún umbral se supere.
2. **Realice backups** diarios de un directorio, con **compresión** y **rotación** (borrado de copias antiguas).
3. **Orqueste** ambas tareas con **systemd timers** (sin intervención manual).
4. Mantenga **logs estructurados** de cada ejecución para auditoría.

Este proyecto integra comandos y conceptos de todas las guías: navegación de archivos, permisos, procesos, shell scripting (variables, control de flujo, funciones, arrays), pipes/redirección, `awk`/`sed`, `systemd`, `journalctl`, `cron`/timers, `tar`, `find` y `xargs`.

## Estructura esperada

```
proyectos/
├── README.md                  (este archivo)
├── test.sh                     (validación del proyecto)
├── bin/
│   ├── monitor.sh              (script de monitorización)
│   └── backup.sh               (script de backup con rotación)
├── systemd/
│   ├── monitor.service         (unit del monitor)
│   ├── monitor.timer           (timer del monitor)
│   ├── backup.service          (unit del backup)
│   └── backup.timer            (timer del backup)
├── config/
│   └── mon.conf                (umbrales y rutas configurables)
└── solucion/                   (solución de referencia)
    ├── monitor.sh
    ├── backup.sh
    ├── monitor.service
    ├── monitor.timer
    ├── backup.service
    └── backup.timer
```

## Requisitos funcionales

### 1. Script `monitor.sh` (monitorización)

- Lee configuración de `config/mon.conf` (variables: `ALERT_CPU`, `ALERT_MEM`, `ALERT_DISK`, `LOG_DIR`).
- Recoge métricas:
  - **CPU**: load average con `uptime` o `awk` de `/proc/loadavg`.
  - **Memoria**: `% usado` con `free` y `awk`.
  - **Disco**: `% usado` de `/` con `df` y `awk`.
  - **Procesos top**: los 5 que más CPU consumen con `ps aux`.
- Escribe una línea de log estructurada (JSON o clave=valor) en `$LOG_DIR/monitor.log` con timestamp y métricas.
- Si alguna métrica supera su umbral, añade una línea `ALERT` al log y crea un archivo `alert.flag`.

### 2. Script `backup.sh` (backup con rotación)

- Recibe `ORIGEN` y `DESTINO` (por argumento o desde `mon.conf`).
- Crea `backup-<timestamp>.tar.gz` en `DESTINO`.
- Registra la operación en `DESTINO/backup.log`.
- Elimina backups con más de `KEEP_DAYS` días (retención configurable, por defecto 7).
- No elimina el log ni archivos que no sean `backup-*.tar.gz`.

### 3. Systemd timers

- `monitor.timer`: ejecuta `monitor.sh` cada 5 minutos (`OnCalendar=*:0/5`).
- `backup.timer`: ejecuta `backup.sh` diariamente a las 02:00 (`OnCalendar=*-*-* 02:00:00`, `Persistent=true`).
- Ambos con `[Install] WantedBy=timers.target`.

### 4. Logs estructurados

- Cada ejecución de monitor y backup escribe una línea con: `timestamp`, `script`, `status` (OK/ALERT/ERROR) y métricas/ detalles.
- Formato sugerido (clave=valor): `2025-08-20T10:00:00 script=monitor status=OK cpu=0.45 mem=62 disk=78`

## Fases sugeridas

| Fase | Tarea | Verificación |
|---|---|---|
| 1 | Implementa `monitor.sh` con recolección de métricas | `bash bin/monitor.sh` y revisa `monitor.log` |
| 2 | Añade lógica de alertas (umbrales) y `alert.flag` | Configura umbrales bajos y comprueba que salta |
| 3 | Implementa `backup.sh` con `tar` y rotación | Ejecútalo 2 veces y verifica rotación |
| 4 | Crea los archivos `.service` y `.timer` de systemd | Valida sintaxis con `systemd-analyze verify` |
| 5 | Integra todo: logs estructurados coherentes | `bash test.sh` |

## Criterios de aceptación

- [ ] `bin/monitor.sh` existe, es ejecutable y genera una línea de log al ejecutarse.
- [ ] `bin/backup.sh` existe, es ejecutable y crea un `.tar.gz` con el contenido del origen.
- [ ] `backup.sh` elimina backups con más de `KEEP_DAYS` días.
- [ ] `config/mon.conf` define `ALERT_CPU`, `ALERT_MEM`, `ALERT_DISK`, `LOG_DIR`.
- [ ] `monitor.sh` lee la configuración de `mon.conf`.
- [ ] `monitor.sh` crea `alert.flag` cuando un umbral se supera.
- [ ] `systemd/monitor.timer` usa `OnCalendar=*:0/5`.
- [ ] `systemd/backup.timer` usa `OnCalendar=*-*-* 02:00:00` y `Persistent=true`.
- [ ] Los logs tienen formato estructurado (timestamp + campos).
- [ ] Los tests pasan: `bash test.sh`

## Cómo ejecutar los tests

```bash
cd 05-devops/linux/ejercicios/proyectos
bash test.sh
```

El test crea un entorno aislado, ejecuta los scripts y verifica los criterios de aceptación. Salida `0` si pasa, `1` si falla.

## Archivos starter

Se incluyen archivos **starter** en `bin/`, `systemd/` y `config/` con la estructura básica y comentarios `# TODO:` indicando lo que debes implementar. La solución de referencia está en `solucion/`.

> **Objetivo de aprendizaje:** completar los `TODO` de los archivos starter. Si te atascas, consulta `solucion/`.
