# 05 — El archivo package-lock.json

## Enunciado

Entiende para qué sirve el lockfile.

## Requisitos

1. En `solucion/`, ejecuta `npm install`.
2. Verifica que existe `package-lock.json`.
3. Comprueba con `git diff` que el lockfile registra versiones exactas.

## Pistas

- El lockfile se genera automáticamente al instalar.
- Registra la versión exacta de cada dependencia, incluidas las transitivas.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm install
ls package-lock.json    # debe existir
```

</details>
