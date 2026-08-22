class Container:
    def __init__(self):
        self._bindings = {}
        self._singletons = {}

    def register(self, interfaz, impl):
        self._bindings[interfaz] = impl

    def resolve(self, interfaz):
        if interfaz not in self._bindings:
            raise KeyError(f"No hay implementación registrada para {interfaz}")
        impl = self._bindings[interfaz]
        # Dependencias declaradas en la clase
        deps = getattr(impl, "deps", [])
        instancias = [self.resolve(d) for d in deps]
        return impl(*instancias)


# Ejemplo de uso
class UserRepository:
    deps = []   # sin dependencias
    def find(self, id): return {"id": id, "name": "Ana"}

class UserService:
    deps = [UserRepository]   # depende de UserRepository
    def __init__(self, repo):
        self.repo = repo
    def get_user(self, id):
        return self.repo.find(id)
