# Ejercicio 05 — Archivos

- **Nivel:** 2/5
- **Tema:** open, with, lectura, escritura, iteración de líneas
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `archivos.py` que:

1. Escriba un archivo `datos.txt` con 3 líneas: `uno`, `dos`, `tres` (usa `with open(..., "w")`).
2. Lea el archivo completo con `.read()` e imprima el contenido crudo.
3. Lea las líneas con `.readlines()` e imprima la lista resultante.
4. Lea línea por línea con un `for` e imprima cada línea con `strip()` para quitar el salto de línea.
5. Añada una línea más (`cuatro`) con modo `"a"` (append) y vuelva a leer el archivo para confirmarlo.

Salida esperada:

```
Contenido crudo:
uno
dos
tres
Lista de líneas: ['uno\n', 'dos\n', 'tres\n']
Línea: uno
Línea: dos
Línea: tres
Después de append:
uno
dos
tres
cuatro
```

## Requisitos

- [ ] Usar `with open(...)` para todos los accesos (así se cierra el archivo solo).
- [ ] Escribir, leer crudo, leer líneas, iterar y hacer append.
- [ ] Usar `strip()` al imprimir cada línea.
- [ ] Ejecutarlo localmente con `python3 archivos.py` en un directorio con permisos de escritura y verificar la salida.

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
with open("datos.txt", "w") as f:
    f.write("uno\ndos\ntres\n")

print("Contenido crudo:")
with open("datos.txt", "r") as f:
    contenido = f.read()
print(contenido)

with open("datos.txt", "r") as f:
    lineas = f.readlines()
print(f"Lista de líneas: {lineas}")

with open("datos.txt", "r") as f:
    for linea in f:
        print(f"Línea: {linea.strip()}")

with open("datos.txt", "a") as f:
    f.write("cuatro\n")

print("Después de append:")
with open("datos.txt", "r") as f:
    print(f.read())
````

</details>