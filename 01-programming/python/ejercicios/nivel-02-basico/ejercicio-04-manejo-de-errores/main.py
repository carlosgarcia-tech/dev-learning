# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def dividir(a, b) -> str:
    # TODO: convierte a float, captura ValueError y ZeroDivisionError
    # y devuelve "Resultado: {x / y}", "Error: no son números válidos"
    # o "Error: división entre cero"
    raise NotImplementedError


if __name__ == "__main__":
    print(dividir("10", "2"))
    print(dividir("10", "0"))
    print(dividir("abc", "2"))