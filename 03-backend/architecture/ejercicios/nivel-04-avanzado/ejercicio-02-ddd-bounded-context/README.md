# Ejercicio 02 — DDD bounded context

- **Nivel:** 4/5
- **Tema:** Domain-Driven Design (aggregate, value objects, events)
- **Tiempo estimado:** 45 min

## Enunciado

Implementa un **bounded context** de Pedidos con DDD: un aggregate root `Pedido` que garantiza invariantes, value objects (`Dinero`), y publica domain events (`PedidoCreado`).

El archivo `solucion.py` debe contener:

- Un **value object** `Dinero` (inmutable, con cantidad y moneda; valida cantidad ≥ 0).
- Un **aggregate root** `Pedido` con `id`, `items`, `estado`; métodos `add_item`, `confirmar`, `total`.
- El aggregate garantiza la **invariante**: "no se puede añadir items a un pedido confirmado".
- El aggregate publica **domain events** en una lista `eventos` al confirmar (`PedidoCreado`).

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define el value object `Dinero` (inmutable, valida cantidad ≥ 0)
- [ ] `solucion.py` define el aggregate root `Pedido` con `id`, `items`, `estado`
- [ ] `Pedido` tiene métodos `add_item`, `confirmar`, `total`
- [ ] No se puede añadir items a un pedido confirmado (invariante garantizada)
- [ ] Al confirmar, se añade un `PedidoCreado` a `pedido.eventos`
- [ ] `PedidoCreado` es una clase evento con campos `pedido_id` y `total`
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Dinero` con `@dataclass(frozen=True)` para inmutabilidad; en `__post_init__` valida `cantidad >= 0`.
- `Pedido.estado` empieza en `"borrador"`; `confirmar()` lo pasa a `"confirmado"`.
- `add_item` lanza `RuntimeError` si `self.estado == "confirmado"` (invariante).
- `total()` suma `Dinero` de los items.
- `confirmar()` hace `self.eventos.append(PedidoCreado(self.id, self.total()))`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
from dataclasses import dataclass, field
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
