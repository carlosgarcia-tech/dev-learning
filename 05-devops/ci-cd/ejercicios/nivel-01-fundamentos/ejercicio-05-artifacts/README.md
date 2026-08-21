# Ejercicio 05 — Artifacts

- **Nivel:** 1/5
- **Tema:** `upload-artifact`, `download-artifact`, compartir archivos entre jobs
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/artifacts.yml` con **dos jobs**:

1. Job `crear`: corre en `ubuntu-latest`, hace checkout, crea un archivo `saludo.txt` con `echo "hola" > saludo.txt` y lo sube como artifact con `actions/upload-artifact@v4`.
2. Job `leer`: depende de `crear` (`needs: crear`), descarga el artifact con `actions/download-artifact@v4` y muestra el contenido con `cat saludo.txt`.

## Requisitos

- [ ] El archivo existe en `.github/workflows/artifacts.yml`.
- [ ] Hay un job `crear` que sube un artifact con `actions/upload-artifact@v4`.
- [ ] Hay un job `leer` con `needs: crear`.
- [ ] El job `leer` usa `actions/download-artifact@v4`.
- [ ] El job `leer` hace `cat saludo.txt`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `upload-artifact` necesita `with: name:` y `with: path:`.
- En GitHub Actions, cada job empieza limpio: sin `download-artifact`, el job `leer` no vería `saludo.txt`.
- `needs` hace que el segundo job espere al primero.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/artifacts.yml
name: Artifacts
on: push
jobs:
  crear:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "hola" > saludo.txt
      - uses: actions/upload-artifact@v4
        with:
          name: saludo
          path: saludo.txt
  leer:
    needs: crear
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: saludo
      - run: cat saludo.txt
```

</details>
