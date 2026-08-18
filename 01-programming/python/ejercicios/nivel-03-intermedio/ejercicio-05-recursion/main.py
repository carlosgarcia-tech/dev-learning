# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def factorial(n):
    # TODO: recursivo, 1 si n <= 1, si no n * factorial(n - 1)
    raise NotImplementedError


def fibonacci(n):
    # TODO: recursivo, n si n <= 1, si no fibonacci(n - 1) + fibonacci(n - 2)
    raise NotImplementedError


def suma_lista(lista):
    # TODO: recursivo, 0 si la lista está vacía, si no
    # lista[0] + suma_lista(lista[1:])
    raise NotImplementedError


if __name__ == "__main__":
    print(f"factorial(5) = {factorial(5)}")
    print(f"factorial(0) = {factorial(0)}")
    print(f"fibonacci(10) = {fibonacci(10)}")
    print(f"suma_lista([1, 2, 3, 4, 5]) = {suma_lista([1, 2, 3, 4, 5])}")