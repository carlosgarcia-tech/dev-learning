# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def primero(lista):
    # TODO: devuelve lista[0]
    raise NotImplementedError


def ultimo(lista):
    # TODO: devuelve lista[-1]
    raise NotImplementedError


def ordenada(lista):
    # TODO: devuelve sorted(lista)
    raise NotImplementedError


def invertida(lista):
    # TODO: devuelve lista[::-1]
    raise NotImplementedError


def suma(lista):
    # TODO: devuelve sum(lista)
    raise NotImplementedError


def minimo(lista):
    # TODO: devuelve min(lista)
    raise NotImplementedError


def maximo(lista):
    # TODO: devuelve max(lista)
    raise NotImplementedError


def dobles(lista):
    # TODO: devuelve una lista nueva con cada elemento multiplicado por 2
    # usando un bucle for y append()
    raise NotImplementedError


if __name__ == "__main__":
    numeros = [5, 2, 9, 1, 7, 3]
    print(f"Primero: {primero(numeros)}")
    print(f"Último: {ultimo(numeros)}")
    print(f"Ordenada: {ordenada(numeros)}")
    print(f"Invertida: {invertida(numeros)}")
    print(f"Suma: {suma(numeros)}")
    print(f"Mínimo: {minimo(numeros)}")
    print(f"Máximo: {maximo(numeros)}")
    print(f"Dobles: {dobles(numeros)}")