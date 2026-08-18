# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import functools
import time


def crear_contador():
    # TODO: devuelve un closure incrementar() con nonlocal que sume 1
    # y devuelva el valor actual del contador en cada llamada.
    raise NotImplementedError


def tiempo_ejecucion(func):
    # TODO: devuelve un envoltorio que mida el tiempo con time.perf_counter(),
    # imprima f"{func.__name__} tardó {segundos:.4f}s" y use functools.wraps.
    raise NotImplementedError


def repetir(veces):
    # TODO: devuelve un decorador que repita la llamada a la función decorada
    # 'veces' veces y devuelva el último resultado.
    raise NotImplementedError


if __name__ == "__main__":
    c1 = crear_contador()
    c2 = crear_contador()
    print("Contador 1:", c1(), c1(), c1())
    print("Contador 2:", c2(), c2(), c2())

    @tiempo_ejecucion
    def saludar(nombre):
        time.sleep(0.1)
        return f"Hola, {nombre}!"

    print(saludar("Ana"))

    @repetir(3)
    def hola():
        print("Hola desde repetir")

    hola()