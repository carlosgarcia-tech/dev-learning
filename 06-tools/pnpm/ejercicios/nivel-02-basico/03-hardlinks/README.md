# 03 — Hardlinks

## Enunciado

Verifica que pnpm usa hardlinks al store.

## Requisitos

1. En `solucion/`, instala un paquete.
2. Ejecuta `ls -i node_modules/.pnpm/*/node_modules/<pkg>/package.json` y guarda el inodo.
3. Explica en `respuesta.txt` qué son los hardlinks.

## Pistas

- Los hardlinks comparten los mismos datos en disco.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
pnpm add lodash
ls -li node_modules/.pnpm/lodash*/node_modules/lodash/package.json
```

`respuesta.txt`:
```
Los hardlinks son entradas del filesystem que apuntan a los mismos datos en disco. pnpm los usa para no duplicar paquetes entre proyectos: el store tiene el archivo real y el proyecto un hardlink a él.
```

</details>
