import unittest

from main import (
    agregar_kiwi,
    contar,
    extender_mango_papaya,
    frutas_iniciales,
    indice_de,
    insertar_limon,
    ordenar_frutas,
    quitar_pera,
    quitar_ultimo,
)


class TestMetodosDeListas(unittest.TestCase):

    def test_frutas_iniciales(self):
        self.assertEqual(frutas_iniciales(), ["manzana", "pera", "uva"])

    def test_append(self):
        self.assertEqual(
            agregar_kiwi(frutas_iniciales()),
            ["manzana", "pera", "uva", "kiwi"],
        )

    def test_insert(self):
        frutas = agregar_kiwi(frutas_iniciales())
        self.assertEqual(
            insertar_limon(frutas),
            ["limón", "manzana", "pera", "uva", "kiwi"],
        )

    def test_extend(self):
        frutas = insertar_limon(agregar_kiwi(frutas_iniciales()))
        self.assertEqual(
            extender_mango_papaya(frutas),
            ["limón", "manzana", "pera", "uva", "kiwi", "mango", "papaya"],
        )

    def test_remove(self):
        frutas = extender_mango_papaya(
            insertar_limon(agregar_kiwi(frutas_iniciales()))
        )
        self.assertEqual(
            quitar_pera(frutas),
            ["limón", "manzana", "uva", "kiwi", "mango", "papaya"],
        )

    def test_pop_devuelve_ultimo(self):
        frutas = quitar_pera(
            extender_mango_papaya(insertar_limon(agregar_kiwi(frutas_iniciales())))
        )
        eliminado, restantes = quitar_ultimo(frutas)
        self.assertEqual(eliminado, "papaya")
        self.assertEqual(restantes, ["limón", "manzana", "uva", "kiwi", "mango"])

    def test_sort(self):
        frutas = quitar_pera(
            extender_mango_papaya(insertar_limon(agregar_kiwi(frutas_iniciales())))
        )
        quitar_ultimo(frutas)
        self.assertEqual(
            ordenar_frutas(frutas),
            ["kiwi", "limón", "mango", "manzana", "uva"],
        )

    def test_index(self):
        frutas = quitar_pera(
            extender_mango_papaya(insertar_limon(agregar_kiwi(frutas_iniciales())))
        )
        quitar_ultimo(frutas)
        ordenar_frutas(frutas)
        self.assertEqual(indice_de(frutas, "manzana"), 3)

    def test_count(self):
        frutas = quitar_pera(
            extender_mango_papaya(insertar_limon(agregar_kiwi(frutas_iniciales())))
        )
        quitar_ultimo(frutas)
        ordenar_frutas(frutas)
        self.assertEqual(contar(frutas, "uva"), 1)
        self.assertEqual(contar(frutas, "limón"), 1)


if __name__ == "__main__":
    unittest.main()