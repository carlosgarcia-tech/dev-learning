# Ejercicio 06 — Diccionarios básicos

- **Nivel:** 1/5
- **Tema:** diccionarios, get, items, iteración
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente funciones que trabajen con un diccionario de un alumno:

1. `crear_alumno()` — devuelve el diccionario `{"nombre": "Ana", "edad": 20, "curso": "Matemáticas"}`.
2. `agregar_nota(alumno, nota)` — añade la clave `nota` con el valor dado y devuelve el diccionario.
3. `actualizar_edad(alumno, edad)` — actualiza la clave `edad` con el valor dado y devuelve el diccionario.
4. `obtener_email(alumno)` — devuelve `alumno.get("email", "sin email")`.
5. `formatear_items(alumno)` — devuelve una lista de strings `"clave: valor"` recorriendo con `for clave, valor in alumno.items()`.

Salida esperada:

```
crear_alumno() == {"nombre": "Ana", "edad": 20, "curso": "Matemáticas"}
agregar_nota(alumno, 18) añade la clave "nota": 18
actualizar_edad(alumno, 21) actualiza "edad" a 21
obtener_email(alumno) == "sin email"
formatear_items(alumno) == ["nombre: Ana", "edad: 21", "curso: Matemáticas", "nota: 18"]
```

## Requisitos

- [ ] Crear el diccionario con `nombre`, `edad` y `curso`.
- [ ] Añadir y actualizar claves con `alumno["..."] = ...`.
- [ ] Usar `.get()` con valor por defecto.
- [ ] Iterar con `.items()`.
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

- Un diccionario se define con llaves: `{"clave": "valor"}`.
- Para añadir: `alumno["nota"] = 18`.
- `for k, v in d.items()` recorre pares clave/valor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def crear_alumno() -> dict:
    return {"nombre": "Ana", "edad": 20, "curso": "Matemáticas"}


def agregar_nota(alumno: dict, nota: int) -> dict:
    alumno["nota"] = nota
    return alumno


def actualizar_edad(alumno: dict, edad: int) -> dict:
    alumno["edad"] = edad
    return alumno


def obtener_email(alumno: dict) -> str:
    return alumno.get("email", "sin email")


def formatear_items(alumno: dict) -> list:
    resultado = []
    for clave, valor in alumno.items():
        resultado.append(f"{clave}: {valor}")
    return resultado


if __name__ == "__main__":
    alumno = crear_alumno()
    agregar_nota(alumno, 18)
    actualizar_edad(alumno, 21)
    print(alumno["nombre"])
    print(alumno)
    print(obtener_email(alumno))
    for linea in formatear_items(alumno):
        print(linea)
````

</details>