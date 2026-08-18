# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def escribir_datos(ruta: str):
    # TODO: escribe "uno\ndos\ntres\n" en ruta con with open(ruta, "w")
    raise NotImplementedError


def leer_completo(ruta: str) -> str:
    # TODO: devuelve f.read() de with open(ruta, "r")
    raise NotImplementedError


def leer_lineas(ruta: str) -> list:
    # TODO: devuelve f.readlines() de with open(ruta, "r")
    raise NotImplementedError


def leer_limpiadas(ruta: str) -> list:
    # TODO: devuelve [linea.strip() for linea in f] con with open(ruta, "r")
    raise NotImplementedError


def agregar_linea(ruta: str, linea: str):
    # TODO: escribe linea + "\n" en ruta con with open(ruta, "a")
    raise NotImplementedError


if __name__ == "__main__":
    ruta = "datos.txt"
    escribir_datos(ruta)
    print("Contenido crudo:")
    print(leer_completo(ruta))
    print(f"Lista de líneas: {leer_lineas(ruta)}")
    for linea in leer_limpiadas(ruta):
        print(f"Línea: {linea}")
    agregar_linea(ruta, "cuatro")
    print("Después de append:")
    print(leer_completo(ruta))