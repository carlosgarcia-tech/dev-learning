# Ejercicio 02 — Firewall con `ufw`

- **Nivel:** 4/5
- **Tema:** `ufw`, reglas allow/deny, estado, `iptables` (lectura)
- **Tiempo estimado:** 30 min

## Enunciado

Gestionar `ufw` real requiere `root` y puede dejar sin acceso al sistema. Para practicar de forma segura, escribirás `solucion.sh` que genera un **script de reglas** (`reglas.sh`) listo para aplicar, en lugar de ejecutar `ufw` directamente.

El `reglas.sh` generado debe contener (en este orden) comandos `ufw`:

1. `ufw default deny incoming`
2. `ufw default allow outgoing`
3. `ufw allow 22/tcp` (SSH)
4. `ufw allow 80/tcp` (HTTP)
5. `ufw allow 443/tcp` (HTTPS)
6. `ufw allow from 192.168.1.0/24 to any port 5432` (PostgreSQL solo LAN)
7. `ufw deny 3306` (bloquear MySQL al exterior)
8. `ufw enable`

Además, el script `solucion.sh` debe guardar en `resumen.txt` el estado de `ufw` con `ufw status verbose` (si `ufw` no existe o no hay permisos, `resumen.txt` debe contener `ufw no disponible`).

## Requisitos

- [ ] `reglas.sh` contiene las 8 líneas `ufw` anteriores en el orden indicado.
- [ ] `resumen.txt` existe y no está vacío.
- [ ] `reglas.sh` tiene permiso de ejecución.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Escribe el archivo con `cat > reglas.sh <<'EOF' ... EOF` para varias líneas.
- `chmod +x reglas.sh` lo hace ejecutable.
- Para `resumen.txt`: `if command -v ufw ...; then ufw status verbose > resumen.txt; else echo "ufw no disponible" > resumen.txt; fi`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -euo pipefail

cat > reglas.sh <<'EOF'
#!/usr/bin/env bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow from 192.168.1.0/24 to any port 5432
ufw deny 3306
ufw enable
EOF
chmod +x reglas.sh

if command -v ufw >/dev/null 2>&1; then
  sudo ufw status verbose > resumen.txt 2>/dev/null || ufw status verbose > resumen.txt 2>/dev/null || echo "ufw no disponible" > resumen.txt
else
  echo "ufw no disponible" > resumen.txt
fi
```

</details>
