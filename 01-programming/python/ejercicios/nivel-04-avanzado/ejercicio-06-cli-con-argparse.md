# Ejercicio 06 — CLI con argparse

- **Nivel:** 4/5
- **Tema:** argparse, argumentos posicionales, opciones, valores por defecto
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `cli.py` que use `argparse` para implementar una utilidad de conversión de temperaturas:

1. Argumento posicional `grados` (float).
2. Opción `--escala` con valores `celsius`, `fahrenheit`, `kelvin` (por defecto `celsius`): indica la unidad de entrada.
3. Opción `--destino` con valores `celsius`, `fahrenheit`, `kelvin` (por defecto `fahrenheit`): indica la unidad de salida.
4. Convierta y muestre `X °<origen> = Y °<destino>` con 2 decimales.
5. Si `--destino` no es válido, `parser.error("Destino inválido")`.

Fórmulas: `f = c * 9/5 + 32`, `k = c + 273.15`, `c = (f - 32) * 5/9`, `k = (f - 32) * 5/9 + 273.15`, `c = k - 273.15`, `f = (k - 273.15) * 9/5 + 32`.

Salida esperada (ejemplos):

```
$ python3 cli.py 100 --escala celsius --destino fahrenheit
100.00 °celsius = 212.00 °fahrenheit

$ python3 cli.py 0 --escala celsius --destino kelvin
0.00 °celsius = 273.15 °kelvin

$ python3 cli.py 32 --escala fahrenheit --destino celsius
32.00 °fahrenheit = 0.00 °celsius
```

## Requisitos

- [ ] Definir el parser con `argparse.ArgumentParser`.
- [ ] Añadir el argumento posicional y las dos opciones con `choices` y `default`.
- [ ] Implementar la conversión entre las 3 unidades.
- [ ] Usar `parser.error` para valores no soportados.
- [ ] Ejecutar las 3 invocaciones de ejemplo y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `parser.add_argument("grados", type=float)` define un argumento posicional.
- `choices=["celsius", ...]` y `default="celsius"` validan y dan valor por defecto.
- Convierte primero a Celsius y luego al destino para simplificar.
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
    return valor - 273.15


def desde_celsius(valor, destino):
    if destino == "celsius":
        return valor
    if destino == "fahrenheit":
        return valor * 9 / 5 + 32
    return valor + 273.15


def convertir(valor, escala, destino):
    return desde_celsius(a_celsius(valor, escala), destino)


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
args = parser.parse_args()

resultado = convertir(args.grados, args.escala, args.destino)
print(
    f"{args.grados:.2f} °{args.escala} = "
    f"{resultado:.2f} °{args.destino}"
)
````

</details>