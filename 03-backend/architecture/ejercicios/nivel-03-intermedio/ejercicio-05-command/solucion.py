from abc import ABC, abstractmethod

class Comando(ABC):
    @abstractmethod
    def ejecutar(self): ...
    @abstractmethod
    def deshacer(self): ...

class Luz:
    def __init__(self):
        self.encendida = False
    def encender(self):
        self.encendida = True
    def apagar(self):
        self.encendida = False

class EncenderLuz(Comando):
    def __init__(self, luz: Luz):
        self.luz = luz
    def ejecutar(self):
        self.luz.encender()
    def deshacer(self):
        self.luz.apagar()

class ApagarLuz(Comando):
    def __init__(self, luz: Luz):
        self.luz = luz
    def ejecutar(self):
        self.luz.apagar()
    def deshacer(self):
        self.luz.encender()

class ControlRemoto:
    def __init__(self):
        self.historial = []
    def pulsar(self, cmd: Comando):
        cmd.ejecutar()
        self.historial.append(cmd)
    def undo(self):
        if self.historial:
            self.historial.pop().deshacer()
