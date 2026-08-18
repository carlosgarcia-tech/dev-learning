# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def numeros_1_al_10() -> str:
    # TODO: devuelve "1, 2, 3, 4, 5, 6, 7, 8, 9, 10" con un for + range
    raise NotImplementedError


def tabla_multiplicar(base: int, limite: int) -> list:
    # TODO: devuelve una lista de strings con la tabla de multiplicar de base
    # del 1 al limite, formato "7 x 1 = 7"
    raise NotImplementedError


def suma_hasta(n: int) -> int:
    # TODO: devuelve la suma de los números del 1 al n usando un while
    raise NotImplementedError


def numeros_pares(lista: list) -> list:
    # TODO: devuelve una lista con solo los números pares de lista, usando
    # continue para saltar los impares
    raise NotImplementedError


def primer_multiplo_de(n: int) -> int:
    # TODO: devuelve el primer número >= 1 divisible entre n, usando break
    raise NotImplementedError


if __name__ == "__main__":
    print(numeros_1_al_10())
    for fila in tabla_multiplicar(7, 10):
        print(fila)
    print(f"Suma 1..100: {suma_hasta(100)}")
    print(f"Pares: {numeros_pares([3, 7, 12, 5, 8, 15])}")
    print(f"Primer múltiplo de 21: {primer_multiplo_de(21)}")