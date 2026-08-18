# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import contextlib
import time


class Temporizador:
    def __enter__(self):
        # TODO: guarda self.inicio = time.perf_counter() y devuelve self
        raise NotImplementedError

    def __exit__(self, exc_type, exc_val, exc_tb):
        # TODO: guarda self.transcurrido, imprime "Transcurrido: X.XXXXs"
        # y devuelve False para no suprimir excepciones
        raise NotImplementedError


def sumar_uno_a_millon() -> int:
    # TODO: devuelve sum(range(1, 1_000_001))
    raise NotImplementedError


@contextlib.contextmanager
def ignorar(Error):
    # TODO: envuelve el yield en try/except capturando Error
    # e imprime f"Excepción ignorada: {type(e)}"
    raise NotImplementedError


def main() -> None:
    # TODO: usa "with Temporizador():" para sumar_uno_a_millon() y
    # "with ignorar(ValueError):" para int("no es número")
    raise NotImplementedError


if __name__ == "__main__":
    main()