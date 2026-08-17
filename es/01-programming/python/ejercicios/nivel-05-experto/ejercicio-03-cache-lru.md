# Ejercicio 03 — Caché LRU

- **Nivel:** 5/5
- **Tema:** OrderedDict, LRU, move_to_end, popitem
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `cache_lru.py` que implemente una caché LRU (Least Recently Used) con `collections.OrderedDict`:

1. Clase `CacheLRU` con `__init__(self, capacidad)`.
2. Método `get(clave)` → devuelve el valor o `None` si no existe. Si existe, la marca como usada recientemente con `move_to_end`.
3. Método `put(clave, valor)` → inserta o actualiza; si la clave ya existe la mueve al final; si supera la capacidad, elimina la menos usada con `popitem(last=False)`.
4. Método `__len__` para devolver el tamaño actual.
5. En `__main__`, demuestra el comportamiento: crea una caché de capacidad 2, pon `a=1`, `b=2`, accede a `a` (lo hace reciente), pon `c=3` (expulsa a `b`), y verifica que `get("b")` devuelve `None` y `get("a")` devuelve `1`.

Salida esperada:

```
get(a) = 1
get(b) = None
Tamaño actual: 2
Contenido: OrderedDict({'c': 3, 'a': 1})
```

## Requisitos

- [ ] Usar `collections.OrderedDict`.
- [ ] Implementar `get`, `put`, `__len__`.
- [ ] Usar `move_to_end` y `popitem(last=False)`.
- [ ] Ejecutar la demostración y verificar que el elemento menos reciente se expulsa.
- [ ] Ejecutarlo localmente con `python3 cache_lru.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `move_to_end(clave)` marca un elemento como el más reciente.
- `popitem(last=False)` elimina y devuelve el primero (el menos reciente).
- `get` debe devolver el valor y moverlo al final; `None` si la clave no está.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
from collections import OrderedDict


class CacheLRU:
    def __init__(self, capacidad):
        self.capacidad = capacidad
        self.datos = OrderedDict()

    def get(self, clave):
        if clave not in self.datos:
            return None
        self.datos.move_to_end(clave)
        return self.datos[clave]

    def put(self, clave, valor):
        if clave in self.datos:
            self.datos[clave] = valor
            self.datos.move_to_end(clave)
            return
        self.datos[clave] = valor
        if len(self.datos) > self.capacidad:
            self.datos.popitem(last=False)

    def __len__(self):
        return len(self.datos)


cache = CacheLRU(2)
cache.put("a", 1)
cache.put("b", 2)
cache.get("a")            # "a" pasa a ser la más reciente
cache.put("c", 3)         # expulsa "b" (la menos reciente)

print(f"get(a) = {cache.get('a')}")
print(f"get(b) = {cache.get('b')}")
print(f"Tamaño actual: {len(cache)}")
print(f"Contenido: {cache.datos}")
````

</details>