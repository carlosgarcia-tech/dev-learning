from dataclasses import dataclass
from typing import List

# ===== VALUE OBJECT =====
@dataclass(frozen=True)
class Dinero:
    cantidad: float
    moneda: str = "EUR"
    def __post_init__(self):
        if self.cantidad < 0:
            raise ValueError("cantidad no puede ser negativa")
    def __add__(self, otro):
        if self.moneda != otro.moneda:
            raise ValueError("no se pueden sumar distintas monedas")
        return Dinero(self.cantidad + otro.cantidad, self.moneda)

# ===== DOMAIN EVENT =====
@dataclass
class PedidoCreado:
    pedido_id: str
    total: Dinero

# ===== AGGREGATE ROOT =====
@dataclass
class Item:
    nombre: str
    precio: Dinero

class Pedido:
    def __init__(self, id: str):
        self.id = id
        self.items: List[Item] = []
        self.estado = "borrador"
        self.eventos = []

    def add_item(self, item: Item):
        if self.estado == "confirmado":
            raise RuntimeError("no se puede modificar un pedido confirmado")
        self.items.append(item)

    def total(self) -> Dinero:
        if not self.items:
            return Dinero(0)
        t = self.items[0].precio
        for it in self.items[1:]:
            t = t + it.precio
        return t

    def confirmar(self):
        if not self.items:
            raise RuntimeError("no se puede confirmar un pedido vacío")
        self.estado = "confirmado"
        self.eventos.append(PedidoCreado(self.id, self.total()))
