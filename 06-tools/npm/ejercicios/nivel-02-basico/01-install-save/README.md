# 01 — npm install y save

## Enunciado

Practica la instalación con diferentes banderas de guardado.

## Requisitos

1. En `solucion/`, instala `express` como dependency.
2. Instala `nodemon` como devDependency usando la bandera `-D`.
3. Instala `lodash` con versión exacta usando `--save-exact`.

## Pistas

- `-D` es abreviatura de `--save-dev`.
- `--save-exact` quita el `^` del prefijo.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm install express
npm install -D nodemon
npm install --save-exact lodash
```

</details>
