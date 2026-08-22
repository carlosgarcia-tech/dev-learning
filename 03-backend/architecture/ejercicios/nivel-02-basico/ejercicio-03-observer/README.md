# Ejercicio 03 — Implementar Observer

- **Nivel:** 2/5
- **Tema:** Patrón Observer (pub/sub)
- **Tiempo estimado:** 30 min

## Enunciado

Implementa un sistema de eventos con el patrón **Observer**: un `EventoBus` (sujeto) al que se suscriben observadores y, al publicar un evento, todos los suscriptores son notificados.

El archivo `solucion.py` debe contener:

- Una clase `EventoBus` con métodos `suscribir(observador)`, `publicar(evento, datos)` y `desuscribir(observador)`.
- Observadores implementan una interfaz `Observador` con método `actualizar(evento, datos)`.
- Dos observadores concretos: `LoggerObservador` (guarda en lista) y `ContadorObservador` (cuenta eventos).
- Al publicar, todos los suscritos reciben `actualizar`.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la interfaz `Observador` con método `actualizar(evento, datos)`
- [ ] `solucion.py` define `LoggerObservador` y `ContadorObservador`
- [ ] `solucion.py` define `EventoBus` con `suscribir`, `publicar`, `desuscribir`
- [ ] Al publicar, todos los suscritos reciben `actualizar`
- [ ] Tras desuscribir, un observador ya no recibe eventos
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `EventoBus` mantiene `self._observers = []`.
- `suscribir` añade; `desuscribir` quita; `publicar` itera y llama `o.actualizar(evento, datos)`.
- `LoggerObservador` guarda `(evento, datos)` en una lista `self.logs`.
- `ContadorObservador` incrementa `self.count` en cada `actualizar`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
