import json
import os
import tempfile
import unittest

from main import agregar, cargar, completar, eliminar, guardar, listar


class TestGestorTareas(unittest.TestCase):

    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.ruta = os.path.join(self.dir.name, "tareas.json")

    def tearDown(self):
        self.dir.cleanup()

    def test_cargar_sin_archivo(self):
        self.assertEqual(cargar(self.ruta), [])

    def test_cargar_archivo_existente(self):
        tareas = [{"id": 1, "descripcion": "x", "estado": "pendiente"}]
        with open(self.ruta, "w", encoding="utf-8") as f:
            json.dump(tareas, f)
        self.assertEqual(cargar(self.ruta), tareas)

    def test_guardar(self):
        tareas = [{"id": 1, "descripcion": "x", "estado": "pendiente"}]
        guardar(self.ruta, tareas)
        self.assertTrue(os.path.exists(self.ruta))
        with open(self.ruta, encoding="utf-8") as f:
            self.assertEqual(json.load(f), tareas)

    def test_agregar(self):
        self.assertEqual(agregar(self.ruta, "Comprar pan"), "Tarea 1 añadida")
        tareas = cargar(self.ruta)
        self.assertEqual(len(tareas), 1)
        self.assertEqual(tareas[0], {"id": 1, "descripcion": "Comprar pan", "estado": "pendiente"})

    def test_agregar_ids_autoincrementales(self):
        agregar(self.ruta, "A")
        agregar(self.ruta, "B")
        self.assertEqual([t["id"] for t in cargar(self.ruta)], [1, 2])

    def test_listar(self):
        agregar(self.ruta, "Comprar pan")
        agregar(self.ruta, "Estudiar Python")
        self.assertEqual(
            listar(self.ruta),
            ["[1] pendiente — Comprar pan", "[2] pendiente — Estudiar Python"],
        )

    def test_listar_vacio(self):
        self.assertEqual(listar(self.ruta), [])

    def test_completar(self):
        agregar(self.ruta, "Comprar pan")
        self.assertEqual(completar(self.ruta, 1), "Tarea 1 completada")
        self.assertEqual(cargar(self.ruta)[0]["estado"], "completada")

    def test_completar_no_encontrada(self):
        agregar(self.ruta, "Comprar pan")
        self.assertEqual(completar(self.ruta, 99), "Tarea 99 no encontrada")
        self.assertEqual(cargar(self.ruta)[0]["estado"], "pendiente")

    def test_eliminar(self):
        agregar(self.ruta, "Comprar pan")
        agregar(self.ruta, "Estudiar Python")
        self.assertEqual(eliminar(self.ruta, 2), "Tarea 2 eliminada")
        tareas = cargar(self.ruta)
        self.assertEqual(len(tareas), 1)
        self.assertEqual(tareas[0]["id"], 1)

    def test_eliminar_no_encontrada(self):
        agregar(self.ruta, "Comprar pan")
        self.assertEqual(eliminar(self.ruta, 99), "Tarea 99 no encontrada")
        self.assertEqual(len(cargar(self.ruta)), 1)


if __name__ == "__main__":
    unittest.main()