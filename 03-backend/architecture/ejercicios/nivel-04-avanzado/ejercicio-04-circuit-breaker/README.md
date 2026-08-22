# Ejercicio 04 — Implementar Circuit Breaker

- **Nivel:** 4/5
- **Tema:** Patrón Circuit Breaker (resiliencia)
- **Tiempo estimado:** 40 min

## Enunciado

Implementa un **Circuit Breaker** que proteja llamadas a un servicio externo. Tras N fallos consecutivos, abre el circuito y falla rápido; tras un timeout, entra en half-open para probar; si la prueba va bien, cierra.

El archivo `solucion.py` debe contener:

- Una clase `CircuitBreaker` con estados `closed`, `open`, `half_open`.
- Parámetros `umbral` (fallos para abrir), `reset_seg` (segundos hasta half-open).
- Un método `call(fn)` que envuelve una función: la ejecuta en closed/half_open, y falla rápido en open.
- Tras `umbral` fallos → `open`. Tras `reset_seg` → `half_open` (deja pasar 1). Éxito → `closed`; fallo → `open`.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `CircuitBreaker` con estados closed/open/half_open
- [ ] Tiene parámetros `umbral` y `reset_seg`
- [ ] `call(fn)` ejecuta en closed/half_open y lanza excepción en open
- [ ] Tras `umbral` fallos consecutivos → open
- [ ] Tras `reset_seg` → half_open (deja pasar 1 petición)
- [ ] Éxito en half_open → closed; fallo → open
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Guarda `self.estado`, `self.fallos`, `self.ultimo_fallo` (timestamp).
- En `call`: si `open`, comprueba si `time.time() - ultimo_fallo > reset_seg` → pasa a `half_open`; si no, lanza.
- Si `closed` o `half_open`: intenta `fn()`. Éxito → resetea fallos, estado `closed`. Fallo → incrementa fallos, si ≥ umbral → `open`, registra `ultimo_fallo`.
- Para tests puedes usar `reset_seg` muy pequeño (ej. 0.1) y `time.sleep`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
