# Ejercicio 06 — Diseño de sistema completo (observabilidad distribuida)

- **Nivel:** 5/5
- **Tema:** Observabilidad distribuida (logs + métricas + tracing)
- **Tiempo estimado:** 50 min

## Enunciado

Implementa un **sistema de observabilidad mínimo** para un flujo distribuido: una petición cruza varios servicios y cada uno añade spans a un **trace** con un `trace_id` común. Se registran logs estructurados y métricas.

El archivo `solucion.py` debe contener:

- Un `Tracer` que crea spans con `trace_id` y `span_id`, y los cierra.
- Un `Logger` estructurado que emite logs JSON con `trace_id`, `level`, `msg`.
- Un `Metrics` que cuenta eventos (counter) y mide latencia (histograma).
- Un `ServicioDistribuido` que, al recibir una petición, abre un span, loguea, mide latencia y llama al siguiente servicio propagando el `trace_id`.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `Tracer` con `start_span(nombre)` que devuelve un span con `trace_id` y `span_id`
- [ ] `solucion.py` define `Logger` que emite logs estructurados (dict/JSON) con `trace_id`
- [ ] `solucion.py` define `Metrics` con `inc(counter)` y `observe(histogram, valor)`
- [ ] `solucion.py` define `ServicioDistribuido` que abre span, loguea, mide latencia, propaga `trace_id`
- [ ] El `trace_id` se propaga entre servicios
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Tracer.start_span(nombre, trace_id=None)`: si no hay trace_id, genera uno nuevo; span_id único.
- `Logger.log(level, msg, trace_id)` guarda en una lista dicts `{"trace_id", "level", "msg", "ts"}`.
- `Metrics`: counters en dict (solo suben), histograms en dict de listas.
- `ServicioDistribuido.handle(trace_id=None)`: `span = tracer.start_span(nombre, trace_id)`, logger.log, `t0=time.time()`, llama al siguiente con el trace_id, `metrics.observe("latencia", time.time()-t0)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
import time, uuid
from typing import Dict, List, Optional

class Tracer:
    def __init__(self):
        self.spans = []
    def start_span(self, nombre: str, trace_id: Optional[str] = None) -> dict:
        if trace_id is None:
            trace_id = uuid.uuid4().hex[:8]
        span = {"trace_id": trace_id, "span_id": uuid.uuid4().hex[:8], "nombre": nombre}
        self.spans.append(span)
        return span

class Logger:
    def __init__(self):
        self.logs: List[dict] = []
    def log(self, level: str, msg: str, trace_id: str, **extra):
        entry = {"ts": time.time(), "level": level, "msg": msg, "trace_id": trace_id, **extra}
        self.logs.append(entry)

class Metrics:
    def __init__(self):
        self._counters: Dict[str, int] = {}
        self._histograms: Dict[str, List[float]] = {}
    def inc(self, counter: str):
        self._counters[counter] = self._counters.get(counter, 0) + 1
    def observe(self, histogram: str, valor: float):
        self._histograms.setdefault(histogram, []).append(valor)
    def counter(self, name: str) -> int:
        return self._counters.get(name, 0)

class ServicioDistribuido:
    def __init__(self, nombre, tracer, logger, metrics, siguiente=None):
        self.nombre = nombre
        self.tracer = tracer
        self.logger = logger
        self.metrics = metrics
        self.siguiente = siguiente
    def handle(self, trace_id=None) -> str:
        span = self.tracer.start_span(self.nombre, trace_id)
        self.logger.log("info", f"{self.nombre} procesando", span["trace_id"])
        self.metrics.inc(f"{self.nombre}_requests")
        t0 = time.time()
        if self.siguiente:
            self.siguiente.handle(span["trace_id"])   # propaga trace_id
        self.metrics.observe(f"{self.nombre}_latencia", time.time() - t0)
        return span["trace_id"]
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
