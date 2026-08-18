# Ejercicio 05 — Testing con pytest

- **Nivel:** 4/5
- **Tema:** pytest, assert, fixtures, parametrize, pytest.raises
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `calculadora.py` con las funciones `sumar(a, b)`, `restar(a, b)`, `multiplicar(a, b)` y `dividir(a, b)` (que lance `ZeroDivisionError` si `b == 0`).

Crea un archivo de tests `test_calculadora.py` con:

1. Una **fixture** `calculadora` que devuelva el módulo importado (o simplemente un diccionario con las funciones).
2. Al menos 3 tests `test_sumar`, `test_restar`, `test_multiplicar` con casos normales y `assert`.
3. Un test parametrizado con `@pytest.mark.parametrize` para `sumar` con 3 casos.
4. Un test `test_dividir_por_cero` que use `pytest.raises(ZeroDivisionError)`.
5. Un test para `restar` con números negativos.

Ejecuta con `pytest test_calculadora.py -v`.

Salida esperada: todos los tests pasan.

## Requisitos

- [ ] Instalar pytest con `pip install pytest` si no está disponible.
- [ ] Crear la fixture con `@pytest.fixture`.
- [ ] Usar `@pytest.mark.parametrize`.
- [ ] Usar `pytest.raises`.
- [ ] Ejecutar `pytest test_calculadora.py -v` y verificar que todos los tests pasan.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los tests son funciones que empiezan por `test_` dentro de un archivo `test_*.py`.
- La fixture se recibe como argumento de la función de test.
- `with pytest.raises(ZeroDivisionError):` verifica que la excepción ocurre.
- `@pytest.mark.parametrize("a,b,esperado", [(1, 2, 3), ...])` ejecuta el test con cada caso.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `calculadora.py`:

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
````

Archivo `test_calculadora.py`:

````python
import pytest

import calculadora


@pytest.fixture
def calc():
    return calculadora


def test_sumar(calc):
    assert calc.sumar(2, 3) == 5
    assert calc.sumar(-1, 1) == 0


def test_restar(calc):
    assert calc.restar(10, 4) == 6


def test_restar_negativos(calc):
    assert calc.restar(-5, -3) == -2


def test_multiplicar(calc):
    assert calc.multiplicar(4, 3) == 12
    assert calc.multiplicar(0, 5) == 0


@pytest.mark.parametrize("a,b,esperado", [
    (1, 2, 3),
    (10, 20, 30),
    (-5, 5, 0),
])
def test_sumar_parametrizado(calc, a, b, esperado):
    assert calc.sumar(a, b) == esperado


def test_dividir_por_cero(calc):
    with pytest.raises(ZeroDivisionError):
        calc.dividir(1, 0)
````

</details>