# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


class Animal:
    def __init__(self, nombre):
        # TODO: guarda el nombre del animal
        raise NotImplementedError

    def hablar(self):
        # TODO: devuelve "..."
        raise NotImplementedError

    @property
    def descripcion(self):
        # TODO: devuelve f"{self.nombre} es un animal"
        raise NotImplementedError


class Perro(Animal):
    def __init__(self, nombre):
        # TODO: usa super().__init__(nombre)
        raise NotImplementedError

    def hablar(self):
        # TODO: devuelve "Guau"
        raise NotImplementedError

    def correr(self):
        # TODO: devuelve f"{self.nombre} corre rápido"
        raise NotImplementedError

    @property
    def nombre(self):
        # TODO: devuelve self._nombre
        raise NotImplementedError

    @nombre.setter
    def nombre(self, valor):
        # TODO: si valor está vacío lanza ValueError("el nombre no puede estar vacío"),
        # si no guarda self._nombre = valor
        raise NotImplementedError


class Gato(Animal):
    def __init__(self, nombre):
        # TODO: usa super().__init__(nombre)
        raise NotImplementedError

    def hablar(self):
        # TODO: devuelve "Miau"
        raise NotImplementedError


if __name__ == "__main__":
    rex = Perro("Rex")
    mishi = Gato("Mishi")

    print(rex.hablar())
    print(mishi.hablar())
    print(rex.correr())
    print(rex.descripcion)
    print(mishi.descripcion)

    try:
        rex.nombre = ""
    except ValueError as e:
        print(f"Error: {e}")