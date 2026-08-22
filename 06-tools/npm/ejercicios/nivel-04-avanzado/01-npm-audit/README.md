# 01 — npm audit

## Enunciado

Audita las dependencias de un proyecto en busca de vulnerabilidades.

## Requisitos

1. En `solucion/`, ejecuta `npm audit`.
2. Guarda la salida en `audit.txt`.
3. Indica en `respuesta.txt` cuántas vulnerabilidades se encontraron.

## Pistas

- `npm audit` compara con la base de datos de avisos de npm.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm audit > audit.txt 2>&1 || true
npm audit 2>&1 | grep -o "[0-9]* vulnerabilit" | head -1 > respuesta.txt
```

</details>
