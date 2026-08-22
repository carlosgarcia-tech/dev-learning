# Ejercicio 04 — Implementar Singleton

- **Nivel:** 1/5
- **Tema:** Patrón Singleton
- **Tiempo estimado:** 20 min

## Enunciado

Necesitas una clase `Config` que tenga **una única instancia** en toda la app, cargue valores de configuración y sea accesible globalmente. Implementa el patrón **Singleton** garantizando que `Config()` devuelve siempre la misma instancia y que los valores cargados persisten.

El archivo `solucion.py` debe contener:

- Una clase `Config` que garantice una sola instancia (override de `__new__`).
- Un método `set(clave, valor)` y `get(clave)` para almacenar y leer valores.
- Comprobación de identidad: `Config() is Config()` debe ser `True`.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la clase `Config`
- [ ] `Config` garantiza una sola instancia (override de `__new__`)
- [ ] `Config` tiene método `set(clave, valor)` y `get(clave)`
- [ ] `Config() is Config()` devuelve `True`
- [ ] Un valor set en una instancia es visible en otra
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Override `__new__` para controlar la creación; guarda la instancia en un atributo de clase `_instance`.
- Inicializa los datos solo la primera vez (cuando `_instance is None`).
- `get` puede devolver un default si la clave no existe: `self._valores.get(clave, default)`.
- El test crea `Config()` dos veces y verifica identidad con `is`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
class Config:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._valores = {}
        return cls._instance

    def set(self, clave, valor):
        self._valores[clave] = valor

    def get(self, clave, default=None):
        return self._valores.get(clave, default)
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
