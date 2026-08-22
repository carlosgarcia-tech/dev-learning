from abc import ABC, abstractmethod

# ===== ENTITIES (lo más interno, puro dominio) =====
class Pedido:
    def __init__(self, pedido_id, items):
        self.id = pedido_id
        self.items = items  # [{precio, cantidad}]
    def total(self):
        return sum(i["precio"] * i["cantidad"] for i in self.items)

# ===== USE CASES =====
class PedidoRepository(ABC):  # puerto driven (interfaz)
    @abstractmethod
    def save(self, pedido): ...

class CrearPedidoUseCase:
    def __init__(self, repo: PedidoRepository):
        self.repo = repo
    def execute(self, items):
        pedido = Pedido("p-" + str(id(items)), items)
        if pedido.total() <= 0:
            raise ValueError("pedido vacío o total inválido")
        self.repo.save(pedido)
        return pedido.id

# ===== INTERFACE ADAPTERS =====
class PedidoController:
    def __init__(self, use_case: CrearPedidoUseCase):
        self.uc = use_case
    def post(self, body):
        try:
            pid = self.uc.execute(body["items"])
            return {"status": 201, "body": {"id": pid}}
        except (ValueError, KeyError) as e:
            return {"status": 400, "body": {"error": str(e)}}

# ===== FRAMEWORKS & DRIVERS (implementación del puerto, inyectable) =====
class InMemoryPedidoRepository(PedidoRepository):
    def __init__(self):
        self.db = []
    def save(self, pedido):
        self.db.append(pedido)
