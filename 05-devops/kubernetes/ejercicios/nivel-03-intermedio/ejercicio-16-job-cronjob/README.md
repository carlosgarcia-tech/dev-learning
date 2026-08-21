# Ejercicio 16 - Job y CronJob

- **Nivel:** 3/5
- **Tema:** Tareas batch con Job y CronJob
- **Tiempo estimado:** 25 min

## Enunciado

No todas las cargas de K8s son servicios siempre activos (Deployments). Algunas son **tareas batch** que se ejecutan, terminan y se van. Para eso existen:

- **Job**: ejecuta uno o varios pods y espera a que terminen con éxito. Ideal para migraciones, procesamiento, cálculos.
- **CronJob**: ejecuta Jobs en un horario programado (sintaxis cron). Ideal para backups diarios, limpieza periódica, reportes.

En este ejercicio vas a crear ambos:

1. Un **Job** `db-migration` que simula una migración de base de datos:
   - `completions: 1` y `parallelism: 1`
   - `backoffLimit: 3`
   - `restartPolicy: OnFailure`
   - imagen `busybox:1.36`
   - command: `["sh", "-c", "echo 'Ejecutando migración...' && sleep 5 && echo 'Migración completada'"]`

2. Un **CronJob** `backup-db` que simula un backup diario de base de datos:
   - `schedule: "0 2 * * *"` (todos los días a las 2:00 AM)
   - `jobTemplate` con `restartPolicy: OnFailure`
   - imagen `busybox:1.36`
   - command: `["sh", "-c", "echo 'Iniciando backup...' && sleep 3 && echo 'Backup completado'"]`

## Requisitos

- [ ] Existe un Job `db-migration` con `completions: 1`, `parallelism: 1` y `backoffLimit: 3`.
- [ ] El Job usa `restartPolicy: OnFailure` e imagen `busybox:1.36`.
- [ ] El Job define un `command` (no solo `image`).
- [ ] Existe un CronJob `backup-db` con `schedule: "0 2 * * *"`.
- [ ] El CronJob define `jobTemplate` con `restartPolicy: OnFailure` e imagen `busybox:1.36`.
- [ ] El CronJob define un `command` en el contenedor.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un Job no tiene `replicas`; tiene `completions` (cuántos pods deben terminar con éxito) y `parallelism` (cuántos a la vez).
- `backoffLimit` es cuántos reintentos se permiten antes de marcar el Job como fallido.
- Un CronJob es como un Job "envuelto": la plantilla del Job va dentro de `spec.jobTemplate.spec`.
- La sintaxis cron `0 2 * * *` son 5 campos: minuto, hora, día-del-mes, mes, día-de-la-semana.
- `restartPolicy` a nivel de pod en Jobs/CronJobs debe ser `OnFailure` o `Never` (nunca `Always`, que es el default de Deployments).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  completions: 1
  parallelism: 1
  backoffLimit: 3
  template:
    spec:
      restartPolicy: OnFailure
      containers:
        - name: migration
          image: busybox:1.36
          command: ["sh", "-c", "echo 'Ejecutando migración...' && sleep 5 && echo 'Migración completada'"]
```

```yaml
# cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-db
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: backup
              image: busybox:1.36
              command: ["sh", "-c", "echo 'Iniciando backup...' && sleep 3 && echo 'Backup completado'"]
```

</details>
