# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def contador_descendente(n):
    # TODO: con yield produce n, n-1, ..., 0
    raise NotImplementedError


def fibonacci(limite):
    # TODO: con yield produce los números de Fibonacci menores o iguales
    # a limite, empezando por 0, 1
    raise NotImplementedError


def pares_impares(n):
    # TODO: con yield produce ("par", i) para i par y ("impar", i) para
    # i impar, desde 0 hasta n
    raise NotImplementedError


if __name__ == "__main__":
    print("Contador descendente:", *contador_descendente(5))

    fib = fibonacci(50)
    print("Primeros Fibonacci:", next(fib), next(fib), next(fib))

    print("Etiquetas hasta 5:", *pares_impares(5))

    print("Lista:", list(contador_descendente(3)))