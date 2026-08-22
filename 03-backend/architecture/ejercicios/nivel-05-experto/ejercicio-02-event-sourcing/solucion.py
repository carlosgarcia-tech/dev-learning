from dataclasses import dataclass

# ===== EVENTOS =====
@dataclass
class CuentaCreada:
    id: str

@dataclass
class Depositado:
    cantidad: float

@dataclass
class Retirado:
    cantidad: float

# ===== EVENT STORE (append-only) =====
class EventStore:
    def __init__(self):
        self._streams = {}
    def append(self, id, evento):
        self._streams.setdefault(id, []).append(evento)
    def load(self, id):
        return self._streams.get(id, [])

# ===== AGGREGATE con event sourcing =====
class CuentaBancaria:
    def __init__(self):
        self.id = None
        self.saldo = 0.0
        self.cambios = []   # eventos nuevos (no persistidos)

    def crear(self, id):
        self._apply(CuentaCreada(id))
    def depositar(self, cantidad):
        if cantidad <= 0: raise ValueError("cantidad debe ser positiva")
        self._apply(Depositado(cantidad))
    def retirar(self, cantidad):
        if cantidad <= 0: raise ValueError("cantidad debe ser positiva")
        if cantidad > self.saldo: raise ValueError("saldo insuficiente")
        self._apply(Retirado(cantidad))

    def _apply(self, evento):
        self._reducir(evento)
        self.cambios.append(evento)

    def _reducir(self, evento):   # muta el estado según el evento
        if isinstance(evento, CuentaCreada):
            self.id = evento.id
        elif isinstance(evento, Depositado):
            self.saldo += evento.cantidad
        elif isinstance(evento, Retirado):
            self.saldo -= evento.cantidad

    @classmethod
    def from_history(cls, eventos):
        c = cls()
        for e in eventos:
            c._reducir(e)   # muta sin añadir a cambios
        return c
