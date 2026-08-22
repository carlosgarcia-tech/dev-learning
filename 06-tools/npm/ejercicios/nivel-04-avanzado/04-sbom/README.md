# 04 — SBOM

## Enunciado

Genera un Software Bill of Materials (SBOM) del proyecto.

## Requisitos

1. En `solucion/`, ejecuta `npm sbom --sbom-format cyclonedx` (o el formato disponible).
2. Guarda el resultado en `sbom.json` o explica en `respuesta.txt` el formato usado.

## Pistas

- SBOM lista todos los componentes del software.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm sbom --sbom-format cyclonedx > sbom.json 2>/dev/null || echo "cyclonedx" > respuesta.txt
```

</details>
