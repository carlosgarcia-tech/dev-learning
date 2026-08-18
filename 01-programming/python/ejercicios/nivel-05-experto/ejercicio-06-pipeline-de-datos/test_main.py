import unittest

from main import (
    VENTAS,
    agrupar_por_producto,
    enriquecer,
    filtrar_ventas,
    ordenar_por_total,
    resumir,
)


class TestPipelineDeDatos(unittest.TestCase):

    def test_enriquecer(self):
        enriquecidas = enriquecer(VENTAS)
        self.assertEqual(enriquecidas[0]["total"], 15.0)
        self.assertEqual(enriquecidas[0]["producto"], "manzana")
        self.assertNotIn("total", VENTAS[0])

    def test_enriquecer_lista_vacia(self):
        self.assertEqual(enriquecer([]), [])

    def test_filtrar(self):
        filtradas = filtrar_ventas(enriquecer(VENTAS))
        self.assertTrue(all(v["total"] >= 10 for v in filtradas))

    def test_filtrar_incluye_limite(self):
        filtradas = filtrar_ventas(enriquecer(VENTAS))
        productos = [v["producto"] for v in filtradas]
        self.assertEqual(productos.count("pera"), 1)

    def test_filtrar_lista_vacia(self):
        self.assertEqual(filtrar_ventas([]), [])

    def test_agrupar(self):
        filtradas = filtrar_ventas(enriquecer(VENTAS))
        por_producto = agrupar_por_producto(filtradas)
        self.assertEqual(por_producto["manzana"], 45.0)
        self.assertEqual(por_producto["uva"], 24.0)
        self.assertEqual(por_producto["pera"], 10.0)

    def test_ordenar(self):
        filtradas = filtrar_ventas(enriquecer(VENTAS))
        por_producto = agrupar_por_producto(filtradas)
        ordenadas = ordenar_por_total(por_producto)
        self.assertEqual([p for p, _ in ordenadas], ["manzana", "uva", "pera"])
        self.assertEqual([t for _, t in ordenadas], [45.0, 24.0, 10.0])

    def test_resumir(self):
        lineas = resumir(VENTAS)
        self.assertEqual(
            lineas,
            [
                "Producto: manzana - Total: 45.00",
                "Producto: uva - Total: 24.00",
                "Producto: pera - Total: 10.00",
                "TOTAL: 79.00",
            ],
        )

    def test_resumir_vacio(self):
        self.assertEqual(resumir([]), ["TOTAL: 0.00"])


if __name__ == "__main__":
    unittest.main()