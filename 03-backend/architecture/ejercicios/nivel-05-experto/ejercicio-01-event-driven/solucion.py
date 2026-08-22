from dataclasses import dataclass

# ===== EVENTO =====
@dataclass
class PedidoCreado:
    pedido_id: str
    total: float

# ===== BUS =====
class EventBus:
    def __init__(self):
        self._subs = {}
    def subscribe(self, evento_tipo, handler):
        self._subs.setdefault(evento_tipo, []).append(handler)
    def publish(self, evento):
        for h in self._subs.get(type(evento), []):
            h(evento)

# ===== PUBLICADOR (no conoce a los consumidores) =====
class PedidoService:
    def __init__(self, bus: EventBus):
        self.bus = bus
    def crear(self, pedido_id: str, total: float):
        # lógica de negocio...
        self.bus.publish(PedidoCreado(pedido_id, total))
        return pedido_id

# ===== CONSUMIDORES =====
class InventarioHandler:
    def __init__(self): self.reservas = []
    def handle(self, e: PedidoCreado):
        self.reservas.append(e.pedido_id)

class EnviosHandler:
    def __init__(self): self.envios = []
    def handle(self, e: PedidoCreado):
        self.envios.append(e.pedido_id)
