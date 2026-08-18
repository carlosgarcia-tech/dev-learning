import unittest

from main import CacheLRU


class TestCacheLRU(unittest.TestCase):

    def test_get_clave_inexistente_devuelve_none(self):
        cache = CacheLRU(2)
        self.assertIsNone(cache.get("a"))

    def test_put_y_get(self):
        cache = CacheLRU(2)
        cache.put("a", 1)
        self.assertEqual(cache.get("a"), 1)

    def test_put_actualiza_valor_existente(self):
        cache = CacheLRU(2)
        cache.put("a", 1)
        cache.put("a", 99)
        self.assertEqual(cache.get("a"), 99)
        self.assertEqual(len(cache), 1)

    def test_expulsion_lru(self):
        cache = CacheLRU(2)
        cache.put("a", 1)
        cache.put("b", 2)
        cache.get("a")          # "a" pasa a ser la más reciente
        cache.put("c", 3)       # expulsa "b"
        self.assertIsNone(cache.get("b"))
        self.assertEqual(cache.get("a"), 1)
        self.assertEqual(cache.get("c"), 3)

    def test_tamano(self):
        cache = CacheLRU(3)
        cache.put("a", 1)
        cache.put("b", 2)
        cache.put("c", 3)
        self.assertEqual(len(cache), 3)

    def test_capacidad_uno(self):
        cache = CacheLRU(1)
        cache.put("a", 1)
        cache.put("b", 2)
        self.assertIsNone(cache.get("a"))
        self.assertEqual(cache.get("b"), 2)

    def test_acceso_marca_reciente(self):
        cache = CacheLRU(2)
        cache.put("a", 1)
        cache.put("b", 2)
        cache.get("a")
        cache.put("c", 3)
        self.assertIsNone(cache.get("b"))
        self.assertEqual(cache.get("a"), 1)


if __name__ == "__main__":
    unittest.main()