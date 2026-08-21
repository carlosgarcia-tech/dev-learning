# Ejercicio 01 — Navegación con pwd y cd

- **Nivel:** 1/5
- **Tema:** `pwd`, `cd`, rutas absolutas y relativas, `.`, `..`, `~`
- **Tiempo estimado:** 15 min

## Enunciado

El archivo `setup.sh` crea un árbol de proyecto dentro de un directorio:

```
proyectos/
├── web/
│   ├── src/
│   ├── docs/
│   └── tests/
└── api/
    ├── src/
    └── docs/
```

Escribe un script `solucion.sh` que, **partiendo del directorio donde se ejecute**, haga lo siguiente:

1. Entre en la carpeta `proyectos/web/tests` usando una ruta relativa.
2. Imprima por pantalla el directorio actual con `pwd`.
3. Cree un archivo vacío llamado `marcador.txt`.

El script se ejecutará dentro de un entorno aislado, por lo que puedes asumir que el árbol ya existe.

## Requisitos

- [ ] El script usa `cd` con una ruta relativa (no absoluta).
- [ ] Imprime la ubicación actual con `pwd`.
- [ ] Crea el archivo `marcador.txt` dentro de `proyectos/web/tests`.
- [ ] El script termina sin error (`exit 0`).
- [ ] Los tests pasan: `bash test.sh`

> **Cómo ejecutar los tests**
>
> ```bash
> bash test.sh
> ```
>
> Salida `0` si pasan, `1` si fallan.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para entrar en una subcarpeta: `cd proyectos/web/tests`.
- `pwd` imprime el directorio actual.
- `touch marcador.txt` crea un archivo vacío.
- No hace falta `sudo` ni rutas absolutas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd proyectos/web/tests
pwd
touch marcador.txt
```

</details>
