# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import functools


def sumar_todos(*args):
    # TODO: devuelve la suma de todos los argumentos posicionales
    raise NotImplementedError


def imprimir_datos(**kwargs):
    # TODO: devuelve un str con cada par "  clave=valor" en una línea propia
    # separados por \n
    raise NotImplementedError


def elevar_al_cuadrado(numeros):
    # TODO: usa map con una lambda y devuelve list(...) con los cuadrados
    raise NotImplementedError


def filtrar_pares(numeros):
    # TODO: usa filter con una lambda y devuelve list(...) con los pares
    raise NotImplementedError


def ordenar_por_edad(personas):
    # TODO: usa sorted(personas, key=lambda p: p[1]) para ordenar por edad
    raise NotImplementedError


def multiplicar_todos(numeros):
    # TODO: usa functools.reduce con una lambda para multiplicar todos
    raise NotImplementedError


if __name__ == "__main__":
    print(f"Suma de 1..5: {sumar_todos(1, 2, 3, 4, 5)}")
    print("datos:")
    print(imprimir_datos(nombre="Ana", edad=30, ciudad="Lima"))

    print(f"Cuadrados: {elevar_al_cuadrado([1, 2, 3, 4, 5])}")
    print(f"Pares: {filtrar_pares([1, 2, 3, 4, 5, 6])}")

    personas = [("ana", 30), ("luis", 22), ("pedro", 28)]
    print(f"Ordenados por edad: {ordenar_por_edad(personas)}")

    print(f"Producto: {multiplicar_todos([1, 2, 3, 4])}")