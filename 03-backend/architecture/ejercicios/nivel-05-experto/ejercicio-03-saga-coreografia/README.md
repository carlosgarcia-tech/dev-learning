# Ejercicio 03 — Saga pattern (coreografía distribuida)

- **Nivel:** 5/5
- **Tema:** Saga por coreografía (eventos, sin orquestador central)
- **Tiempo estimado:** 50 min

## Enunciado

Implementa una **Saga por coreografía**: no hay orquestador. Cada servicio reacciona a eventos y publica los suyos, logrando el flujo completo de "crear pedido" con compensaciones automáticas.

Flujo de éxito:
1. `Pedidos` publica `PedidoCreado`.
2. `Inventario` escucha, reserva, publica `InventarioReservado`.
3. `Pagos` escucha, cobra, publica `PagoConfirmado`.

Flujo de fallo (pago falla):
1-2. Igual.
3. `Pagos` falla, publica `PagoFallido`.
4. `Inventario` escucha `PagoFallido`, libera stock.
5. `Pedidos` escucha `PagoFallido`, cancela pedido.

El archivo `solucion.py` debe contener un `EventBus`, los 3 servicios reactivos, y cada uno publica/escucha lo suyo sin conocer a los demás.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `EventBus` con `publish` y `subscribe`
- [ ] Define eventos: `PedidoCreado`, `InventarioReservado`, `PagoConfirmado`, `PagoFallido`
- [ ] `PedidosService` publica `PedidoCreado` y reacciona a `PagoFallido` cancelando
- [ ] `InventarioService` reacciona a `PedidoCreado` (reserva) y a `PagoFallido` (libera)
- [ ] `PagosService` reacciona a `InventarioReservado` y publica `PagoConfirmado` o `PagoFallido`
- [ ] Ningún servicio referencia directamente a otro (coreografía)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cada servicio guarda su estado (pedidos, reservas, cobros) en listas/dicts para verificación.
- `PagosService` recibe un flag `falla` para simular pago fallido.
- En el setup (fuera de los servicios), se cablean las suscripciones:
  - `bus.subscribe(PedidoCreado, inventario.on_pedido_creado)`
  - `bus.subscribe(InventarioReservado, pagos.on_inventario_reservado)`
  - `bus.subscribe(PagoFallido, inventario.on_pago_fallido)`
  - `bus.subscribe(PagoFallido, pedidos.on_pago_fallido)`
  - `bus.subscribe(PagoConfirmado, pedidos.on_pago_confirmado)` (opcional)

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
