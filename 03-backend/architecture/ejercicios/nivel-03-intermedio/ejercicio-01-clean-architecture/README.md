# Ejercicio 01 — Clean Architecture (entities + use cases)

- **Nivel:** 3/5
- **Tema:** Clean Architecture — entidades y casos de uso aislados
- **Tiempo estimado:** 40 min

## Enunciado

Implementa un caso de uso de Clean Architecture **aislado del exterior**. El dominio (entities + use case) no debe importar nada de HTTP, BD ni framework. La capa exterior (adapter) se inyecta.

El archivo `solucion.py` debe contener:

- Una **entidad** `Pedido` con método `total()` (regla de negocio pura, sin dependencias externas).
- Un **puerto driven** `PedidoRepository` (abstracto) con `save`.
- Un **caso de uso** `CrearPedidoUseCase` que recibe el repo por constructor, valida invariantes y guarda.
- Un **controller** `PedidoController` (adaptador de interface) que traduce HTTP → use case.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py` respetando la Dependency Rule.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la entidad `Pedido` con `total()` (sin imports externos)
- [ ] `solucion.py` define el puerto `PedidoRepository` (abstracto) con `save`
- [ ] `solucion.py` define el caso de uso `CrearPedidoUseCase` que recibe el repo por constructor
- [ ] El use case valida que el total sea > 0 (invariante) antes de guardar
- [ ] `solucion.py` define `PedidoController` (adaptador) con `post(body)`
- [ ] El use case y la entidad NO importan HTTP ni BD
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Pedido(items)` donde items = `[{precio, cantidad}]`; `total = Σ precio*cantidad`.
- `CrearPedidoUseCase.__init__(self, repo)`; en `execute(items)`: crea Pedido, valida `total > 0`, `repo.save`, devuelve id.
- `PedidoController.__init__(self, use_case)`; `post(body)` llama al use case y traduce a `{status, body}`.
- La entidad y el use case no tienen `import` de nada externo (solo stdlib).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
