# 03 — Estructuras de datos en Python

## Objetivos

- [ ] Usar listas con sus métodos principales y slicing.
- [ ] Trabajar con tuplas como secuencias inmutables.
- [ ] Manejar diccionarios: acceso, inserción, métodos y `get()`.
- [ ] Usar conjuntos (`set`) para membresía y operaciones de teoría de conjuntos.
- [ ] Escribir list/dict/set comprehensions.
- [ ] Entender cuándo elegir cada estructura.

## Apuntes

### Listas

Las **listas** son secuencias **mutables** y ordenadas. Pueden contener cualquier tipo, incluso mezclado.

```python
frutas = ["manzana", "pera", "uva"]
frutas.append("kiwi")        # añade al final
frutas.insert(0, "limón")    # inserta en el índice 0
frutas.remove("pera")        # elimina por valor
ultima = frutas.pop()        # elimina y devuelve el último
frutas.sort()                # ordena en el lugar
print(frutas)
```

Acceso e índices:

```python
nums = [10, 20, 30, 40, 50]
print(nums[0])     # 10
print(nums[-1])    # 50 (último)
print(nums[1:3])   # [20, 30] (slicing: fin excluido)
print(nums[::-1])  # [50, 40, 30, 20, 10] (invertida)
```

Métodos útiles: `len()`, `in`, `min()`, `max()`, `sum()`, `.index()`, `.count()`, `.extend()`.

### Tuplas

Las **tuplas** son secuencias **inmutables** y ordenadas, definidas con paréntesis. Son ideales para datos que no deben cambiar y como claves de diccionarios.

```python
punto = (3, 4)
x, y = punto              # desempaquetado
print(x, y)               # 3 4
# punto[0] = 9           # TypeError: inmutable
coordenadas = [(1, 2), (3, 4)]   # lista de tuplas
```

### Diccionarios

Los **diccionarios** asocian claves únicas a valores. Desde Python 3.7 conservan el orden de inserción.

```python
usuario = {"nombre": "Ana", "edad": 30, "activo": True}
print(usuario["nombre"])      # Ana
usuario["ciudad"] = "Lima"    # añade clave
usuario["edad"] = 31          # actualiza
del usuario["activo"]         # elimina clave

print(usuario.get("altura", 1.70))   # valor por defecto si no existe
for clave, valor in usuario.items():
    print(f"{clave}: {valor}")
```

Métodos: `.keys()`, `.values()`, `.items()`, `.pop(clave, default)`, `.setdefault()`, `.update()`.

### Conjuntos (set)

Los **sets** son colecciones **sin orden** y **sin duplicados**. Se usan para comprobar pertenencia y operaciones de conjunto.

```python
a = {1, 2, 3}
b = {3, 4, 5}
print(a | b)   # unión: {1, 2, 3, 4, 5}
print(a & b)   # intersección: {3}
print(a - b)   # diferencia: {1, 2}
print(3 in a)  # True
a.add(6)
a.discard(1)   # elimina sin error si no existe
```

### Comprehensions

Las comprehensions construyen colecciones en una sola línea con sintaxis `[expresión for elemento in iterable if condición]`.

```python
cuadrados = [n ** 2 for n in range(6)]        # [0, 1, 4, 9, 16, 25]
pares = [n for n in range(10) if n % 2 == 0]  # [0, 2, 4, 6, 8]

nombres = ["ana", "pablo", "luis"]
mayusculas = [n.capitalize() for n in nombres]

cuadrados_dict = {n: n ** 2 for n in range(4)}  # {0: 0, 1: 1, 2: 4, 3: 9}
unicos = {len(p) for p in nombres}              # {3, 4, 5}
```

### Elegir la estructura correcta

- **Lista** — colección ordenada y mutable con acceso por índice.
- **Tupla** — datos fijos, hashables, o para desempaquetar.
- **Diccionario** — mapear claves a valores y búsquedas rápidas.
- **Set** — eliminar duplicados y comprobar pertenencia.

## Ejemplos de código

```python
# Contador de palabras con diccionario
texto = "la casa es grande y la casa es azul"
contador = {}
for palabra in texto.split():
    contador[palabra] = contador.get(palabra, 0) + 1
print(contador)   # {'la': 2, 'casa': 2, 'es': 2, 'grande': 1, 'y': 1, 'azul': 1}
```

```python
# List comprehension con filtro
edades = [12, 18, 25, 16, 30, 17]
mayores = [e for e in edades if e >= 18]
print(mayores)   # [18, 25, 30]
```

```python
# Deduplicar y ordenar con set
numeros = [3, 1, 2, 3, 4, 1, 5]
unicos = sorted(set(numeros))
print(unicos)   # [1, 2, 3, 4, 5]
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)
- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **`KeyError`** → acceder a una clave inexistente. Usa `.get()` o comprueba con `in`.
- **`IndexError`** → índice fuera de rango en listas/tuplas.
- **`TypeError: unhashable type: 'list'`** → usar una lista como clave de diccionario o elemento de set. Usa tuplas.
- **Modificar una lista mientras se itera** → resultados inesperados. Itera sobre una copia (`lista[:]`).
- **Pensar que un set conserva el orden** → no lo hace; si necesitas orden, usa `sorted()`.
- **Confundir tupla con paréntesis de agrupación** → `(3)` es un `int`; `(3,)` es una tupla de un elemento.
- **Copiar listas con `=`** → comparte la misma lista. Usa `lista.copy()` o `lista[:]` para una copia real.

## Recursos

- [Python.org — Estructuras de datos](https://docs.python.org/es/3/tutorial/datastructures.html)
- [Python.org — List comprehensions](https://docs.python.org/es/3/tutorial/datastructures.html#list-comprehensions)
- [Real Python — Python Data Structures](https://realpython.com/python-data-structures/)
- [PEP 3100 — Introducción de sets](https://docs.python.org/es/3/tutorial/datastructures.html#sets)