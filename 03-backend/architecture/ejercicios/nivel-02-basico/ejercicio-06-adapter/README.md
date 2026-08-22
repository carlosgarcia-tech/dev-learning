# Ejercicio 06 — Implementar Adapter

- **Nivel:** 2/5
- **Tema:** Patrón Adapter (integrar una interfaz incompatible)
- **Tiempo estimado:** 30 min

## Enunciado

Tu app tiene una interfaz `Pago` con método `pagar(euros)`, pero integras una librería legacy `PagoLegacy` cuyo método es `haz_pago(centavos)`. Implementa un **Adapter** que permita usar `PagoLegacy` con la interfaz `Pago` que tu app espera.

El archivo `solucion.py` debe contener:

- Una interfaz abstracta `Pago` con método `pagar(euros)`.
- La clase legacy `PagoLegacy` con método `haz_pago(centavos)` (simulado, inmutable).
- Un `PagoAdapter` que implementa `Pago` y adapta: convierte euros→centavos y delega a `PagoLegacy`.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la interfaz `Pago` con método `pagar(euros)`
- [ ] `solucion.py` define `PagoLegacy` con método `haz_pago(centavos)` (no se modifica)
- [ ] `solucion.py` define `PagoAdapter` que implementa `Pago`
- [ ] `PagoAdapter.pagar(euros)` convierte a centavos y delega en `PagoLegacy.haz_pago`
- [ ] `PagoAdapter` recibe el legacy por constructor
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `PagoLegacy` no se toca (es de un tercero); solo la envuelves.
- `PagoAdapter.__init__(self, legacy)` guarda la instancia.
- `pagar(euros)`: `centavos = int(euros * 100)` y `self.legacy.haz_pago(centavos)`.
- El cliente usa `pago.pagar(9.99)` sin saber que detrás hay un legacy.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
from abc import ABC, abstractmethod

# Interfaz que la app espera
class Pago(ABC):
    @abstractmethod
    def pagar(self, euros: float) -> str: ...

# Clase legacy que NO puedes modificar (interfaz incompatible)
class PagoLegacy:
    def haz_pago(self, centavos: int) -> str:
        return f"Pagados {centavos} centavos"

# Adapter: implementa la interfaz esperada y delega al legacy
class PagoAdapter(Pago):
    def __init__(self, legacy: PagoLegacy):
        self.legacy = legacy
    def pagar(self, euros: float) -> str:
        centavos = int(round(euros * 100))
        return self.legacy.haz_pago(centavos)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
