# Ejercicio 01 — Permisos con `chmod`

- **Nivel:** 2/5
- **Tema:** `chmod` simbólico y octal, `rwx`, permisos de ejecución
- **Tiempo estimado:** 20 min

## Enunciado

`setup.sh` crea una carpeta `proyecto/` con:

```
proyecto/
├── script.sh       (-rw-r--r--)
├── secreto.key     (-rw-r--r--)
├── publico.txt     (-rw-r--r--)
└── carpeta/         (drwxr-xr-x)
    └── dentro.txt
```

Escribe `solucion.sh` que, dentro de `proyecto/`, ajuste los permisos a:

1. `script.sh` → `rwxr-xr-x` (ejecutable para todos) con `chmod 755`.
2. `secreto.key` → `rw-------` (solo el propietario) con `chmod 600`.
3. `publico.txt` → `rw-rw-r--` con `chmod 664` o modo simbólico.
4. `carpeta/` → `rwxrwx---` con `chmod 770` (de forma recursiva, para que `dentro.txt` también quede con permisos del grupo).

## Requisitos

- [ ] `script.sh` tiene permisos `755` (o equivalentes `rwxr-xr-x`).
- [ ] `secreto.key` tiene permisos `600` (`rw-------`).
- [ ] `publico.txt` tiene permisos `664` (`rw-rw-r--`).
- [ ] `carpeta/` tiene permisos `770` (`rwxrwx---`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `chmod 755 script.sh` asigna rwxr-xr-x en modo octal.
- `chmod 600 secreto.key` deja solo lectura/escritura al propietario.
- `chmod 770 carpeta -R` aplica recursivamente a `carpeta/` y su contenido.
- Para ver los permisos usa `stat -c %a archivo` (modo octal numérico).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd proyecto
chmod 755 script.sh
chmod 600 secreto.key
chmod 664 publico.txt
chmod 770 carpeta -R
```

</details>
