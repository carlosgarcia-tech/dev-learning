# Ejercicio 01 — Event-driven architecture

- **Nivel:** 5/5
- **Tema:** Arquitectura event-driven (pub/sub entre servicios)
- **Tiempo estimado:** 50 min

## Enunciado

Implementa una **arquitectura event-driven** mínima: un servicio publica eventos a un bus y varios servicios reaccionan de forma independiente, sin conocerse entre sí.

El archivo `solucion.py` debe contener:

- Un `EventBus` con `publish(evento)` y `subscribe(evento_tipo, handler)`.
- Un `PedidoService` (publicador) que al crear un pedido publica `PedidoCreado`.
- Dos consumidores: `InventarioHandler` y `EnviosHandler` que reaccionan a `PedidoCreado`.
- El publicador **no conoce** a los consumidores (desacoplamiento).

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `EventBus` con `publish` y `subscribe`
- [ ] `solucion.py` define `PedidoService` que publica `PedidoCreado`
- [ ] `solucion.py` define `InventarioHandler` y `EnviosHandler` que reaccionan
- [ ] El publicador no referencia a los handlers (desacoplado)
- [ ] Al publicar, todos los suscritos a ese evento reaccionan
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `EventBus` guarda suscriptores en `dict[type(evento), list[handler]]`.
- `PedidoService` recibe el bus por constructor; en `crear(id)` publica `PedidoCreado(id)`.
- `InventarioHandler` y `EnviosHandler` guardan en listas lo que reciben.
- Suscribir: `bus.subscribe(PedidoCreado, inventario.handle)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
