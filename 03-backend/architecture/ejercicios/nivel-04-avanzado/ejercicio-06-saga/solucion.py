class PedidosService:
    def execute(self): return "pedido_creado"
    def compensate(self): return "pedido_cancelado"

class InventarioService:
    def execute(self): return "stock_reservado"
    def compensate(self): return "stock_liberado"

class PagosService:
    def __init__(self, falla=False):
        self.falla = falla
    def execute(self):
        if self.falla: raise RuntimeError("pago fallido")
        return "pago_cobrado"
    def compensate(self): return "pago_reembolsado"

class CrearPedidoSaga:
    def __init__(self, pedidos, inventario, pagos):
        self.pedidos = pedidos
        self.inventario = inventario
        self.pagos = pagos
    def execute(self):
        pasos = [self.pedidos, self.inventario, self.pagos]
        hechos = []
        resultados = []
        try:
            for s in pasos:
                resultados.append(s.execute())
                hechos.append(s)
            return resultados
        except Exception as e:
            # compensar en orden inverso
            for s in reversed(hechos):
                s.compensate()
            raise
