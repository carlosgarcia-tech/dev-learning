# Ejercicio 03 — Enlaces simbólicos y duros con `ln`

- **Nivel:** 2/5
- **Tema:** `ln -s` (simbólico), `ln` (duro), `readlink`, inodos
- **Tiempo estimado:** 20 min

## Enunciado

`setup.sh` crea:

```
src/
├── original.txt      (contenido: "datos originales")
└── config/
    └── app.conf
```

Escribe `solucion.sh` que:

1. Cree un **enlace simbólico** `acceso.conf` que apunte a `src/config/app.conf` (usa `ln -s`).
2. Cree un **enlace simbólico** `link_origen.txt` que apunte a `src/original.txt`.
3. Cree un **enlace duro** `duro.txt` al archivo `src/original.txt` (usa `ln` sin `-s`).
4. Comprueba (y guarda en `verificacion.txt`) el destino del enlace simbólico con `readlink acceso.conf`.

## Requisitos

- [ ] `acceso.conf` es un enlace simbólico que apunta a `src/config/app.conf`.
- [ ] `link_origen.txt` es un enlace simbólico que apunta a `src/original.txt`.
- [ ] `duro.txt` es un **enlace duro** (no simbólico): comparte inodo con `src/original.txt`.
- [ ] `verificacion.txt` contiene `src/config/app.conf`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ln -s src/config/app.conf acceso.conf` crea un enlace simbólico.
- `ln src/original.txt duro.txt` (sin `-s`) crea un enlace duro.
- `readlink acceso.conf` muestra a dónde apunta.
- Para verificar que dos archivos comparten inodo: `ls -i archivo1 archivo2` (mismo nº de inodo).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
ln -s src/config/app.conf acceso.conf
ln -s src/original.txt link_origen.txt
ln src/original.txt duro.txt
readlink acceso.conf > verificacion.txt
```

</details>
