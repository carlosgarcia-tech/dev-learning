# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def frutas_iniciales() -> list:
    # TODO: devuelve ["manzana", "pera", "uva"]
    raise NotImplementedError


def agregar_kiwi(frutas: list) -> list:
    # TODO: frutas.append("kiwi") y devuelve frutas
    raise NotImplementedError


def insertar_limon(frutas: list) -> list:
    # TODO: frutas.insert(0, "limón") y devuelve frutas
    raise NotImplementedError


def extender_mango_papaya(frutas: list) -> list:
    # TODO: frutas.extend(["mango", "papaya"]) y devuelve frutas
    raise NotImplementedError


def quitar_pera(frutas: list) -> list:
    # TODO: frutas.remove("pera") y devuelve frutas
    raise NotImplementedError


def quitar_ultimo(frutas: list) -> tuple:
    # TODO: eliminado = frutas.pop(); devuelve (eliminado, frutas)
    raise NotImplementedError


def ordenar_frutas(frutas: list) -> list:
    # TODO: frutas.sort() y devuelve frutas
    raise NotImplementedError


def indice_de(frutas: list, elemento: str) -> int:
    # TODO: devuelve frutas.index(elemento)
    raise NotImplementedError


def contar(frutas: list, elemento: str) -> int:
    # TODO: devuelve frutas.count(elemento)
    raise NotImplementedError


if __name__ == "__main__":
    frutas = frutas_iniciales()
    print(agregar_kiwi(frutas))
    print(insertar_limon(frutas))
    print(extender_mango_papaya(frutas))
    print(quitar_pera(frutas))
    eliminado, frutas = quitar_ultimo(frutas)
    print(f"Eliminado: {eliminado}")
    print(ordenar_frutas(frutas))
    print(f"Índice de manzana: {indice_de(frutas, 'manzana')}")
    print(f"Veces uva: {contar(frutas, 'uva')}")