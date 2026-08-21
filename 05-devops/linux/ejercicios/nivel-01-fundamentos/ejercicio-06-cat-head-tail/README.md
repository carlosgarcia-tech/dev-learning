# Ejercicio 06 — Lectura y búsqueda básica (`cat`/`head`/`tail` + `find` + `grep`)

- **Nivel:** 1/5
- **Tema:** `cat`, `head`, `tail`, `find -name`, `grep`, `grep -c`, `wc`
- **Tiempo estimado:** 25 min

## Enunciado

`setup.sh` crea un proyecto de ejemplo:

```
repo/
├── README.md
├── servidor.log      (20 líneas: Linea 01 .. Linea 20)
├── src/
│   ├── main.py        (con una línea # TODO: refactorizar)
│   └── utils.py
└── docs/
    └── api.md
```

Escribe `solucion.sh` que, **desde la carpeta `repo/`**, genere:

1. `primeras.txt` — las **5 primeras** líneas de `servidor.log` (`head -n 5`).
2. `ultimas.txt` — las **3 últimas** líneas de `servidor.log` (`tail -n 3`).
3. `lista_py.txt` — todos los archivos `.py` del proyecto (`find . -name "*.py"`).
4. `cuenta_py.txt` — número de archivos `.py` (`find ... | wc -l`).
5. `todos.txt` — las líneas que contienen `TODO` en los `.py` (`grep -rn "TODO" --include=*.py .`).

## Requisitos

- [ ] `primeras.txt` tiene 5 líneas y contiene `Linea 01`.
- [ ] `ultimas.txt` tiene 3 líneas y contiene `Linea 20`.
- [ ] `lista_py.txt` contiene `./src/main.py` y `./src/utils.py`.
- [ ] `cuenta_py.txt` contiene el número `2`.
- [ ] `todos.txt` no está vacío y contiene la cadena `TODO`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `head -n 5 servidor.log > primeras.txt` toma las 5 primeras líneas.
- `tail -n 3 servidor.log > ultimas.txt` toma las 3 últimas.
- `find . -name "*.py" > lista_py.txt` busca por nombre.
- `find . -name "*.py" | wc -l > cuenta_py.txt` cuenta resultados.
- `grep -rn "TODO" --include=*.py . > todos.txt` busca recursivamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd repo
head -n 5 servidor.log > primeras.txt
tail -n 3 servidor.log > ultimas.txt
find . -name "*.py" > lista_py.txt
find . -name "*.py" | wc -l > cuenta_py.txt
grep -rn "TODO" --include=*.py . > todos.txt
```

</details>
