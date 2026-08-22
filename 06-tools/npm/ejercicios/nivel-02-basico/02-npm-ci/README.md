# 02 — npm ci

## Enunciado

Compara `npm install` con `npm ci`.

## Requisitos

1. En `solucion/`, borra `node_modules/`.
2. Ejecuta `npm ci` y verifica que instala exactamente lo del lockfile.
3. Explica en un archivo `respuesta.txt` una diferencia entre `npm install` y `npm ci`.

## Pistas

- `npm ci` requiere `package-lock.json`.
- `npm ci` no modifica el lockfile.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
rm -rf node_modules
npm ci
```

`respuesta.txt`:
```
npm ci instala exactamente lo del lockfile, es más rápido y no lo modifica.
npm install puede actualizar el lockfile y resolver de nuevo las dependencias.
```

</details>
