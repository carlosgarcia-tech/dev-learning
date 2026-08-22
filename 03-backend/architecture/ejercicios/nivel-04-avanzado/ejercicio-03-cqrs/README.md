# Ejercicio 03 — Implementar CQRS

- **Nivel:** 4/5
- **Tema:** CQRS — separación de comandos (write) y consultas (read)
- **Tiempo estimado:** 40 min

## Enunciado

Implementa un **CQRS básico** que separe escritura de lectura. Los comandos mutan el modelo de escritura y publican eventos; las consultas leen de una vista de lectura (denormalizada) actualizada por los eventos.

El archivo `solucion.py` debe contener:

- Un **command handler** `CrearUsuarioHandler` que guarda en el write model y publica `UsuarioCreado`.
- Un **query handler** `ObtenerUsuarioHandler` que lee del read model (vista denormalizada).
- Un **projector** que escucha `UsuarioCreado` y actualiza el read model.
- El read model y el write model son **estructuras distintas** (el read model es una vista optimizada).

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `CrearUsuarioHandler` con método `handle(command)`
- [ ] `solucion.py` define `ObtenerUsuarioHandler` con método `handle(query)`
- [ ] El command handler guarda en un write model y publica `UsuarioCreado`
- [ ] El projector actualiza el read model al recibir `UsuarioCreado`
- [ ] El query handler lee del read model (vista denormalizada, distinta del write)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Write model: lista de `{id, email, creado_en}` (normalizado).
- Read model: dict `id → {id, email, email_domain}` (denormalizado, con campo extra para búsquedas).
- `CrearUsuarioHandler` recibe el write model y el bus de eventos; al crear publica `UsuarioCreado(id, email)`.
- El projector escucha `UsuarioCreado` y hace `read_model[id] = {id, email, email_domain: email.split('@')[1]}`.
- El query handler lee `read_model[id]`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
from dataclasses import dataclass
from typing import Dict, List

@dataclass
class UsuarioCreado:
    id: str
    email: str

# ===== WRITE MODEL =====
class CrearUsuarioHandler:
    def __init__(self, write_model: List[dict], bus):
        self.write_model = write_model
        self.bus = bus
    def handle(self, command: dict):
        user = {"id": command["id"], "email": command["email"], "creado_en": "2026-01-01"}
        self.write_model.append(user)
        self.bus.publish(UsuarioCreado(user["id"], user["email"]))
        return user

# ===== PROJECTOR (read model sync) =====
class UsuarioProjector:
    def __init__(self, read_model: Dict[str, dict]):
        self.read_model = read_model
    def on_usuario_creado(self, evento: UsuarioCreado):
        domain = evento.email.split("@")[1] if "@" in evento.email else ""
        self.read_model[evento.id] = {
            "id": evento.id,
            "email": evento.email,
            "email_domain": domain,   # denormalizado para búsquedas
        }

# ===== READ MODEL (query) =====
class ObtenerUsuarioHandler:
    def __init__(self, read_model: Dict[str, dict]):
        self.read_model = read_model
    def handle(self, query: dict):
        return self.read_model.get(query["id"])

# ===== BUS mínimo =====
class Bus:
    def __init__(self):
        self._subs = {}
    def subscribe(self, evento_tipo, handler):
        self._subs.setdefault(evento_tipo, []).append(handler)
    def publish(self, evento):
        for h in self._subs.get(type(evento), []):
            h(evento)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
