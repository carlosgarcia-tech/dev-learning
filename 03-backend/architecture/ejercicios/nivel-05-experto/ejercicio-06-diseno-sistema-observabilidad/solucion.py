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
