# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def sumar(a, b):
    # TODO: devuelve a + b
    raise NotImplementedError


def restar(a, b):
    # TODO: devuelve a - b
    raise NotImplementedError


def multiplicar(a, b):
    # TODO: devuelve a * b
    raise NotImplementedError


def dividir(a, b):
    # TODO: devuelve a / b y lanza ZeroDivisionError si b == 0
    raise NotImplementedError


if __name__ == "__main__":
    print(f"2 + 3 = {sumar(2, 3)}")
    print(f"10 - 4 = {restar(10, 4)}")
    print(f"4 * 3 = {multiplicar(4, 3)}")
    print(f"10 / 2 = {dividir(10, 2)}")