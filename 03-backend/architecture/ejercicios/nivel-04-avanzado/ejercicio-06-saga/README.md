# Ejercicio 06 — Implementar Saga (orquestación)

- **Nivel:** 4/5
- **Tema:** Saga pattern — transacciones distribuidas con compensaciones
- **Tiempo estimado:** 45 min

## Enunciado

Implementa una **Saga orquestada** para crear un pedido que involucra 3 servicios: Pedidos, Inventario y Pagos. Si cualquier paso falla, el orquestador ejecuta las **compensaciones** en orden inverso.

El archivo `solucion.py` debe contener:

- Servicios simulados: `PedidosService`, `InventarioService`, `PagosService`, cada uno con `execute()` y `compensate()`.
- Una clase `CrearPedidoSaga` que orquesta los 3 pasos.
- Si todos van bien → devuelve los resultados.
- Si falla el paso N → ejecuta compensate de los pasos 0..N-1 en orden inverso.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `PedidosService`, `InventarioService`, `PagosService` con `execute` y `compensate`
- [ ] `solucion.py` define `CrearPedidoSaga` que orquesta los 3
- [ ] Si todos van bien, devuelve los resultados de los 3
- [ ] Si falla un paso, ejecuta compensate de los anteriores en orden inverso
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El orquestador guarda `hechos = []` con los servicios ejecutados.
- Por cada servicio: `execute()`; si OK, `hechos.append(servicio)`. Si lanza, `for s in reversed(hechos): s.compensate()` y re-raise.
- `PagosService` puede configurarse para fallar (para probar compensaciones).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
