import time

class CircuitBreaker:
    def __init__(self, umbral=3, reset_seg=30):
        self.umbral = umbral
        self.reset_seg = reset_seg
        self.fallos = 0
        self.estado = "closed"
        self.ultimo_fallo = 0

    def call(self, fn, *args, **kwargs):
        if self.estado == "open":
            if time.time() - self.ultimo_fallo > self.reset_seg:
                self.estado = "half_open"
            else:
                raise RuntimeError("CircuitBreaker abierto")
        try:
            result = fn(*args, **kwargs)
            self.fallos = 0
            self.estado = "closed"
            return result
        except Exception as e:
            self.fallos += 1
            self.ultimo_fallo = time.time()
            if self.fallos >= self.umbral:
                self.estado = "open"
            raise
