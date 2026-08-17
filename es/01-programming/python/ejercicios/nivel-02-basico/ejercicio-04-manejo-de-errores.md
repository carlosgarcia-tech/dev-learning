# Ejercicio 04 — Manejo de errores

- **Nivel:** 2/5
- **Tema:** try/except/else/finally, ValueError, ZeroDivisionError
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `errores.py` que implemente la función `dividir(a, b)` que:

1. Convierte `a` y `b` a `float` (pueden llegar como `str`).
2. Captura `ValueError` si la conversión falla e imprime `Error: no son números válidos`.
3. Captura `ZeroDivisionError` si `b` es `0` e imprime `Error: división entre cero`.
4. Si todo funciona, imprime `Resultado: <a / b>` en un bloque `else`.
5. Imprime `Operación finalizada` en un bloque `finally`.

Luego prueba la función con los casos: `dividir("10", "2")`, `dividir("10", "0")` y `dividir("abc", "2")`.

Salida esperada:

```
Resultado: 5.0
Operación finalizada
Error: división entre cero
Operación finalizada
Error: no son números válidos
Operación finalizada
```

## Requisitos

- [ ] Usar `try/except/else/finally`.
- [ ] Capturar `ValueError` y `ZeroDivisionError` por separado.
- [ ] Usar `float()` dentro del `try`.
- [ ] Ejecutarlo localmente con `python3 errores.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `float("abc")` lanza `ValueError`; `10 / 0` lanza `ZeroDivisionError`.
- El bloque `else` solo corre si no hubo excepción.
- El bloque `finally` corre siempre.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def dividir(a, b):
    try:
        x = float(a)
        y = float(b)
    except ValueError:
        print("Error: no son números válidos")
    except ZeroDivisionError:
        print("Error: división entre cero")
    else:
        try:
            print(f"Resultado: {x / y}")
        except ZeroDivisionError:
            print("Error: división entre cero")
    finally:
        print("Operación finalizada")

dividir("10", "2")
dividir("10", "0")
dividir("abc", "2")
````

</details>