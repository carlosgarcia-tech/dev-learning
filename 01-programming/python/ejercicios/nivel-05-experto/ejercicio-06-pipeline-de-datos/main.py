# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

VENTAS = [
    {"producto": "manzana", "cantidad": 10, "precio": 1.5},
    {"producto": "pera", "cantidad": 5, "precio": 2.0},
    {"producto": "manzana", "cantidad": 20, "precio": 1.5},
    {"producto": "uva", "cantidad": 8, "precio": 3.0},
    {"producto": "pera", "cantidad": 3, "precio": 2.0},
]


def enriquecer(ventas):
    # TODO: comprehension que añade "total": cantidad * precio sin mutar originales
    raise NotImplementedError


def filtrar_ventas(enriquecidas):
    # TODO: filter con lambda, total >= 10
    raise NotImplementedError


def agrupar_por_producto(filtradas):
    # TODO: dict {producto: suma de totales} con get(producto, 0)
    raise NotImplementedError


def ordenar_por_total(por_producto):
    # TODO: sorted por total descendente
    raise NotImplementedError


def resumir(ventas):
    # TODO: aplica el pipeline y devuelve las líneas de salida con TOTAL al final
    raise NotImplementedError


if __name__ == "__main__":
    for linea in resumir(VENTAS):
        print(linea)