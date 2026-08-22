# Ejercicio 05 — Diseño de sistema 12-factor

- **Nivel:** 5/5
- **Tema:** 12-factor app — aplicación cloud-native
- **Tiempo estimado:** 50 min

## Enunciado

Diseña y valida una aplicación que cumpla los **12 factores**. El entregable es un `solucion.json` que describe cómo se aplica cada factor, y un `app.js` (starter) que ejemplifica stateless, config en entorno y logs a stdout.

Pasos:

1. Examina `estructura.json` (lista los 12 factores).
2. Completa `solucion.json` describiendo cómo se aplica cada factor.
3. Examina `app.js` (ya presente) que ejemplifica los factores clave.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.json` describe los 12 factores (I a XII) con cómo se aplica cada uno
- [ ] `app.js` lee config del entorno (III Config) y NO tiene secrets en código
- [ ] `app.js` es stateless (VI Processes): no guarda estado en memoria entre peticiones
- [ ] `app.js` saca logs a stdout (IX Logs), no a archivo
- [ ] `estructura.json` lista los 12 factores
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los 12 factores: I Codebase, II Dependencies, III Config, IV Backing services, V Build/release/run, VI Processes, VII Port binding, VIII Concurrency, IX Disposability, X Logs, XI Admin processes, XII Dev/prod parity.
- En `solucion.json`, cada factor tiene `{"factor": "...", "aplicacion": "..."}`.
- `app.js`: `const PORT = process.env.PORT || 3000; const DB = process.env.DATABASE_URL;` (III Config).
- Logs: `console.log(JSON.stringify({...}))` a stdout (IX Logs).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.json` (parcial):

```json
{
  "factores": [
    { "id": "I", "nombre": "Codebase", "aplicacion": "1 repo git, múltiples despliegues (dev, staging, prod)" },
    { "id": "II", "nombre": "Dependencies", "aplicacion": "package.json declara dependencias; npm ci instala reproducible" },
    { "id": "III", "nombre": "Config", "aplicacion": "DATABASE_URL y JWT_SECRET en variables de entorno, no en código" },
    { "id": "IV", "nombre": "Backing services", "aplicacion": "BD y Redis tratados como recursos via URLs en env" },
    { "id": "V", "nombre": "Build/release/run", "aplicacion": "CI build imagen, release taggea, run arranca contenedor" },
    { "id": "VI", "nombre": "Processes", "aplicacion": "app stateless; sesión en Redis, no en memoria del proceso" },
    { "id": "VII", "nombre": "Port binding", "aplicacion": "la app escucha PORT (process.env.PORT) y es el servidor" },
    { "id": "VIII", "nombre": "Concurrency", "aplicacion": "escala horizontal con N procesos workers tras un LB" },
    { "id": "IX", "nombre": "Disposability", "aplicacion": "arranque rápido y shutdown limpio (graceful)" },
    { "id": "X", "nombre": "Logs", "aplicacion": "logs a stdout en JSON; el runtime los recolecta" },
    { "id": "XI", "nombre": "Admin processes", "aplicacion": "migraciones como procesos 1-off: npm run migrate" },
    { "id": "XII", "nombre": "Dev/prod parity", "aplicacion": "mismo stack en dev y prod (docker compose)" }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
