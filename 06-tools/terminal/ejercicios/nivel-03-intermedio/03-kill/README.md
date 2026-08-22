# 03 — kill y señales

## Enunciado

Gestiona procesos con kill.

## Requisitos

1. Explica en `respuesta.txt` la diferencia entre `kill` (SIGTERM) y `kill -9` (SIGKILL).
2. Menciona cuándo usar cada uno.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
kill (SIGTERM): pide al proceso que cierre ordenadamente. Se puede capturar.
kill -9 (SIGKILL): mata inmediatamente, no se puede capturar ni evitar. Último recurso.
Usar SIGTERM primero; si no responde en unos segundos, SIGKILL.
```

</details>
