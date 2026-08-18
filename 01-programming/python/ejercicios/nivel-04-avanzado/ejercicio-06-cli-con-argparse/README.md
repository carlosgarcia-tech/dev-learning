# Ejercicio 06 — CLI con argparse

- **Nivel:** 4/5
- **Tema:** argparse, argumentos posicionales, opciones, valores por defecto
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para implementar un conversor de temperaturas con **funciones puras testables** y una CLI con `argparse`:

1. `a_celsius(valor, escala)` — convierte un valor a grados Celsius según `escala`; lanza `ValueError` si la escala es desconocida.
2. `desde_celsius(valor, destino)` — convierte un valor desde Celsius a la unidad `destino`; lanza `ValueError` si el destino es desconocido.
3. `convertir(valor, escala, destino)` — combina las dos anteriores.
4. `formatear_salida(grados, escala, destino, resultado)` — devuelve `X °<origen> = Y °<destino>` con 2 decimales.
5. `main(argv=None)` — la CLI con `argparse`:
   - Argumento posicional `grados` (float).
   - Opción `--escala` con valores `celsius`, `fahrenheit`, `kelvin` (por defecto `celsius`): unidad de entrada.
   - Opción `--destino` con valores `celsius`, `fahrenheit`, `kelvin` (por defecto `fahrenheit`): unidad de salida.
   - Convierte con `convertir` y muestra `formatear_salida`.

Fórmulas: `f = c * 9/5 + 32`, `k = c + 273.15`, `c = (f - 32) * 5/9`, `k = (f - 32) * 5/9 + 273.15`, `c = k - 273.15`, `f = (k - 273.15) * 9/5 + 32`.

Salida esperada (ejemplos):

```
$ python3 main.py 100 --escala celsius --destino fahrenheit
100.00 °celsius = 212.00 °fahrenheit

$ python3 main.py 0 --escala celsius --destino kelvin
0.00 °celsius = 273.15 °kelvin

$ python3 main.py 32 --escala fahrenheit --destino celsius
32.00 °fahrenheit = 0.00 °celsius
```

## Requisitos

- [ ] `a_celsius` y `desde_celsius` convierten entre las 3 unidades.
- [ ] `convertir` combina ambas conversiones.
- [ ] `formatear_salida` usa f-strings con 2 decimales.
- [ ] `main` define el parser con `argparse.ArgumentParser`.
- [ ] El argumento posicional y las opciones usan `choices` y `default`.
- [ ] `if __name__ == "__main__":` llama a `main()`.
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

- `parser.add_argument("grados", type=float)` define un argumento posicional.
- `choices=["celsius", ...]` y `default="celsius"` validan y dan valor por defecto.
- Convierte primero a Celsius y luego al destino para simplificar.
- `parser.parse_args(argv)` permite probar la CLI con una lista de argumentos; con `argv=None` usa `sys.argv`.
- `args.grados` y `args.escala` acceden a los valores parseados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import argparse


def a_celsius(valor, escala):
    if escala == "celsius":
        return valor
    if escala == "fahrenheit":
        return (valor - 32) * 5 / 9
    if escala == "kelvin":
        return valor - 273.15
    raise ValueError(f"Escala desconocida: {escala}")


def desde_celsius(valor, destino):
    if destino == "celsius":
        return valor
    if destino == "fahrenheit":
        return valor * 9 / 5 + 32
    if destino == "kelvin":
        return valor + 273.15
    raise ValueError(f"Destino desconocido: {destino}")


def convertir(valor, escala, destino):
    return desde_celsius(a_celsius(valor, escala), destino)


def formatear_salida(grados, escala, destino, resultado):
    return f"{grados:.2f} °{escala} = {resultado:.2f} °{destino}"


def main(argv=None) -> None:
    parser = argparse.ArgumentParser(description="Conversor de temperaturas")
    parser.add_argument("grados", type=float, help="Valor a convertir")
    parser.add_argument(
        "--escala",
        choices=["celsius", "fahrenheit", "kelvin"],
        default="celsius",
        help="Unidad de entrada",
    )
    parser.add_argument(
        "--destino",
        choices=["celsius", "fahrenheit", "kelvin"],
        default="fahrenheit",
        help="Unidad de salida",
    )
    args = parser.parse_args(argv)

    resultado = convertir(args.grados, args.escala, args.destino)
    print(formatear_salida(args.grados, args.escala, args.destino, resultado))


if __name__ == "__main__":
    main()
````

</details>