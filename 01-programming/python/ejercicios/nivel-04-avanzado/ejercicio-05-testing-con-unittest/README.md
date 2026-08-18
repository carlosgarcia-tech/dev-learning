# Ejercicio 05 — Testing con unittest

- **Nivel:** 4/5
- **Tema:** unittest, TestCase, setUp, assertEqual, assertRaises, subTest
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` con las funciones `sumar(a, b)`, `restar(a, b)`, `multiplicar(a, b)` y `dividir(a, b)` (que lance `ZeroDivisionError` si `b == 0`).

Después escribe en `test_main.py` los tests con **unittest** (módulo estándar, sin instalar nada):

1. Una clase que herede de `unittest.TestCase`.
2. Un método `setUp` que prepare datos o casos reutilizables.
3. Al menos 3 tests `test_sumar`, `test_restar`, `test_multiplicar` con casos normales y `assertEqual`.
4. Un test "parametrizado" con `subTest` para `sumar` con 3 casos (el equivalente a `@pytest.mark.parametrize`).
5. Un test `test_dividir_por_cero` que use `assertRaises(ZeroDivisionError)`.
6. Un test para `restar` con números negativos.

Ejecuta con `python3 test_main.py`.

Salida esperada: todos los tests pasan (exit code `0`).

## Requisitos

- [ ] Implementar las 4 operaciones en `main.py`.
- [ ] La clase de tests hereda de `unittest.TestCase`.
- [ ] Usar `setUp` para preparar datos compartidos.
- [ ] Usar `assertEqual` para las comprobaciones.
- [ ] Usar `assertRaises` para verificar `ZeroDivisionError`.
- [ ] Usar `subTest` para simular `parametrize`.
- [ ] Ejecutar `python3 test_main.py` y verificar que todos los tests pasan.

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

- Los tests son métodos que empiezan por `test_` dentro de una clase que hereda de `unittest.TestCase`.
- `setUp()` se ejecuta antes de cada test; `tearDown()` después.
- `self.assertEqual(actual, esperado)` compara dos valores.
- `with self.assertRaises(ZeroDivisionError):` verifica que la excepción ocurre.
- `with self.subTest(a=a, b=b):` repite un bloque con varios casos y reporta cada fallo por separado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Archivo `main.py`:

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
    print(f"2 + 3 = {sumar(2, 3)}")
    print(f"10 - 4 = {restar(10, 4)}")
    print(f"4 * 3 = {multiplicar(4, 3)}")
    print(f"10 / 2 = {dividir(10, 2)}")
````

Archivo `test_main.py`:

````python
import unittest

from main import dividir, multiplicar, restar, sumar


class TestCalculadora(unittest.TestCase):

    def setUp(self):
        self.casos_suma = [(2, 3, 5), (10, 20, 30), (-5, 5, 0)]

    def test_sumar(self):
        self.assertEqual(sumar(2, 3), 5)
        self.assertEqual(sumar(-1, 1), 0)

    def test_sumar_parametrizado_con_subtest(self):
        for a, b, esperado in self.casos_suma:
            with self.subTest(a=a, b=b):
                self.assertEqual(sumar(a, b), esperado)

    def test_restar(self):
        self.assertEqual(restar(10, 4), 6)

    def test_restar_negativos(self):
        self.assertEqual(restar(-5, -3), -2)

    def test_multiplicar(self):
        self.assertEqual(multiplicar(4, 3), 12)
        self.assertEqual(multiplicar(0, 5), 0)

    def test_dividir(self):
        self.assertEqual(dividir(10, 2), 5)
        self.assertEqual(dividir(7, 2), 3.5)

    def test_dividir_por_cero(self):
        with self.assertRaises(ZeroDivisionError):
            dividir(1, 0)


if __name__ == "__main__":
    unittest.main()
````

</details>