import unittest

from main import Animal, Gato, Perro


class TestClasesYHerencia(unittest.TestCase):

    def test_animal_hablar(self):
        self.assertEqual(Animal("X").hablar(), "...")

    def test_perro_hablar(self):
        self.assertEqual(Perro("Rex").hablar(), "Guau")

    def test_gato_hablar(self):
        self.assertEqual(Gato("Mishi").hablar(), "Miau")

    def test_perro_correr(self):
        self.assertEqual(Perro("Rex").correr(), "Rex corre rápido")

    def test_descripcion_animal(self):
        self.assertEqual(Animal("Rex").descripcion, "Rex es un animal")

    def test_descripcion_perro(self):
        self.assertEqual(Perro("Rex").descripcion, "Rex es un animal")

    def test_descripcion_gato(self):
        self.assertEqual(Gato("Mishi").descripcion, "Mishi es un animal")

    def test_nombre_propiedad(self):
        perro = Perro("Rex")
        self.assertEqual(perro.nombre, "Rex")
        perro.nombre = "Firulais"
        self.assertEqual(perro.nombre, "Firulais")

    def test_nombre_vacio_lanza_valueerror(self):
        perro = Perro("Rex")
        with self.assertRaises(ValueError):
            perro.nombre = ""

    def test_herencia_instancias(self):
        self.assertIsInstance(Perro("Rex"), Animal)
        self.assertIsInstance(Gato("Mishi"), Animal)
        self.assertIsInstance(Perro("Rex"), Perro)

    def test_super_init_nombre(self):
        self.assertEqual(Perro("Rex").nombre, "Rex")
        self.assertEqual(Gato("Mishi").nombre, "Mishi")


if __name__ == "__main__":
    unittest.main()