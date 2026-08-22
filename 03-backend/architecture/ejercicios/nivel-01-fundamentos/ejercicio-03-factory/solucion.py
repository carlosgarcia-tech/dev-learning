from abc import ABC, abstractmethod

class Notificacion(ABC):
    @abstractmethod
    def enviar(self, mensaje: str) -> str: ...

class EmailNotificacion(Notificacion):
    def enviar(self, mensaje): return f"[Email] {mensaje}"

class SMSNotificacion(Notificacion):
    def enviar(self, mensaje): return f"[SMS] {mensaje}"

class PushNotificacion(Notificacion):
    def enviar(self, mensaje): return f"[Push] {mensaje}"

class NotificacionFactory:
    _tipos = {
        "email": EmailNotificacion,
        "sms": SMSNotificacion,
        "push": PushNotificacion,
    }
    @staticmethod
    def crear(tipo: str) -> Notificacion:
        cls = NotificacionFactory._tipos.get(tipo)
        if cls is None:
            raise ValueError(f"Tipo desconocido: {tipo}")
        return cls()
