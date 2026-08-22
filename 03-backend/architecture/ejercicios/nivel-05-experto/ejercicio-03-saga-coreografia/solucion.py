from dataclasses import dataclass

# ===== EVENTOS =====
@dataclass
class PedidoCreado:
    pedido_id: str
@dataclass
class InventarioReservado:
    pedido_id: str
@dataclass
class PagoConfirmado:
    pedido_id: str
@dataclass
class PagoFallido:
    pedido_id: str

# ===== BUS =====
class EventBus:
    def __init__(self):
        self._subs = {}
    def subscribe(self, tipo, handler):
        self._subs.setdefault(tipo, []).append(handler)
    def publish(self, evento):
        for h in self._subs.get(type(evento), []):
            h(evento)

# ===== SERVICIOS (cada uno reacciona y publica, sin conocer a los demás) =====
class PedidosService:
    def __init__(self, bus):
        self.bus = bus
        self.pedidos = {}      # id -> estado
        self.cancelados = []
    def crear(self, pedido_id):
        self.pedidos[pedido_id] = "pendiente"
        self.bus.publish(PedidoCreado(pedido_id))
    def on_pago_confirmado(self, e):
        self.pedidos[e.pedido_id] = "pagado"
    def on_pago_fallido(self, e):
        self.pedidos[e.pedido_id] = "cancelado"
        self.cancelados.append(e.pedido_id)

class InventarioService:
    def __init__(self, bus):
        self.bus = bus
        self.reservados = []
        self.liberados = []
    def on_pedido_creado(self, e):
        self.reservados.append(e.pedido_id)
        self.bus.publish(InventarioReservado(e.pedido_id))
    def on_pago_fallido(self, e):
        self.liberados.append(e.pedido_id)

class PagosService:
    def __init__(self, bus, falla=False):
        self.bus = bus
        self.falla = falla
        self.cobros = []
    def on_inventario_reservado(self, e):
        if self.falla:
            self.bus.publish(PagoFallido(e.pedido_id))
        else:
            self.cobros.append(e.pedido_id)
            self.bus.publish(PagoConfirmado(e.pedido_id))
