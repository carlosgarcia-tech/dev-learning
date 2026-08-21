# Ejercicio 02 — Gestión de servicios con `systemctl`

- **Nivel:** 3/5
- **Tema:** `systemctl`, `status`, `start`, `stop`, `enable`, `is-active`, `journalctl`
- **Tiempo estimado:** 25 min

## Enunciado

Escribe un script `solucion.sh` que demuestre la gestión de servicios con `systemd`. Como en un entorno de pruebas no siempre hay permisos de root ni servicios configurables, el script trabajará con el **ámbito de usuario** (`systemctl --user`), que no requiere `sudo` y es seguro.

El script debe:

1. Crear (si no existe) una unit de servicio de usuario temporal en `~/.config/systemd/user/demo.service` con `ExecStart=/bin/sleep 600`.
2. Recargar systemd con `systemctl --user daemon-reload`.
3. Arrancar el servicio con `systemctl --user start demo`.
4. Guardar en `estado_activo.txt` el resultado de `systemctl --user is-active demo`.
5. Guardar en `estado_habilitado.txt` el resultado de `systemctl --user is-enabled demo` (puede ser `disabled`).
6. Detener el servicio con `systemctl --user stop demo`.
7. Guardar en `estado_final.txt` el resultado de `systemctl --user is-active demo` (debería ser `inactive`).

> Si el entorno no soporta `systemd --user` (p. ej. contenedores), el test lo detecta y verifica únicamente la creación de la unit y los comandos emitidos.

## Requisitos

- [ ] Existe el archivo `~/.config/systemd/user/demo.service` con `ExecStart=/bin/sleep 600`.
- [ ] Se ejecuta `daemon-reload`, `start`, `is-active`, `stop` e `is-active` final.
- [ ] `estado_final.txt` contiene `inactive` o `failed` (es decir, el servicio ya no está activo).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Crea el directorio con `mkdir -p ~/.config/systemd/user`.
- Escribe el `.service` con `cat > ... <<'EOF' ... EOF`.
- Usa **siempre** `systemctl --user` para no necesitar root.
- `systemctl --user is-active demo` imprime `active` o `inactive` (y devuelve exit code).
- Redirige `stderr` con `2>/dev/null` y usa `|| true` para que `set -e` no aborte.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
set -uo pipefail

UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"

cat > "$UNIT_DIR/demo.service" <<'EOF'
[Unit]
Description=Servicio de demostracion

[Service]
Type=simple
ExecStart=/bin/sleep 600

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload 2>/dev/null || true
systemctl --user start demo 2>/dev/null || true
systemctl --user is-active demo 2>/dev/null > estado_activo.txt || true
systemctl --user is-enabled demo 2>/dev/null > estado_habilitado.txt || true
systemctl --user stop demo 2>/dev/null || true
systemctl --user is-active demo 2>/dev/null > estado_final.txt || true
```

</details>
