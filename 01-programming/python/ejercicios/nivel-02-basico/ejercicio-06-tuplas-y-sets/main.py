# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def desempaquetar(punto: tuple) -> tuple:
    # TODO: x, y = punto; devuelve (x, y)
    raise NotImplementedError


def es_inmutable(punto: tuple) -> bool:
    # TODO: intenta punto[0] = 10; devuelve True si lanza TypeError
    raise NotImplementedError


def union(a: set, b: set) -> set:
    # TODO: devuelve a | b
    raise NotImplementedError


def interseccion(a: set, b: set) -> set:
    # TODO: devuelve a & b
    raise NotImplementedError


def diferencia(a: set, b: set) -> set:
    # TODO: devuelve a - b
    raise NotImplementedError


def sin_duplicados(lista: list) -> list:
    # TODO: devuelve sorted(set(lista))
    raise NotImplementedError


if __name__ == "__main__":
    punto = (3, 5)
    x, y = desempaquetar(punto)
    print(f"x={x}, y={y}")
    print("Las tuplas son inmutables" if es_inmutable(punto) else "Mutable")

    estudiantes_a = {"ana", "luis", "maria"}
    estudiantes_b = {"luis", "carlos", "pablo"}
    print(f"Unión: {union(estudiantes_a, estudiantes_b)}")
    print(f"Intersección: {interseccion(estudiantes_a, estudiantes_b)}")
    print(f"Diferencia: {diferencia(estudiantes_a, estudiantes_b)}")

    numeros = [1, 2, 2, 3, 3, 3, 4]
    print(f"Sin duplicados: {sin_duplicados(numeros)}")