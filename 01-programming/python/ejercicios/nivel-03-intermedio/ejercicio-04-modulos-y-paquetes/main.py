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
    # TODO: si b == 0 lanza ZeroDivisionError("no se puede dividir entre cero"),
    # si no devuelve a / b
    raise NotImplementedError


if __name__ == "__main__":
    print(f"Sumar: {sumar(4, 5)}")
    print(f"Restar: {restar(10, 3)}")
    print(f"Multiplicar: {multiplicar(3, 4)}")
    print(f"Dividir: {dividir(10, 2)}")

    try:
        dividir(1, 0)
    except ZeroDivisionError as e:
        print(f"Error: {e}")