# Linux

> Guía de estudio + ejercicios por niveles para dominar el sistema operativo Linux desde cero hasta nivel administrador.

Linux es el núcleo (*kernel*) sobre el que se construyen la inmensa mayoría de servidores, contenedores y herramientas DevOps del mundo real. En esta ruta aprendes a moverte por la terminal, administrar archivos y permisos, gestionar procesos y servicios, automatizar con *shell scripting* y mantener un sistema en producción.

---

## Guías de estudio

| # | Guía | Qué cubre | Estado |
|---|---|---|---|
| 01 | [Fundamentos](01-fundamentos.md) | Qué es Linux, distribuciones, terminal y *shell*, prompt, comandos básicos, rutas, `man`/`--help`, *tab completion*, histórico, *globbing*, expansiones, *alias* | ✅ |
| 02 | [Archivos y permisos](02-archivos-y-permisos.md) | FHS, lectura (`cat`/`less`/`head`/`tail`), búsqueda (`find`/`locate`/`grep`), permisos `rwx`, `chmod`, `chown`/`chgrp`, `umask`, enlaces, permisos especiales, atributos | ✅ |
| 03 | [Procesos y sistema](03-procesos-y-sistema.md) | Procesos (`ps`/`top`/`htop`), señales (`kill`), *jobs*, prioridad (`nice`), `systemd`/`systemctl`, `journalctl`, memoria (`free`), disco (`df`/`du`), usuarios y grupos, paquetes | ✅ |
| 04 | [Red y shell scripting](04-red-y-shell-scripting.md) | Red (`ip`/`ping`/`curl`/`wget`), puertos (`ss`), DNS (`dig`), SSH, *firewall* `ufw`/`iptables`; *bash scripting*: variables, argumentos, control de flujo, funciones, *pipes*, redirección, `awk`/`sed` | ✅ |
| 05 | [Administración y automatización](05-administracion-y-automatizacion.md) | `cron`/`at`, *systemd timers*, *logs* y *logrotate*, cuotas, LVM, *hardening*, automatización, diagnóstico de rendimiento, `strace`/`lsof`/`inotify`, paralelismo | ✅ |

---

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Qué cubre | Ejercicios | Estado |
|---|---|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | Navegación, `ls`, archivos/directorios, `cp`/`mv`, `rm`, `cat`/`head`/`tail`, `find`/`grep` básicos | 6 | ✅ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | `chmod`, `chown`, enlaces, `find` con criterios, `grep` avanzado, `tar` y compresión, redirección y *pipe* | 6 | ✅ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | Procesos `ps`/`kill`, `systemd`, `journalctl`, *bash* con `if`, *bash* con `for`, `ssh`/`scp` | 6 | ✅ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | `cron` y *timers*, `ufw`, `sed`, `awk`, monitorización, `lsof`, `rsync` | 6 | ✅ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | *Hardening*, *backup* con rotación, análisis de *logs* con `awk`, paralelismo `xargs`, *systemd service*, `strace` | 6 | ✅ |
| [proyectos](ejercicios/proyectos/) | Proyecto integrador: monitorización + *backups* automatizados | 1 | ✅ |

---

## Cómo usar este tema

1. Lee una guía de principio a fin y prueba **cada comando** en tu terminal.
2. Haz los ejercicios del nivel correspondiente en orden; cada uno valida con `bash test.sh`.
3. Abre las **pistas** y la **solución** solo después de intentarlo.
4. Al terminar los 5 niveles, afronta el [proyecto final](ejercicios/proyectos/).

> **Requisito:** un terminal Linux (nativo, WSL2 o VM). Los tests crean entornos aislados con `mktemp -d`, por lo que son seguros de ejecutar.
