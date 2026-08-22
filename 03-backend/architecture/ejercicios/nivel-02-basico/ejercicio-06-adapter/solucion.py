from abc import ABC, abstractmethod

# Interfaz que la app espera
class Pago(ABC):
    @abstractmethod
    def pagar(self, euros: float) -> str: ...

# Clase legacy que NO puedes modificar (interfaz incompatible)
class PagoLegacy:
    def haz_pago(self, centavos: int) -> str:
        return f"Pagados {centavos} centavos"

# Adapter: implementa la interfaz esperada y delega al legacy
class PagoAdapter(Pago):
    def __init__(self, legacy: PagoLegacy):
        self.legacy = legacy
    def pagar(self, euros: float) -> str:
        centavos = int(round(euros * 100))
        return self.legacy.haz_pago(centavos)
