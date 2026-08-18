# Ejercicio 01 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** variables, tipos (`str`, `int`, `bool`), `type()`, f-strings
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente:

1. `nombre()` — devuelve un nombre como `str` (p. ej. `Ana`).
2. `ciudad()` — devuelve una ciudad de nacimiento como `str` (p. ej. `Lima`).
3. `edad()` — devuelve una edad como `int` (p. ej. `30`).
4. `estudia_programacion()` — devuelve `True`.
5. `tipo_de(valor)` — devuelve el **nombre del tipo** de `valor` (`str`, `int`, `bool`) usando `type()`.
6. `formatear_descripcion(nombre, ciudad, edad, programacion)` — devuelve con f-strings:
   `Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <programacion> que estudio programación.`

Salida esperada (ejemplo de checks):

```
tipo_de("hola") devuelve "str"
tipo_de(42) devuelve "int"
tipo_de(True) devuelve "bool"
formatear_descripcion(Ana, Lima, 30, True) coincide con el patrón esperado
```

## Requisitos

- [ ] `nombre()`, `ciudad()`, `edad()` y `estudia_programacion()` devuelven los valores de ejemplo.
- [ ] `tipo_de` usa `type(valor).__name__` para obtener el nombre del tipo.
- [ ] `formatear_descripcion` usa f-strings con `{}`.
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

- `type(nombre)` devuelve `<class 'str'>`; para obtener solo el nombre usa `type(nombre).__name__`.
- Un f-string se escribe `f"texto {variable}"`.
- No hace falta declarar el tipo explícitamente en Python.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def nombre() -> str:
    return "Ana"


def ciudad() -> str:
    return "Lima"


def edad() -> int:
    return 30


def estudia_programacion() -> bool:
    return True


def tipo_de(valor) -> str:
    return type(valor).__name__


def formatear_descripcion(nombre, ciudad, edad, programacion) -> str:
    return (
        f"Soy {nombre}, tengo {edad} años, nací en {ciudad} "
        f"y es {programacion} que estudio programación."
    )


if __name__ == "__main__":
    print(tipo_de("hola"))
    print(tipo_de(42))
    print(tipo_de(True))
    print(formatear_descripcion("Ana", "Lima", 30, True))
````

</details>