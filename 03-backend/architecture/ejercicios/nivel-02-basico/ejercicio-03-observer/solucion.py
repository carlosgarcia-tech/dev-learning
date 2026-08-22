from abc import ABC, abstractmethod

class Observador(ABC):
    @abstractmethod
    def actualizar(self, evento, datos): ...

class LoggerObservador(Observador):
    def __init__(self):
        self.logs = []
    def actualizar(self, evento, datos):
        self.logs.append((evento, datos))

class ContadorObservador(Observador):
    def __init__(self):
        self.count = 0
    def actualizar(self, evento, datos):
        self.count += 1

class EventoBus:
    def __init__(self):
        self._observers = []
    def suscribir(self, obs):
        self._observers.append(obs)
    def desuscribir(self, obs):
        self._observers = [o for o in self._observers if o is not obs]
    def publicar(self, evento, datos=None):
        for o in self._observers:
            o.actualizar(evento, datos)
