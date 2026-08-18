import unittest

from main import (
    actualizar_edad,
    agregar_nota,
    crear_alumno,
    formatear_items,
    obtener_email,
)


class TestDiccionariosBasicos(unittest.TestCase):

    def test_crear_alumno(self):
        self.assertEqual(
            crear_alumno(),
            {"nombre": "Ana", "edad": 20, "curso": "Matemáticas"},
        )

    def test_agregar_nota(self):
        alumno = crear_alumno()
        agregar_nota(alumno, 18)
        self.assertEqual(alumno["nota"], 18)

    def test_actualizar_edad(self):
        alumno = crear_alumno()
        actualizar_edad(alumno, 21)
        self.assertEqual(alumno["edad"], 21)

    def test_obtener_email_default(self):
        alumno = crear_alumno()
        self.assertEqual(obtener_email(alumno), "sin email")

    def test_obtener_email_existente(self):
        alumno = crear_alumno()
        alumno["email"] = "ana@example.com"
        self.assertEqual(obtener_email(alumno), "ana@example.com")

    def test_formatear_items(self):
        alumno = crear_alumno()
        agregar_nota(alumno, 18)
        actualizar_edad(alumno, 21)
        self.assertEqual(
            formatear_items(alumno),
            [
                "nombre: Ana",
                "edad: 21",
                "curso: Matemáticas",
                "nota: 18",
            ],
        )


if __name__ == "__main__":
    unittest.main()