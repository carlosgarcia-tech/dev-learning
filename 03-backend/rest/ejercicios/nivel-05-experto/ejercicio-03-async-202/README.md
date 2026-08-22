# Ejercicio 03 — Async operations con 202

- **Nivel:** 5/5
- **Tema:** Operaciones asíncronas (202 Accepted + polling)
- **Tiempo estimado:** 30 min

## Enunciado

Un cliente solicita `POST /reports` para generar un reporte mensual (operación larga). Implementa:

1. `respuesta_202.json`: la respuesta inmediata con **202 Accepted** y `Location` apuntando al job.
2. `respuesta_running.json`: el estado del job mientras se procesa (status `running`, con `progress`).
3. `respuesta_completed.json`: el estado cuando termina (status `completed`, con `result`).

## Requisitos

- [ ] `respuesta_202.json`: status **202**, `headers.Location` apunta a `/jobs/{id}`, body con `jobId`, `status: "pending"`, `statusUrl`
- [ ] `respuesta_running.json`: status **200**, body con `status: "running"` y `progress` (0-100)
- [ ] `respuesta_completed.json`: status **200**, body con `status: "completed"` y `result.reportUrl`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 202 Accepted = "recibí tu petición, la estoy procesando asíncronamente".
- `Location` apunta a un recurso de estado que el cliente consulta (polling).
- Estados: `pending` → `running` → `completed` | `failed`.
- Alternativa al polling: un webhook que el servidor invoca al terminar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_202.json`:
````json
{
  "status": 202,
  "headers": { "Content-Type": "application/json", "Location": "/jobs/job_abc123" },
  "body": { "jobId": "job_abc123", "status": "pending", "statusUrl": "/jobs/job_abc123" }
}
````

`respuesta_running.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "jobId": "job_abc123", "status": "running", "progress": 45 }
}
````

`respuesta_completed.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": {
    "jobId": "job_abc123",
    "status": "completed",
    "progress": 100,
    "result": { "reportUrl": "/reports/rpt_789" }
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
