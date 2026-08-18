# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def nombre() -> str:
    # TODO: devuelve tu nombre (ej. "Ana")
    raise NotImplementedError


def ciudad() -> str:
    # TODO: devuelve tu ciudad de nacimiento (ej. "Lima")
    raise NotImplementedError


def edad() -> int:
    # TODO: devuelve tu edad (ej. 30)
    raise NotImplementedError


def estudia_programacion() -> bool:
    # TODO: devuelve True
    raise NotImplementedError


def tipo_de(valor) -> str:
    # TODO: devuelve el nombre del tipo de valor, ej. type(valor).__name__
    raise NotImplementedError


def formatear_descripcion(nombre, ciudad, edad, programacion) -> str:
    # TODO: devuelve con f-strings:
    # f"Soy {nombre}, tengo {edad} años, nací en {ciudad} y es {programacion} que estudio programación."
    raise NotImplementedError


if __name__ == "__main__":
    print(tipo_de("hola"))
    print(tipo_de(42))
    print(tipo_de(True))
    print(formatear_descripcion("Ana", "Lima", 30, True))