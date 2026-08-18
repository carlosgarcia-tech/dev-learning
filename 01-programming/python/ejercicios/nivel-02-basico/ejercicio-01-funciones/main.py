# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def saludar(nombre: str) -> str:
    # TODO: devuelve f"Hola, {nombre}!"
    raise NotImplementedError


def area_rectangulo(base: float, altura: float) -> float:
    # TODO: devuelve base * altura
    raise NotImplementedError


def potencia(base: float, exponente: int = 2) -> float:
    # TODO: devuelve base ** exponente (usa el valor por defecto)
    raise NotImplementedError


def es_par(n: int) -> bool:
    # TODO: devuelve True si n es par (n % 2 == 0)
    raise NotImplementedError


def dividir(a: int, b: int) -> tuple:
    # TODO: devuelve (a // b, a % b)
    raise NotImplementedError


if __name__ == "__main__":
    print(saludar("Ana"))
    print(f"Area: {area_rectangulo(4, 5)}")
    print(f"Potencia (defecto): {potencia(3)}")
    print(f"Potencia (explícita): {potencia(2, 3)}")
    print(f"Es par 4: {es_par(4)}")
    print(f"Es par 7: {es_par(7)}")
    print(f"Dividir 10 entre 3: {dividir(10, 3)}")