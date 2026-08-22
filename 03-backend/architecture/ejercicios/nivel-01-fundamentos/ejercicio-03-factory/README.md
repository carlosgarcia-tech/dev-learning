# Ejercicio 03 — Implementar Factory

- **Nivel:** 1/5
- **Tema:** Patrón Factory Method
- **Tiempo estimado:** 25 min

## Enunciado

Tu app necesita crear notificaciones de distintos tipos (email, SMS, push) sin que el código cliente conozca las clases concretas. Implementa el patrón **Factory Method**: una clase `NotificacionFactory` con un método `crear(tipo)` que devuelve una instancia de la subclase correcta, todas implementando la interfaz común `Notificacion`.

El archivo `solucion.py` debe contener:

- Una clase abstracta `Notificacion` con método `enviar(mensaje)`.
- Tres implementaciones: `EmailNotificacion`, `SMSNotificacion`, `PushNotificacion`.
- Una clase `NotificacionFactory` con método estático `crear(tipo)` que devuelve la instancia correcta.
- El factory debe lanzar `ValueError` para tipos desconocidos.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la clase base abstracta `Notificacion` con método `enviar`
- [ ] `solucion.py` define `EmailNotificacion`, `SMSNotificacion`, `PushNotificacion`
- [ ] `solucion.py` define `NotificacionFactory` con método `crear(tipo)`
- [ ] El factory lanza `ValueError` para un tipo no soportado
- [ ] Cada subclase imprime/retorna un mensaje distinto (email/sms/push)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `abc.ABC` y `@abstractmethod` para la clase base `Notificacion`.
- El factory puede ser un método estático (`@staticmethod`) o de clase.
- Usa un mapeo `{"email": EmailNotificacion, "sms": SMSNotificacion, ...}` para evitar cascadas de `if`.
- `ValueError(f"Tipo desconocido: {tipo}")` para tipos no soportados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
