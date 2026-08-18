# Ejercicio 04 — Módulos y paquetes

- **Nivel:** 3/5
- **Tema:** módulos, import, if __name__, paquetes
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente las funciones de una calculadora, como las que vivirían en un módulo `operaciones.py`:

1. `sumar(a, b)` — devuelve `a + b`.
2. `restar(a, b)` — devuelve `a - b`.
3. `multiplicar(a, b)` — devuelve `a * b`.
4. `dividir(a, b)` — devuelve `a / b` y lanza `ZeroDivisionError("no se puede dividir entre cero")` si `b == 0`.

El bloque `if __name__ == "__main__":` puede servir de demo: imprime el resultado de `sumar(4, 5)`, `restar(10, 3)`, `multiplicar(3, 4)` y `dividir(10, 2)`, y maneja con `try/except` la llamada a `dividir(1, 0)`.

Salida esperada:

```
Sumar: 9
Restar: 7
Multiplicar: 12
Dividir: 5.0
Error: no se puede dividir entre cero
```

## Requisitos

- [ ] Definir las 4 funciones de la calculadora.
- [ ] Usar `if __name__ == "__main__":` para el demo.
- [ ] Manejar `ZeroDivisionError` en `dividir`.
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

- Estas funciones son las que formarían un módulo `operaciones.py`; al ejecutarlas desde el mismo directorio se importarían con `from operaciones import sumar` o `import operaciones as ops`.
- `if __name__ == "__main__":` solo ejecuta el bloque cuando el archivo se corre directamente, no cuando se importa.
- `__init__.py` puede estar vacío y aún así marca el directorio como paquete.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def sumar(a, b):
    return a + b


def restar(a, b):
    return a - b


def multiplicar(a, b):
    return a * b


def dividir(a, b):
    if b == 0:
        raise ZeroDivisionError("no se puede dividir entre cero")
    return a / b


if __name__ == "__main__":
    print(f"Sumar: {sumar(4, 5)}")
    print(f"Restar: {restar(10, 3)}")
    print(f"Multiplicar: {multiplicar(3, 4)}")
    print(f"Dividir: {dividir(10, 2)}")

    try:
        dividir(1, 0)
    except ZeroDivisionError as e:
        print(f"Error: {e}")
````

</details>