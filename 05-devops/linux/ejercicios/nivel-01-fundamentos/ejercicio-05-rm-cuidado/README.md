# Ejercicio 05 — Borrado con cuidado (`rm`)

- **Nivel:** 1/5
- **Tema:** `rm`, `rm -r`, `rm -i`, seguridad al borrar
- **Tiempo estimado:** 15 min

## Enunciado

`setup.sh` crea:

```
tmp/
├── debug.log
├── error.log
├── info.log
├── importante.txt
└── basura/
    ├── a.tmp
    └── b.tmp
```

Escribe `solucion.sh` que, operando dentro de `tmp/`:

1. Borre **solo** los archivos `.log` (deja `importante.txt` intacto).
2. Borre el directorio `basura/` y todo su contenido con un solo comando.

Al terminar, `tmp/` debe contener únicamente `importante.txt`.

> ⚠️ Este ejercicio practica el borrado **definitivo**. El test se ejecuta en un directorio aislado con `mktemp`, así que es seguro. NUNCA ejecutes `rm -rf` sobre rutas del sistema real.

## Requisitos

- [ ] Se borran `debug.log`, `error.log` e `info.log`.
- [ ] Se borra el directorio `basura/` con todo su contenido (con `rm -r`).
- [ ] `importante.txt` **sobrevive** intacto.
- [ ] Al final, en `tmp/` solo queda `importante.txt`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `cd tmp` para operar dentro.
- `rm *.log` borra todos los `.log` usando *globbing*.
- `rm -r basura` borra el directorio y su contenido.
- Comprueba con `ls` antes de borrar para no equivocarte.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd tmp
rm *.log
rm -r basura
```

</details>
