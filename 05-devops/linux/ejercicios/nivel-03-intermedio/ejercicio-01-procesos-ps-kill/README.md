# Ejercicio 01 — Procesos con `ps` y `kill`

- **Nivel:** 3/5
- **Tema:** `ps`, `grep`, `kill`, señales, PID
- **Tiempo estimado:** 25 min

## Enunciado

Escribe un script `solucion.sh` que:

1. Lanza en segundo plano un proceso `sleep 300` y guarda su PID en una variable.
2. Lista con `ps` solo ese proceso (filtrando por su PID) y guarda la salida en `proceso.txt`.
3. Comprueba con `kill -0 $PID` si el proceso sigue vivo y escribe `vivo` o `muerto` en `estado.txt`.
4. Envía `SIGTERM` al proceso con `kill $PID`.
5. Vuelve a comprobar y escribe en `estado_final.txt` si está `vivo` o `muerto`.
6. Además, lista los procesos `sleep` del sistema con `ps aux | grep` y guárdalo en `todos_sleep.txt` (si no hay ninguno, el archivo puede quedar vacío o con la línea del propio `grep`).

> El script debe funcionar aunque se ejecute con `set -e` en el test (usa `|| true` donde pueda fallar).

## Requisitos

- [ ] `proceso.txt` contiene una línea con el PID del `sleep` lanzado.
- [ ] `estado.txt` contiene `vivo`.
- [ ] Tras enviar `SIGTERM`, `estado_final.txt` contiene `muerto`.
- [ ] `todos_sleep.txt` existe.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `sleep 300 &` lanza en segundo plano; `$!` da el PID del último proceso en background.
- `ps -p $PID > proceso.txt` lista ese proceso.
- `kill -0 $PID` devuelve 0 si existe (vivo) y ≠0 si no. Úsalo en un `if`.
- `kill $PID` envía `SIGTERM` (15) por defecto.
- `ps aux | grep "[s]leep"` filtra procesos sleep (el truco `[s]` evita que grep se muestre a sí mismo).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

sleep 300 &
PID=$!
ps -p "$PID" > proceso.txt

if kill -0 "$PID" 2>/dev/null; then
  echo "vivo" > estado.txt
else
  echo "muerto" > estado.txt
fi

kill "$PID" 2>/dev/null || true
sleep 0.5

if kill -0 "$PID" 2>/dev/null; then
  echo "vivo" > estado_final.txt
else
  echo "muerto" > estado_final.txt
fi

ps aux | grep "[s]leep" > todos_sleep.txt || true
```

</details>
