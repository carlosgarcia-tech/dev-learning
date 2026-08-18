# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import functools

numeros = [5, 12, 7, 18, 3, 21, 9]
palabras = ["python", "es", "genial", "para", "datos"]


def negativos(lista):
    # TODO: devuelve list(map(lambda n: -n, lista))
    raise NotImplementedError


def mayores_que(lista, limite=10):
    # TODO: devuelve list(filter(lambda n: n > limite, lista))
    raise NotImplementedError


def longitudes(lista):
    # TODO: devuelve list(map(lambda p: len(p), lista))
    raise NotImplementedError


def ordenar_por_longitud(lista):
    # TODO: devuelve sorted(lista, key=lambda p: len(p))
    raise NotImplementedError


def maximo(lista):
    # TODO: devuelve functools.reduce(lambda a, b: a if a > b else b, lista)
    raise NotImplementedError


def main() -> None:
    # TODO: imprime Negativos, Mayores que 10, Largos, Palabras por longitud y Máximo
    raise NotImplementedError


if __name__ == "__main__":
    main()