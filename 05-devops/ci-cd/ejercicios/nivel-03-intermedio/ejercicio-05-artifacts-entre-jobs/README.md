# Ejercicio 17 — Artifacts entre jobs

- **Nivel:** 3/5
- **Tema:** `upload-artifact`, `download-artifact`, `needs`, compartir binarios
- **Tiempo estimado:** 25 min

## Enunciado

Crea un workflow en `.github/workflows/artifacts.yml` con **tres jobs** encadenados:

1. `build`: hace checkout, crea un directorio `dist/` con un archivo `app.txt` (contenido "v1.0.0"), y lo sube como artifact con `actions/upload-artifact@v4` (name: `binario`, path: `dist/`).
2. `test`: depende de `build` (`needs: build`), descarga el artifact `binario` con `actions/download-artifact@v4`, lee el archivo con `cat dist/app.txt`.
3. `package`: depende de `test` (`needs: test`), descarga el artifact `binario`, crea un `release.tar.gz` con `tar czf release.tar.gz dist/`, y sube `release.tar.gz` como nuevo artifact.

> Sin `download-artifact`, los jobs `test` y `package` no verían el directorio `dist/`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/artifacts.yml`.
- [ ] El job `build` sube un artifact con `actions/upload-artifact@v4`.
- [ ] El job `test` tiene `needs: build` y usa `actions/download-artifact@v4`.
- [ ] El job `package` tiene `needs: test` y usa `actions/download-artifact@v4`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `upload-artifact` y `download-artifact` son la única forma de pasar archivos entre jobs en GitHub Actions.
- `download-artifact` restaura los archivos en la misma ruta original si no se especifica `path`.
- Cada job empieza con el workspace limpio: el checkout de un job no pasa al siguiente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/artifacts.yml
name: Artifacts Entre Jobs
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: mkdir -p dist && echo "v1.0.0" > dist/app.txt
      - uses: actions/upload-artifact@v4
        with:
          name: binario
          path: dist/
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: binario
          path: dist/
      - run: cat dist/app.txt
  package:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: binario
          path: dist/
      - run: tar czf release.tar.gz dist/
      - uses: actions/upload-artifact@v4
        with:
          name: release
          path: release.tar.gz
```

</details>
