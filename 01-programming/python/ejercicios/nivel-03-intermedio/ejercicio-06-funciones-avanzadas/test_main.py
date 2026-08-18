import unittest

from main import (
    elevar_al_cuadrado,
    filtrar_pares,
    imprimir_datos,
    multiplicar_todos,
    ordenar_por_edad,
    sumar_todos,
)


class TestFuncionesAvanzadas(unittest.TestCase):

    def test_sumar_todos(self):
        self.assertEqual(sumar_todos(1, 2, 3, 4, 5), 15)

    def test_sumar_todos_un_argumento(self):
        self.assertEqual(sumar_todos(7), 7)

    def test_sumar_todos_sin_argumentos(self):
        self.assertEqual(sumar_todos(), 0)

    def test_imprimir_datos(self):
        texto = imprimir_datos(nombre="Ana", edad=30, ciudad="Lima")
        self.assertIn("nombre=Ana", texto)
        self.assertIn("edad=30", texto)
        self.assertIn("ciudad=Lima", texto)

    def test_elevar_al_cuadrado(self):
        self.assertEqual(elevar_al_cuadrado([1, 2, 3, 4, 5]), [1, 4, 9, 16, 25])

    def test_elevar_al_cuadrado_vacia(self):
        self.assertEqual(elevar_al_cuadrado([]), [])

    def test_filtrar_pares(self):
        self.assertEqual(filtrar_pares([1, 2, 3, 4, 5, 6]), [2, 4, 6])

    def test_filtrar_pares_sin_pares(self):
        self.assertEqual(filtrar_pares([1, 3, 5]), [])

    def test_ordenar_por_edad(self):
        personas = [("ana", 30), ("luis", 22), ("pedro", 28)]
        self.assertEqual(
            ordenar_por_edad(personas),
            [("luis", 22), ("pedro", 28), ("ana", 30)],
        )

    def test_multiplicar_todos(self):
        self.assertEqual(multiplicar_todos([1, 2, 3, 4]), 24)


if __name__ == "__main__":
    unittest.main()