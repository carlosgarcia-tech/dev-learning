# Ejercicio 05 — Crear un servicio `systemd` personalizado

- **Nivel:** 5/5
- **Tema:** `systemd`, `.service`, `Type=simple`, `Restart`, `systemctl --user`
- **Tiempo estimado:** 40 min

## Enunciado

Escribe `solucion.sh` que cree un **servicio de usuario** completo de systemd para una aplicación ficticia que escribe la hora en un archivo cada segundo.

Pasos:

1. Crea un script `app.sh` (ejecutable) que, en bucle infinito, escriba la fecha actual en `~/.local/share/demo-app/salida.log` cada segundo:
   ```bash
   #!/usr/bin/env bash
   mkdir -p ~/.local/share/demo-app
   while true; do
     date >> ~/.local/share/demo-app/salida.log
     sleep 1
   done
   ```

2. Crea el archivo `demo-app.service` (en `~/.config/systemd/user/`) con:
   ```ini
   [Unit]
   Description=App de demostracion (escribe hora)

   [Service]
   Type=simple
   ExecStart=%h/app.sh
   Restart=on-failure
   RestartSec=2s

   [Install]
   WantedBy=default.target
   ```

3. Recarga systemd, arranca el servicio y verifica que está activo.
4. Guarda el estado (`is-active`) en `estado.txt`.

> El test verifica que el archivo `.service` existe con el contenido correcto, que `app.sh` es ejecutable y, si `systemd --user` está disponible, que el servicio llega a estar activo y escribe en el log.

## Requisitos

- [ ] `app.sh` existe y es ejecutable.
- [ ] `app.sh` contiene un bucle `while true` con `sleep 1`.
- [ ] `~/.config/systemd/user/demo-app.service` existe con `Type=simple`, `Restart=on-failure` y `WantedBy=default.target`.
- [ ] `ExecStart` apunta a `%h/app.sh`.
- [ ] Si systemd de usuario está disponible, `estado.txt` contiene `active`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `%h` en un `.service` de usuario se expande al home del usuario.
- `systemctl --user daemon-reload` recarga tras crear la unit.
- `systemctl --user start demo-app` arranca el servicio.
- `systemctl --user is-active demo-app` devuelve `active` si está corriendo.
- Recuerda parar el servicio al final con `systemctl --user stop demo-app`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

# 1. Script de la aplicación
cat > "$HOME/app.sh" <<'EOF'
#!/usr/bin/env bash
mkdir -p ~/.local/share/demo-app
while true; do
  date >> ~/.local/share/demo-app/salida.log
  sleep 1
done
EOF
chmod +x "$HOME/app.sh"

# 2. Unit de servicio
UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"
cat > "$UNIT_DIR/demo-app.service" <<'EOF'
[Unit]
Description=App de demostracion (escribe hora)

[Service]
Type=simple
ExecStart=%h/app.sh
Restart=on-failure
RestartSec=2s

[Install]
WantedBy=default.target
EOF

# 3. Recargar y arrancar (si systemd --user está disponible)
if systemctl --user list-units >/dev/null 2>&1; then
  systemctl --user daemon-reload 2>/dev/null || true
  systemctl --user start demo-app 2>/dev/null || true
  sleep 2
  systemctl --user is-active demo-app 2>/dev/null > estado.txt || echo "inactive" > estado.txt
  systemctl --user stop demo-app 2>/dev/null || true
else
  echo "inactive" > estado.txt
fi
```

</details>
