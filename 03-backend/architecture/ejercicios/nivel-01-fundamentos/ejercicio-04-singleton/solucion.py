class Config:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._valores = {}
        return cls._instance

    def set(self, clave, valor):
        self._valores[clave] = valor

    def get(self, clave, default=None):
        return self._valores.get(clave, default)
