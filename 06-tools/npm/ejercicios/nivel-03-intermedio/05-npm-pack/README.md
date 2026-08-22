# 05 — npm pack

## Enunciado

Verifica qué archivos se incluirían al publicar.

## Requisitos

1. En `solucion/`, ejecuta `npm pack --dry-run`.
2. Guarda la salida en `dryrun.txt`.
3. Verifica que el listado incluye `package.json`.

## Pistas

- `--dry-run` muestra qué se publicaría sin crear el `.tgz`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm pack --dry-run > dryrun.txt
cat dryrun.txt
```

</details>
