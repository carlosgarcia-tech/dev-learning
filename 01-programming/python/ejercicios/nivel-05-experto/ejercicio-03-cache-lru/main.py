# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

from collections import OrderedDict


class CacheLRU:
    def __init__(self, capacidad):
        # TODO: guarda capacidad y crea self.datos = OrderedDict()
        raise NotImplementedError

    def get(self, clave):
        # TODO: devuelve el valor o None; si existe, move_to_end(clave)
        raise NotImplementedError

    def put(self, clave, valor):
        # TODO: inserta o actualiza; si ya existe, move_to_end;
        # si supera la capacidad, popitem(last=False)
        raise NotImplementedError

    def __len__(self):
        # TODO: devuelve el tamaño actual
        raise NotImplementedError


if __name__ == "__main__":
    cache = CacheLRU(2)
    cache.put("a", 1)
    cache.put("b", 2)
    cache.get("a")            # "a" pasa a ser la más reciente
    cache.put("c", 3)         # expulsa "b" (la menos reciente)

    print(f"get(a) = {cache.get('a')}")
    print(f"get(b) = {cache.get('b')}")
    print(f"Tamaño actual: {len(cache)}")
    print(f"Contenido: {cache.datos}")