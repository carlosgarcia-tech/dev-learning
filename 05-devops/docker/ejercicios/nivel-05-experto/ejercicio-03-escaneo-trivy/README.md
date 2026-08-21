# Ejercicio 03 — Escaneo con Trivy

- **Nivel:** 5/5
- **Tema:** escaneo de vulnerabilidades, Trivy, umbral de severidad, CI gate
- **Tiempo estimado:** 35 min

## Enunciado

Crea un `Dockerfile` y un script `scan.sh` que escaneen la imagen con Trivy y fallen si hay vulnerabilidades HIGH o CRITICAL.

1. `Dockerfile`: app Node simple basada en `node:20-alpine`.
2. `scan.sh`: construye la imagen y la escanea con `trivy image --severity HIGH,CRITICAL --exit-code 1`.
3. El script debe imprimir OK si no hay vulneridades críticas y FAIL si las hay.

## Requisitos

- [ ] `Dockerfile` válido con `node:20-alpine`
- [ ] `scan.sh` con `trivy image`
- [ ] `scan.sh` usa `--severity HIGH,CRITICAL`
- [ ] `scan.sh` usa `--exit-code 1`
- [ ] `scan.sh` construye la imagen antes de escanear
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `trivy image --severity HIGH,CRITICAL --exit-code 1 <imagen>` sale con código 1 si encuentra vulns de esa severidad.
- Si trivy no está instalado, el script puede saltarse el escaneo (modo info).
- En CI, este gate evita desplegar imágenes con vulnerabilidades conocidas sin fix.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`scan.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
IMG="ejercicio-trivy:latest"
docker build -t "$IMG" .
trivy image --severity HIGH,CRITICAL --exit-code 1 "$IMG"
echo "OK: sin vulnerabilidades HIGH/CRITICAL"
```

</details>
