# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def crear_alumno() -> dict:
    # TODO: devuelve {"nombre": "Ana", "edad": 20, "curso": "Matemáticas"}
    raise NotImplementedError


def agregar_nota(alumno: dict, nota: int) -> dict:
    # TODO: añade alumno["nota"] = nota y devuelve alumno
    raise NotImplementedError


def actualizar_edad(alumno: dict, edad: int) -> dict:
    # TODO: actualiza alumno["edad"] = edad y devuelve alumno
    raise NotImplementedError


def obtener_email(alumno: dict) -> str:
    # TODO: devuelve alumno.get("email", "sin email")
    raise NotImplementedError


def formatear_items(alumno: dict) -> list:
    # TODO: devuelve una lista de strings "clave: valor" iterando con .items()
    raise NotImplementedError


if __name__ == "__main__":
    alumno = crear_alumno()
    agregar_nota(alumno, 18)
    actualizar_edad(alumno, 21)
    print(alumno["nombre"])
    print(alumno)
    print(obtener_email(alumno))
    for linea in formatear_items(alumno):
        print(linea)