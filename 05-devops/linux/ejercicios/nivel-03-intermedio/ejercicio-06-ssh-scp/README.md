# Ejercicio 06 — Copia remota con `scp` y `ssh`

- **Nivel:** 3/5
- **Tema:** `ssh`, `scp`, `ssh-keygen`, claves, ejecución remota
- **Tiempo estimado:** 30 min

## Enunciado

Escribe `solucion.sh` que demuestre el uso de SSH y SCP para copiar archivos a un host remoto.

Para que el ejercicio sea ejecutable sin un servidor externo, se usará como "remoto" el propio equipo con la forma `localhost` (requiere tener `sshd` escuchando en el puerto 22).

El script debe:

1. Verificar que `ssh` y `scp` existen; si no, imprimir `SSH no disponible` y salir con código `0` (no falla el test por falta de SSH).
2. Intentar ejecutar `ssh localhost "echo CONEXION_OK"` y guardar la salida en `conexion.txt`.
3. Si la conexión falla (sin servidor o sin claves), crear `conexion.txt` con `SIN_CONEXION` y salir con `0`.
4. Si la conexión funciona, crear un archivo local `datos.txt` con contenido `hola` y copiarlo con `scp datos.txt localhost:/tmp/` (solo si `/tmp` es escribible).

> El test detecta si SSH está operativo en `localhost`; si no lo está, verifica que el script maneja el error con elegancia (crea `conexion.txt` con `SIN_CONEXION`).

## Requisitos

- [ ] El script no aborta aunque SSH no esté disponible.
- [ ] `conexion.txt` existe y contiene `CONEXION_OK` o `SIN_CONEXION`.
- [ ] Si SSH funciona, el archivo se copia a `/tmp` del remoto.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `command -v ssh` comprueba si el comando existe.
- `ssh localhost "echo CONEXION_OK"` ejecuta un comando remoto.
- Envuelve la conexión en un `if ssh ... 2>/dev/null; then ... else ... fi`.
- `scp datos.txt localhost:/tmp/` copia un archivo por SSH.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

if ! command -v ssh >/dev/null 2>&1 || ! command -v scp >/dev/null 2>&1; then
  echo "SSH no disponible"
  echo "SIN_CONEXION" > conexion.txt
  exit 0
fi

if ssh -o BatchMode=yes -o ConnectTimeout=3 localhost "echo CONEXION_OK" > conexion.txt 2>/dev/null; then
  echo "hola" > datos.txt
  scp -o BatchMode=yes -o ConnectTimeout=3 datos.txt localhost:/tmp/ 2>/dev/null || true
else
  echo "SIN_CONEXION" > conexion.txt
fi

exit 0
```

> `BatchMode=yes` evita que SSH se quede colgado pidiendo contraseña (usa solo claves).

</details>
