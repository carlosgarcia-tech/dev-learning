# Ejercicios — Linux

Cada ejercicio vive en su propia carpeta con enunciado (`README.md`), archivos de soporte y un `test.sh` que valida el resultado de forma real con `bash test.sh`. Abre las **pistas** y la **solución** (plegables) solo después de intentarlo.

## Niveles

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | `pwd` y navegación, `ls` con opciones, creación de archivos/directorios, `cp`/`mv`, `rm` con cuidado, `cat`/`head`/`tail`, `find` básico, `grep` básico | ✅ |
| [nivel-02-basico](nivel-02-basico/) | permisos `chmod`, `chown`, enlaces simbólicos, `find` con criterios, `grep` avanzado, `tar` y compresión, redirección y *pipe* | ✅ |
| [nivel-03-intermedio](nivel-03-intermedio/) | procesos `ps`/`kill`, `systemd`/`systemctl`, `journalctl`, *bash* con `if`, *bash* con `for`, `ssh`/`scp` | ✅ |
| [nivel-04-avanzado](nivel-04-avanzado/) | `cron` y *systemd timers*, *firewall* `ufw`, `sed`, `awk`, script de monitorización, `lsof` y diagnóstico, `rsync` | ✅ |
| [nivel-05-experto](nivel-05-experto/) | script de *hardening*, *backup* con rotación, análisis de *logs* con `awk`, paralelismo con `xargs`, *systemd service* personalizado, diagnóstico de rendimiento con `strace` | ✅ |
| [proyectos](proyectos/) | Proyecto final: sistema de monitorización y *backups* automatizados | ✅ |

## Cómo ejecutar un test

```bash
cd 05-devops/linux/ejercicios/nivel-01-fundamentos/ejercicio-01-navegacion-pwd
bash test.sh
```

Salida esperada al pasar:

```
OK Tests pasaron
```

> Los tests crean un directorio temporal con `mktemp -d` y se ejecutan con `set -euo pipefail`. Salida `0` si pasan, `1` si fallan.
