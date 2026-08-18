# Ejercicio 04 — Manejo de errores

- **Nivel:** 2/5
- **Tema:** try/except/else/finally, ValueError, ZeroDivisionError
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente la función `dividir(a, b)` que devuelve un `str`:

1. Convierte `a` y `b` a `float` (pueden llegar como `str`).
2. Captura `ValueError` si la conversión falla y devuelve `Error: no son números válidos`.
3. Captura `ZeroDivisionError` si `b` es `0` y devuelve `Error: división entre cero`.
4. Si todo funciona, devuelve `Resultado: <a / b>` en un bloque `else`.

Salida esperada (ejemplo de checks):

```
dividir("10", "2") devuelve "Resultado: 5.0"
dividir("10", "0") devuelve "Error: división entre cero"
dividir("abc", "2") devuelve "Error: no son números válidos"
```

## Requisitos

- [ ] Usar `try/except/else` (y `finally` si hace falta).
- [ ] Capturar `ValueError` y `ZeroDivisionError` por separado.
- [ ] Usar `float()` dentro del `try`.
- [ ] `dividir` devuelve el resultado o el mensaje de error (no imprime).
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

- `float("abc")` lanza `ValueError`; `10 / 0` lanza `ZeroDivisionError`.
- El bloque `else` solo corre si no hubo excepción.
- El bloque `finally` corre siempre (aunque aquí la función devuelva un valor).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def dividir(a, b):
    try:
        x = float(a)
        y = float(b)
        resultado = x / y
    except ValueError:
        return "Error: no son números válidos"
    except ZeroDivisionError:
        return "Error: división entre cero"
    else:
        return f"Resultado: {resultado}"


if __name__ == "__main__":
    print(dividir("10", "2"))
    print(dividir("10", "0"))
    print(dividir("abc", "2"))
````

</details>