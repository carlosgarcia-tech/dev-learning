# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def numeros() -> list:
    # TODO: devuelve list(range(1, 21))
    raise NotImplementedError


def cuadrados(numeros: list) -> list:
    # TODO: devuelve [n ** 2 for n in numeros]
    raise NotImplementedError


def pares(numeros: list) -> list:
    # TODO: devuelve [n for n in numeros if n % 2 == 0]
    raise NotImplementedError


def multiplos_de_3(numeros: list) -> list:
    # TODO: devuelve [n for n in numeros if n % 3 == 0]
    raise NotImplementedError


def etiquetas(numeros: list) -> list:
    # TODO: devuelve ["par" if n % 2 == 0 else "impar" for n in numeros]
    raise NotImplementedError


def divididos(numeros: list) -> list:
    # TODO: devuelve [n / 2 for n in numeros]
    raise NotImplementedError


if __name__ == "__main__":
    nums = numeros()
    print(f"Cuadrados: {cuadrados(nums)}")
    print(f"Pares: {pares(nums)}")
    print(f"Múltiplos de 3: {multiplos_de_3(nums)}")
    print(f"Etiquetas: {etiquetas(nums)}")
    print(f"Divididos: {divididos(nums)}")