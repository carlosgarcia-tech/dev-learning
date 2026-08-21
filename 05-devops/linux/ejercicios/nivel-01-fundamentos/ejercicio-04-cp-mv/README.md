# Ejercicio 04 — Copiar y mover con `cp` y `mv`

- **Nivel:** 1/5
- **Tema:** `cp`, `cp -r`, `mv`, renombrar vs mover
- **Tiempo estimado:** 15 min

## Enunciado

`setup.sh` crea esta estructura:

```
origen/
├── config.yml
├── notas/
│   ├── a.txt
│   └── b.txt
└── plantilla.html
```

Escribe `solucion.sh` que haga:

1. Copia `origen/config.yml` a `destino/config.yml`.
2. Copia **todo** el directorio `origen/notas/` a `destino/notas/`.
3. Mueve `origen/plantilla.html` a `destino/index.html` (es decir, **lo renombra** al moverlo).
4. Borra el archivo original `origen/config.yml`.

Al terminar, `destino/` debe contener `config.yml`, `notas/` (con `a.txt` y `b.txt`) e `index.html`.

## Requisitos

- [ ] `destino/config.yml` existe.
- [ ] `destino/notas/a.txt` y `destino/notas/b.txt` existen.
- [ ] `destino/index.html` existe.
- [ ] `origen/plantilla.html` ya **no** existe.
- [ ] `origen/config.yml` ya **no** existe.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `mkdir -p destino` antes de copiar.
- Para copiar un directorio entero necesitas `cp -r`.
- `mv origen/plantilla.html destino/index.html` mueve y renombra a la vez.
- `rm origen/config.yml` borra el original.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
mkdir -p destino
cp origen/config.yml destino/config.yml
cp -r origen/notas destino/
mv origen/plantilla.html destino/index.html
rm origen/config.yml
```

</details>
