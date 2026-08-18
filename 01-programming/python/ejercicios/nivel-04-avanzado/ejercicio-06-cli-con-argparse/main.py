# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import argparse


def a_celsius(valor, escala):
    # TODO: convierte valor a grados Celsius según escala y
    # lanza ValueError si la escala es desconocida
    raise NotImplementedError


def desde_celsius(valor, destino):
    # TODO: convierte valor desde Celsius a la unidad destino y
    # lanza ValueError si el destino es desconocido
    raise NotImplementedError


def convertir(valor, escala, destino):
    # TODO: devuelve desde_celsius(a_celsius(valor, escala), destino)
    raise NotImplementedError


def formatear_salida(grados, escala, destino, resultado):
    # TODO: devuelve f"{grados:.2f} °{escala} = {resultado:.2f} °{destino}"
    raise NotImplementedError


def main(argv=None) -> None:
    # TODO: define el parser con argparse (grados, --escala, --destino),
    # convierte con convertir() y muestra formatear_salida()
    raise NotImplementedError


if __name__ == "__main__":
    main()