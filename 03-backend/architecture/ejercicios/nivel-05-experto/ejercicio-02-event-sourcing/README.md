# Ejercicio 02 — Event Sourcing

- **Nivel:** 5/5
- **Tema:** Event Sourcing — estado reconstruido desde eventos
- **Tiempo estimado:** 50 min

## Enunciado

Implementa un **aggregate con Event Sourcing**: en vez de guardar el estado, guardas la secuencia de eventos y reconstruyes el estado aplicándolos.

El archivo `solucion.py` debe contener:

- Un `EventStore` que guarda eventos (append-only) por aggregate id.
- Eventos: `CuentaCreada`, `Depositado`, `Retirado`.
- Un aggregate `CuentaBancaria` que:
  - Tiene métodos comando (`crear`, `depositar`, `retirar`) que **generan** eventos.
  - Tiene un **reductor** que aplica un evento al estado (`_apply`).
  - Se puede **reconstruir** desde el EventStore con `from_history`.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `EventStore` con `append(id, evento)` y `load(id)`
- [ ] `solucion.py` define los eventos `CuentaCreada`, `Depositado`, `Retirado`
- [ ] `solucion.py` define `CuentaBancaria` con métodos comando (crear, depositar, retirar)
- [ ] Los comandos generan eventos en `cuenta.cambios`
- [ ] `CuentaBancaria.from_history(eventos)` reconstruye el estado aplicando eventos
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Eventos como dataclasses: `CuentaCreada`, `Depositado(cantidad)`, `Retirado(cantidad)`.
- `CuentaBancaria` tiene `self.saldo = 0`, `self.cambios = []`.
- `_apply(evento)` muta el estado según el tipo (usar `isinstance`).
- Comando `depositar(cantidad)`: valida > 0, llama `self._apply(Depositado(cantidad))`.
- `_apply` muta el estado Y añade a `self.cambios`.
- `from_history`: crea la cuenta y para cada evento llama a un método `_reducir` (que muta sin añadir a cambios).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
