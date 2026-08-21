# Ejercicio 02 — Listar con `ls` y opciones

- **Nivel:** 1/5
- **Tema:** `ls`, `-l`, `-a`, `-h`, `-t`, `-r`, *globbing* `*`
- **Tiempo estimado:** 15 min

## Enunciado

`setup.sh` crea una carpeta `datos/` con varios archivos de distintos tamaños y fechas:

```
datos/
├── grande.log   (10 KB)
├── chico.txt    (100 B)
├── .oculto.cfg  (archivo oculto)
├── nota1.txt
├── nota2.txt
└── imagen.png
```

Escribe `solucion.sh` que, estando dentro de la carpeta `datos/`, genere dos listados:

1. **Listado largo con ocultos y tamaños legibles** (`ls -lah`) y guárdalo en un archivo `listado_largo.txt`.
2. **Listado de archivos `.txt` ordenados por tiempo (más nuevos primero)** (`ls -lt *.txt`) y guárdalo en `listado_txt.txt`.

## Requisitos

- [ ] `listado_largo.txt` se genera con `ls -lah`.
- [ ] `listado_txt.txt` se genera con `ls -lt *.txt`.
- [ ] Ambos archivos existen y no están vacíos.
- [ ] `listado_largo.txt` contiene la línea con `.oculto.cfg`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ls -lah > listado_largo.txt` redirige la salida a un archivo.
- `ls -lt *.txt > listado_txt.txt` lista los `.txt` por tiempo.
- `*.txt` es un comodín que la shell expande.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd datos
ls -lah > listado_largo.txt
ls -lt *.txt > listado_txt.txt
```

</details>
