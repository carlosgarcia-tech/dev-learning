# Ejercicio 04 — Módulos y paquetes

- **Nivel:** 3/5
- **Tema:** módulos, import, if __name__, paquetes
- **Tiempo estimado:** 30 min

## Enunciado

Crea un paquete `calculadora/` con esta estructura:

```
calculadora/
├── __init__.py
├── operaciones.py
└── main.py
```

- `__init__.py` vacío (marca el directorio como paquete).
- `operaciones.py` con funciones `sumar(a, b)`, `restar(a, b)`, `multiplicar(a, b)` y `dividir(a, b)` (que lanza `ZeroDivisionError` si `b == 0`). Además, un bloque `if __name__ == "__main__":` que imprima `Probando operaciones` y llame a `sumar(2, 3)`.
- `main.py` que importe las funciones con `from operaciones import sumar, dividir` y con `import operaciones as ops`, imprima el resultado de `sumar(4, 5)`, `ops.restar(10, 3)`, `ops.multiplicar(3, 4)` y `dividir(10, 2)`, y maneje con `try/except` la llamada a `dividir(1, 0)`.

Ejecuta `python3 main.py` dentro de `calculadora/`.

Salida esperada:

```
Sumar: 9
Restar: 7
Multiplicar: 12
Dividir: 5.0
Error: no se puede dividir entre cero
```

## Requisitos

- [ ] Crear los 3 archivos del paquete.
- [ ] Usar `if __name__ == "__main__":` en `operaciones.py`.
- [ ] Importar con `from ... import ...` y `import ... as ...`.
- [ ] Manejar `ZeroDivisionError`.
- [ ] Ejecutar `python3 main.py` dentro de `calculadora/` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Al ejecutar `main.py` desde la carpeta `calculadora/`, `import operaciones` funciona porque ambos archivos están en el mismo directorio.
- `if __name__ == "__main__":` solo ejecuta el bloque cuando el archivo se corre directamente, no cuando se importa.
- `__init__.py` puede estar vacío y aún así marca el paquete.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `operaciones.py`:

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
    print("Probando operaciones")
    print(sumar(2, 3))
````

Archivo `main.py`:

````python
import operaciones as ops
from operaciones import dividir, sumar

print(f"Sumar: {sumar(4, 5)}")
print(f"Restar: {ops.restar(10, 3)}")
print(f"Multiplicar: {ops.multiplicar(3, 4)}")
print(f"Dividir: {dividir(10, 2)}")

try:
    dividir(1, 0)
except ZeroDivisionError as e:
    print(f"Error: {e}")
````

</details>