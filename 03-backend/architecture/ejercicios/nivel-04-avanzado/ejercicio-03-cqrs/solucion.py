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
