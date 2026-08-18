# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def calcular(a: float, b: float, op: str) -> float:
    # TODO: devuelve el resultado de a op b. Si op es "/" y b es 0, lanza
    # ZeroDivisionError("No se puede dividir entre cero"). Si op no es válido,
    # lanza ValueError("Operador no válido").
    raise NotImplementedError


if __name__ == "__main__":
    print(calcular(10.0, 3.0, "/"))
    print(calcular(2, 3, "+"))
    try:
        calcular(10, 0, "/")
    except ZeroDivisionError as e:
        print(e)
    try:
        calcular(2, 3, "x")
    except ValueError as e:
        print(e)