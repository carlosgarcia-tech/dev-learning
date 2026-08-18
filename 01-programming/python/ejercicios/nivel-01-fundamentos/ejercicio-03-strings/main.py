# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def mayusculas(frase: str) -> str:
    # TODO: devuelve frase.upper()
    raise NotImplementedError


def minusculas(frase: str) -> str:
    # TODO: devuelve frase.lower()
    raise NotImplementedError


def titulo(frase: str) -> str:
    # TODO: devuelve frase.title()
    raise NotImplementedError


def n_caracteres(frase: str) -> int:
    # TODO: devuelve len(frase)
    raise NotImplementedError


def n_palabras(frase: str) -> int:
    # TODO: devuelve len(frase.split())
    raise NotImplementedError


def invertida(frase: str) -> str:
    # TODO: devuelve frase[::-1]
    raise NotImplementedError


def contar_a(frase: str) -> int:
    # TODO: devuelve frase.count("a")
    raise NotImplementedError


if __name__ == "__main__":
    frase = "Hola mundo"
    print(f"Mayúsculas: {mayusculas(frase)}")
    print(f"Minúsculas: {minusculas(frase)}")
    print(f"Título: {titulo(frase)}")
    print(f"Caracteres: {n_caracteres(frase)}")
    print(f"Palabras: {n_palabras(frase)}")
    print(f"Invertida: {invertida(frase)}")
    print(f"Veces la letra 'a': {contar_a(frase)}")