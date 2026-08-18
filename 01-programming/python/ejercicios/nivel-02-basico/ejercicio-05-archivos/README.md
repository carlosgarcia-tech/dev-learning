# Ejercicio 05 — Archivos

- **Nivel:** 2/5
- **Tema:** open, with, lectura, escritura, iteración de líneas
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente las funciones que operan sobre un archivo pasado como parámetro `ruta` (usa `with open(...)` para todos los accesos):

1. `escribir_datos(ruta)` — escribe el archivo `ruta` con 3 líneas: `uno`, `dos`, `tres` (modo `"w"`).
2. `leer_completo(ruta)` — lee el archivo completo con `.read()` y devuelve el contenido crudo.
3. `leer_lineas(ruta)` — lee las líneas con `.readlines()` y devuelve la lista resultante.
4. `leer_limpiadas(ruta)` — itera línea por línea con un `for` y devuelve una lista con cada línea con `strip()` para quitar el salto de línea.
5. `agregar_linea(ruta, linea)` — añade `linea` al final del archivo con modo `"a"` (append).

Salida esperada (ejemplo de checks, tras `escribir_datos(ruta)`):

```
leer_completo(ruta) devuelve "uno\ndos\ntres\n"
leer_lineas(ruta) devuelve ['uno\n', 'dos\n', 'tres\n']
leer_limpiadas(ruta) devuelve ['uno', 'dos', 'tres']
tras agregar_linea(ruta, "cuatro"), leer_limpiadas(ruta) devuelve ['uno', 'dos', 'tres', 'cuatro']
```

## Requisitos

- [ ] Usar `with open(...)` para todos los accesos (así se cierra el archivo solo).
- [ ] Escribir, leer crudo, leer líneas, iterar y hacer append.
- [ ] Usar `strip()` al leer cada línea.
- [ ] Cada función recibe la `ruta` como parámetro y devuelve el resultado (no imprime).
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Modos: `"w"` escribe (sobrescribe), `"a"` añade al final, `"r"` lee.
- `with` cierra el archivo automáticamente al salir del bloque.
- Cada línea de `readlines()` incluye el `\n` final, por eso se usa `strip()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def escribir_datos(ruta):
    with open(ruta, "w") as f:
        f.write("uno\ndos\ntres\n")


def leer_completo(ruta):
    with open(ruta, "r") as f:
        return f.read()


def leer_lineas(ruta):
    with open(ruta, "r") as f:
        return f.readlines()


def leer_limpiadas(ruta):
    with open(ruta, "r") as f:
        return [linea.strip() for linea in f]


def agregar_linea(ruta, linea):
    with open(ruta, "a") as f:
        f.write(linea + "\n")


if __name__ == "__main__":
    ruta = "datos.txt"
    escribir_datos(ruta)
    print("Contenido crudo:")
    print(leer_completo(ruta))
    print(f"Lista de líneas: {leer_lineas(ruta)}")
    for linea in leer_limpiadas(ruta):
        print(f"Línea: {linea}")
    agregar_linea(ruta, "cuatro")
    print("Después de append:")
    print(leer_completo(ruta))
````

</details>