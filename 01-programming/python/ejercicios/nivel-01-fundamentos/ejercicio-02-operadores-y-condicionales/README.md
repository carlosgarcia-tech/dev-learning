# Ejercicio 02 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores, `if/elif/else`, `raise` para errores
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente:

1. `calcular(a, b, op)` — recibe dos números (`float`) y un operador (`+`, `-`, `*`, `/`) y devuelve el resultado de la operación:
   - Si `op` es `+`, `-`, `*` o `/`, devuelve el resultado numérico.
   - Si `op` es `/` y `b == 0`, lanza `ZeroDivisionError("No se puede dividir entre cero")`.
   - Si `op` no es válido, lanza `ValueError("Operador no válido")`.

Salida esperada (ejemplo de checks):

```
calcular(10.0, 3.0, "/") == 3.3333333333333335
calcular(2, 3, "+") == 5
calcular(10, 0, "/") lanza ZeroDivisionError
calcular(2, 3, "x") lanza ValueError
```

## Requisitos

- [ ] Usar `if/elif/else` para distinguir los operadores.
- [ ] Manejar la división entre cero con `raise ZeroDivisionError`.
- [ ] Manejar el operador inválido con `raise ValueError`.
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

- Compara el operador con `==`: `if op == "+":`.
- Comprueba `if b == 0` antes de dividir para lanzar `ZeroDivisionError`.
- El `else` final lanza `ValueError` para operadores no reconocidos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def calcular(a: float, b: float, op: str) -> float:
    if op == "+":
        return a + b
    elif op == "-":
        return a - b
    elif op == "*":
        return a * b
    elif op == "/":
        if b == 0:
            raise ZeroDivisionError("No se puede dividir entre cero")
        return a / b
    else:
        raise ValueError("Operador no válido")


if __name__ == "__main__":
    print(calcular(10.0, 3.0, "/"))
    print(calcular(2, 3, "+"))
    try:
        calcular(10, 0, "/")
    except ZeroDivisionError as e:
        print(e)
    try:
        calcular(2, 3, "x")
    except ValueError as e:
        print(e)
````

</details>