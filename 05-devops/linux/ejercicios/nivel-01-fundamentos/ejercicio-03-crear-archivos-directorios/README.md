# Ejercicio 03 — Creación de archivos y directorios

- **Nivel:** 1/5
- **Tema:** `mkdir -p`, `touch`, rutas, `tree` conceptual
- **Tiempo estimado:** 15 min

## Enunciado

Crea un script `solucion.sh` que genere la siguiente estructura **partiendo de un directorio vacío**:

```
app/
├── src/
│   ├── main.py
│   └── utils.py
├── tests/
│   ├── test_main.py
│   └── test_utils.py
└── docs/
    └── README.md
```

Además, escribe dentro de cada archivo `.py` una línea de comentario `# archivo de <nombre>`, y dentro de `docs/README.md` el texto `# Mi app`.

## Requisitos

- [ ] Se crea el árbol completo con `mkdir -p`.
- [ ] Los 4 archivos `.py` existen y no están vacíos.
- [ ] `docs/README.md` contiene `# Mi app`.
- [ ] Cada `.py` contiene la cadena `archivo de`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `mkdir -p app/src app/tests app/docs` crea toda la estructura de golpe.
- `touch app/src/main.py` crea archivos vacíos.
- Para escribir contenido usa `echo "..." > archivo`.
- `printf` también sirve para escribir contenido.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
mkdir -p app/src app/tests app/docs
echo "# archivo de main" > app/src/main.py
echo "# archivo de utils" > app/src/utils.py
echo "# archivo de test_main" > app/tests/test_main.py
echo "# archivo de test_utils" > app/tests/test_utils.py
echo "# Mi app" > app/docs/README.md
```

</details>
