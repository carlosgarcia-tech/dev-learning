# Ejercicio 05 — Implementar Command

- **Nivel:** 3/5
- **Tema:** Patrón Command (acciones como objetos, con undo)
- **Tiempo estimado:** 35 min

## Enunciado

Implementa un control remoto con patrón **Command**: cada acción (encender/apagar luz) es un objeto con `ejecutar()` y `deshacer()`. Un `ControlRemoto` mantiene historial y permite deshacer la última acción.

El archivo `solucion.py` debe contener:

- Una interfaz `Comando` con `ejecutar()` y `deshacer()`.
- Un receptor `Luz` con `encender()` y `apagar()`.
- Comandos concretos `EncenderLuz` y `ApagarLuz`.
- Un `ControlRemoto` con `pulsar(comando)` y `undo()`.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la interfaz `Comando` con `ejecutar` y `deshacer`
- [ ] `solucion.py` define el receptor `Luz` con `encender` y `apagar`
- [ ] `solucion.py` define `EncenderLuz` y `ApagarLuz` (implementan Comando)
- [ ] `solucion.py` define `ControlRemoto` con `pulsar(comando)` y `undo()`
- [ ] `undo()` deshace la última acción ejecutada
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Luz` guarda `self.encendida = False`; `encender()` la pone True y `apagar()` False.
- `EncenderLuz.__init__(self, luz)`; `ejecutar()` llama `luz.encender()`; `deshacer()` llama `luz.apagar()`.
- `ControlRemoto.pulsar(cmd)`: `cmd.ejecutar()` y `self.historial.append(cmd)`.
- `undo()`: si hay historial, `self.historial.pop().deshacer()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
