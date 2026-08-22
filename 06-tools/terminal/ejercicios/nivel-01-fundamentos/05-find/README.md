# 05 — find

## Enunciado

Busca archivos con `find`.

## Requisitos

1. En `solucion/`, crea varios archivos `.md` en subcarpetas.
2. Usa `find . -name "*.md"` y guarda la salida en `encontrados.txt`.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
mkdir -p docs/api docs/guias
touch docs/api/readme.md docs/guias/intro.md
find . -name "*.md" > encontrados.txt
```

</details>
