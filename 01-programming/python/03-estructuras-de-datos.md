# 03 — Estructuras de datos en Python

## Objetivos

- [ ] Crear listas y manipularlas con sus métodos principales (`append`, `extend`, `insert`, `remove`, `pop`, `sort`, `reverse`, `copy`).
- [ ] Indexar y hacer slicing de secuencias con pasos positivos y negativos.
- [ ] Escribir list comprehensions: básicas, con condición, anidadas y combinadas con `zip`/`enumerate`.
- [ ] Trabajar con tuplas: creación, empaquetado/desempaquetado, métodos y cuándo usarlas.
- [ ] Manejar conjuntos (`set`) y `frozenset`: métodos, operadores (`|`, `&`, `-`, `^`) y comprobación de pertenencia.
- [ ] Usar diccionarios: acceso con `[]` vs `get()`, inserción, actualización, eliminación, iteración y dict comprehensions.
- [ ] Elegir la estructura adecuada según mutabilidad, orden, duplicados y complejidad.
- [ ] Conocer estructuras adicionales de `collections`: `deque`, `Counter`, `defaultdict`, `namedtuple`.
- [ ] Evitar los errores comunes al mutar, copiar, buscar e indexar estructuras.

## Apuntes

### Listas

Las **listas** son secuencias **mutables** y **ordenadas**. Pueden contener cualquier tipo de dato, incluso mezclado, y permiten añadir, eliminar o modificar elementos en el lugar.

```python
frutas = ["manzana", "pera", "uva"]   # literal
vacia = []                            # lista vacía
otra_vacia = list()                   # también lista vacía
numeros = list(range(5))              # [0, 1, 2, 3, 4]
repetida = [0] * 3                    # [0, 0, 0]
mezclada = [1, "dos", 3.0, True]      # tipos mezclados
```

#### Índices y slicing

El primer elemento está en el índice `0`; el último, en el `-1`. El **slicing** `[inicio:fin]` extrae un subrango donde **fin queda excluido**; con `[inicio:fin:paso]` se indica el paso, que puede ser negativo.

```python
nums = [10, 20, 30, 40, 50]
print(nums[0])      # 10
print(nums[-1])     # 50 (último)
print(nums[1:3])    # [20, 30]  (fin excluido)
print(nums[:2])     # [10, 20]  (desde el principio)
print(nums[2:])     # [30, 40, 50]  (hasta el final)
print(nums[::2])    # [10, 30, 50]  (cada 2 posiciones)
print(nums[::-1])   # [50, 40, 30, 20, 10]  (invertida)
print(nums[1:4:2])  # [20, 40]
```

El slicing **siempre devuelve una lista nueva**; nunca modifica la original. El paso negativo invierte el orden; `[::-1]` es el atajo para invertir sin usar `.reverse()`.

#### Métodos principales

```python
frutas = ["pera"]

frutas.append("uva")                # añade al final            -> ["pera", "uva"]
frutas.extend(["kiwi", "mango"])    # añade varios elementos    -> ["pera", "uva", "kiwi", "mango"]
frutas.insert(1, "limón")           # inserta en la posición 1  -> ["pera", "limón", "uva", "kiwi", "mango"]
frutas.remove("uva")                # elimina la primera aparición por valor
eliminado = frutas.pop()            # elimina y devuelve el último
primer = frutas.pop(0)              # elimina y devuelve el del índice 0
pos = frutas.index("kiwi")          # posición de la primera aparición
cant = frutas.count("limón")        # veces que aparece el valor
frutas.sort()                       # ordena EN EL LUGAR (devuelve None)
frutas.reverse()                    # invierte EN EL LUGAR (devuelve None)
copia = frutas.copy()               # copia independiente
frutas.clear()                      # vacía la lista
```

| Método | Qué hace | Notas |
|---|---|---|
| `append(x)` | añade `x` al final | una sola operación O(1) |
| `extend(iterable)` | añade todos los elementos del iterable | `+=` equivale a `extend` |
| `insert(i, x)` | inserta `x` en la posición `i` | desplaza el resto a la derecha |
| `remove(x)` | elimina la primera aparición por valor | lanza `ValueError` si no existe |
| `pop(i=-1)` | elimina y devuelve el elemento del índice | sin índice, el último |
| `index(x)` | posición de la primera aparición | lanza `ValueError` si no existe |
| `count(x)` | nº de apariciones de `x` | O(n) |
| `sort()` | ordena en el lugar | `key=` para orden personalizado, `reverse=True` |
| `reverse()` | invierte el orden en el lugar | |
| `copy()` | devuelve una copia superficial | también `lista[:]` o `list(lista)` |
| `clear()` | elimina todos los elementos | |

`len()`, `min()`, `max()`, `sum()`, `in` y `for` funcionan con listas igual que con cualquier secuencia.

#### Mutabilidad y copias

Por ser mutables, asignar una lista **no la copia**: las dos variables apuntan al mismo objeto.

```python
a = [1, 2, 3]
b = a                  # b y a apuntan a la MISMA lista
b.append(4)
print(a)               # [1, 2, 3, 4]  ¡también cambió a!

c = a.copy()           # copia independiente
c.append(5)
print(a)               # [1, 2, 3, 4]  c no afecta a a
print(c)               # [1, 2, 3, 4, 5]
```

Para copiar se usa `.copy()`, `lista[:]` o `list(lista)`. La copia es **superficial**: si la lista contiene listas, ambas comparten esas listas internas.

### List comprehensions

Una **list comprehension** construye una lista en una sola expresión. La sintaxis general es `[expresión for elemento in iterable if condición]`: primero el iterable y el `if` filtro, y solo al principio la expresión que se evalúa por cada elemento que pase.

```python
cuadrados = [n ** 2 for n in range(6)]        # [0, 1, 4, 9, 16, 25]

# Equivalente con bucle for
cuadrados = []
for n in range(6):
    cuadrados.append(n ** 2)
```

#### Con condición (filtro)

El `if` al final **filtra**: el elemento solo se incluye si cumple la condición.

```python
pares = [n for n in range(10) if n % 2 == 0]   # [0, 2, 4, 6, 8]
nombres = ["Ana", "luis", "MARTA"]
con_mayus = [n for n in nombres if n[0].isupper()]   # ['Ana', 'MARTA']
```

También puede usarse un **ternario** dentro de la expresión, que se evalúa para todos los elementos (no filtra):

```python
etiquetas = ["par" if n % 2 == 0 else "impar" for n in range(6)]
# ['par', 'impar', 'par', 'impar', 'par', 'impar']
```

La diferencia clave: el `if` de la derecha decide *si incluir*; el ternario de la izquierda decide *qué valor poner*.

#### Anidadas

El orden de los `for` en la comprehension es el mismo que en un bucle anidado: primero el bucle exterior, después el interior.

```python
# Producto cartesiano
pares_xy = [(x, y) for x in [1, 2] for y in [3, 4]]
# [(1, 3), (1, 4), (2, 3), (2, 4)]

# Aplanar una matriz (lista de listas)
matriz = [[1, 2, 3], [4, 5, 6]]
aplanada = [n for fila in matriz for n in fila]
# [1, 2, 3, 4, 5, 6]
```

#### Con `zip` y `enumerate`

`zip` combina varios iterables por posición; `enumerate` añade un índice a cada elemento. Ambos se usan mucho dentro de comprehensions.

```python
nombres = ["Ana", "Luis", "Marta"]
edades = [30, 25, 35]

parejas = [f"{n} ({e})" for n, e in zip(nombres, edades)]
# ['Ana (30)', 'Luis (25)', 'Marta (35)']

# con start para que el índice empiece en 1
numerados = [f"{i}-{n}" for i, n in enumerate(nombres, start=1)]
# ['1-Ana', '2-Luis', '3-Marta']

# dos estructuras a la vez
sumas = [a + b for a, b in zip([1, 2, 3], [10, 20, 30])]
# [11, 22, 33]
```

### Tuplas

Las **tuplas** son secuencias **inmutables** y **ordenadas**, definidas normalmente con paréntesis. Una vez creadas, no se puede añadir, eliminar ni modificar elementos.

```python
punto = (3, 4)          # tupla de dos elementos
vacia = ()              # tupla vacía
sin_parentesis = 3, 4   # también es una tupla
un_elemento = (3,)      # ¡la coma es lo que hace la tupla!
# (3)  ->  es solo el número 3, no una tupla
```

#### Empaquetado y desempaquetado

Python permite asignar varios valores a la vez: al lado izquierdo se "empaquetan" en una tupla y al asignar se "desempaquetan".

```python
# Empaquetado
coordenada = 10, 20, 30          # (10, 20, 30)

# Desempaquetado
x, y, z = coordenada             # x=10, y=20, z=30

# Con * el resto se recoge en una lista (Python 3)
primero, *resto = coordenada     # primero=10, resto=[20, 30]
a, *medio, z = coordenada        # a=10, medio=[20], z=30

# Intercambio de variables (swap) sin variable temporal
a, b = 1, 2
a, b = b, a                      # a=2, b=1

# Desempaquetado en un bucle
coordenadas = [(1, 2), (3, 4), (5, 6)]
for x, y in coordenadas:
    print(x + y)                 # 3 7 11
```

#### Métodos

Las tuplas solo tienen dos métodos (porque son inmutables no hay `append`, `pop`, etc.):

```python
t = (1, 2, 2, 3)
print(t.count(2))    # 2  (veces que aparece)
print(t.index(3))    # 3  (posición de la primera aparición)
print(len(t))        # 4
print(2 in t)        # True
```

#### Cuándo usar tuplas

- **Datos fijos** que no deben cambiar (coordenadas, fechas, configuraciones).
- **Claves de diccionario y elementos de set**: al ser inmutables son *hashables*; las listas no lo son.
- **Devolver varios valores** de una función (junto con el desempaquetado).
- **Datos pequeños y ligeros**: ocupan menos memoria que las listas y se crean más rápido.
- **Orden estable** con significado posicional: en una tupla el orden es parte del dato.

```python
dias = ("L", "M", "X", "J", "V")     # no debería cambiar
claves = {(1, 2): "fila 1", (3, 4): "fila 2"}   # tupla como clave
```

### Conjuntos (set)

Los **sets** son colecciones **sin orden** y **sin duplicados**. No se indexan (no hay `set[0]`) y no conservan el orden de inserción. Se usan para comprobar pertenencia y operaciones de teoría de conjuntos.

```python
a = {1, 2, 3}                # literal con llaves
dedupe = set([3, 1, 3, 2])   # {1, 2, 3}  (elimina duplicados)
# vacio = {}                # ¡NO! esto crea un DICCIONARIO
vacio = set()                # set vacío correcto
```

#### Métodos

```python
s = {1, 2, 3}
s.add(4)            # añade un elemento            -> {1, 2, 3, 4}
s.add(4)            # ya existe: no hace nada      -> {1, 2, 3, 4}
s.remove(1)         # elimina; KeyError si no existe
s.discard(99)       # elimina sin error si no existe
s.pop()             # elimina y devuelve un elemento ARBITRARIO (sin orden)
s.clear()           # vacía el set
```

Diferencia clave: `remove` lanza `KeyError` si el elemento no está; `discard` simplemente no hace nada.

#### Operaciones de conjunto: métodos y operadores

| Operación | Operador | Método | Resultado con `a={1,2,3}`, `b={3,4,5}` |
|---|---|---|---|
| Unión | `a \| b` | `a.union(b)` | `{1, 2, 3, 4, 5}` |
| Intersección | `a & b` | `a.intersection(b)` | `{3}` |
| Diferencia | `a - b` | `a.difference(b)` | `{1, 2}` |
| Diferencia simétrica | `a ^ b` | `a.symmetric_difference(b)` | `{1, 2, 4, 5}` |
| ¿Subconjunto? | | `a.issubset(b)` | `False` |
| ¿Superconjunto? | | `a.issuperset(b)` | `False` |
| ¿Disjuntos? | | `a.isdisjoint(b)` | `False` |

```python
a = {1, 2, 3}
b = {3, 4, 5}
print(a | b)                 # {1, 2, 3, 4, 5}
print(a & b)                 # {3}
print(a - b)                 # {1, 2}
print(a ^ b)                 # {1, 2, 4, 5}
print({1, 2}.issubset({1, 2, 3}))   # True
print({1, 2, 3}.issuperset({1, 2})) # True
print(a.isdisjoint({9, 10}))        # True
```

#### frozenset: conjuntos inmutables

`frozenset` es un set **inmutable**: se crea igual, pero no admite `add`, `remove`, etc. Al ser inmutable (hashable) puede usarse como clave de diccionario o como elemento de otro set.

```python
f = frozenset([1, 2, 3])
print(f & {2, 3, 9})      # frozenset({2, 3})  las operaciones de conjunto siguen disponibles
# f.add(4)                # AttributeError: 'frozenset' object has no attribute 'add'

claves = {frozenset(["a", "b"]): 1}   # frozenset como clave de dict
```

### Diccionarios

Los **diccionarios** asocian **claves únicas** a valores. Desde Python 3.7 **conservan el orden de inserción**. Las claves deben ser hashables (inmutables): números, strings, tuplas… pero **no listas ni sets**.

```python
usuario = {"nombre": "Ana", "edad": 30}
otro = dict(nombre="Ana", edad=30)     # con dict()
vacio = {}                             # diccionario vacío
```

#### Acceso: `[]` vs `get()`

`[]` lanza `KeyError` si la clave no existe; `get()` devuelve `None` (o un valor por defecto).

```python
usuario = {"nombre": "Ana", "edad": 30}
print(usuario["nombre"])          # Ana
# print(usuario["ciudad"])       # KeyError: 'ciudad'
print(usuario.get("ciudad"))      # None
print(usuario.get("ciudad", "Lima"))   # Lima  (default solo si falta)
print(usuario.get("nombre", "??"))     # Ana   (usa el default solo si NO existe)
```

#### Añadir, actualizar y eliminar

```python
usuario["ciudad"] = "Lima"        # añade la clave si no existe
usuario["edad"] = 31              # actualiza el valor si existe
usuario.setdefault("pais", "Perú")  # añade SOLO si no existe (no sobrescribe)
usuario.setdefault("edad", 0)     # ya existe: no cambia nada
del usuario["ciudad"]             # elimina; KeyError si no existe
eliminado = usuario.pop("edad", None)   # elimina y devuelve; default evita KeyError
usuario.update({"activo": True, "plan": "premium"})   # añade/actualiza varios a la vez
usuario.update(plan="basico")     # también acepta keyword arguments
```

#### Métodos principales

```python
usuario = {"nombre": "Ana", "edad": 30}

usuario.keys()        # dict_keys(['nombre', 'edad'])   vista de claves
usuario.values()      # dict_values(['Ana', 30])        vista de valores
usuario.items()       # dict_items([('nombre', 'Ana'), ('edad', 30)])  pares (clave, valor)
len(usuario)          # 2
```

Las **vistas** (`keys`, `values`, `items`) reflejan el diccionario en tiempo real y se pueden convertir a lista con `list(...)`.

#### Iteración

```python
usuario = {"nombre": "Ana", "edad": 30, "activo": True}

for clave in usuario:                 # itera sobre las claves
    print(clave)

for clave in usuario.keys():          # explícito
    print(clave)

for valor in usuario.values():        # solo valores
    print(valor)

for clave, valor in usuario.items():  # el más usado: clave y valor a la vez
    print(f"{clave}: {valor}")
```

Para construir una cadena o lista a partir de un diccionario:

```python
texto = ", ".join(f"{k}={v}" for k, v in usuario.items())
# 'nombre=Ana, edad=30, activo=True'
```

#### Dict comprehensions

La sintaxis es como la de lista pero con `{clave: valor ...}`:

```python
cuadrados = {n: n ** 2 for n in range(4)}   # {0: 0, 1: 1, 2: 4, 3: 9}

usuario = {"nombre": "Ana", "edad": 30, "activo": True}
invertido = {v: k for k, v in usuario.items()}   # {30: 'edad', ...}
filtrado = {k: v for k, v in usuario.items() if isinstance(v, str)}
```

### Comparación de las cuatro estructuras

| Estructura | Mutabilidad | Orden | Duplicados | Uso típico |
|---|---|---|---|---|
| `list` | mutable | sí (inserción) | sí | colección ordenada, acceso por índice |
| `tuple` | inmutable | sí | sí | datos fijos, hashables, desempaquetado |
| `set` | mutable | no | no | pertenencia, deduplicar, operaciones de conjuntos |
| `frozenset` | inmutable | no | no | set como clave / elemento de otro set |
| `dict` | mutable | sí (inserción, 3.7+) | claves no | mapear clave → valor |

**Complejidad aproximada** (caso promedio):

| Operación | `list` / `tuple` | `set` / `frozenset` | `dict` |
|---|---|---|---|
| Acceso (índice o clave) | O(1) | — | O(1) |
| Búsqueda con `in` | O(n) | O(1) | O(1) en claves |
| Añadir al final / insertar | O(1) / O(n) | O(1) | O(1) |
| Eliminar | O(n) | O(1) | O(1) |
| Ordenar | O(n log n) | — | — |

Reglas prácticas para elegir:

- **Lista** — orden importa, hay duplicados, necesitas índice o recorrerlo en orden.
- **Tupla** — los datos no cambian, necesitas una clave hashable o devolver varios valores.
- **Set** — solo importa "¿está o no está?" y eliminar duplicados.
- **Diccionario** — necesitas buscar por clave rápidamente o asociar datos.

### `in` y búsqueda en cada estructura

El operador `in` funciona en todas, pero su coste cambia según la estructura:

```python
3 in [1, 2, 3]        # listas y tuplas: búsqueda LINEAL O(n)
3 in (1, 2, 3)        # igual
3 in {1, 2, 3}        # set: búsqueda por HASH O(1) — el más rápido para pertenencia
"edad" in usuario     # dict: busca en las CLAVES O(1)
# "Ana" in usuario           -> False  (busca claves, no valores)
# "Ana" in usuario.values()  -> True   (buscar en valores es O(n))
```

Si solo necesitas comprobar pertenencia, un `set` o un `dict` son mucho más rápidos que una lista o tupla con muchos datos.

### Estructuras adicionales de `collections`

El módulo `collections` ofrece estructuras especializadas:

```python
from collections import deque, Counter, defaultdict, namedtuple
```

**`deque`** — cola eficiente por ambos extremos. `list` es rápida al final pero lenta al principio (`pop(0)` es O(n)); `deque` hace ambas en O(1).

```python
cola = deque([1, 2, 3])
cola.append(4)          # añade al final
cola.appendleft(0)      # añade al principio
print(cola.popleft())   # 0  (saca por la izquierda)
print(cola.pop())       # 4  (saca por la derecha)
```

**`Counter`** — cuenta apariciones y ofrece los métodos más útiles de conteo.

```python
conteo = Counter("mississippi")
print(conteo["s"])            # 4
print(conteo.most_common(2))  # [('i', 4), ('s', 4)]  (empates en orden de primera aparición)
```

**`defaultdict`** — como un dict, pero al acceder a una clave inexistente crea el valor por defecto automáticamente. Evita comprobaciones manuales.

```python
grupos = defaultdict(list)
grupos["frutas"].append("manzana")   # sin KeyError: crea [] y añade
grupos["frutas"].append("pera")
print(grupos)   # defaultdict(<class 'list'>, {'frutas': ['manzana', 'pera']})

# Equivalente con dict normal:
grupos = {}
grupos.setdefault("frutas", []).append("manzana")
```

**`namedtuple`** — tuplas con campos con nombre: se accede tanto por índice como por atributo.

```python
Punto = namedtuple("Punto", ["x", "y"])
p = Punto(3, 4)
print(p.x)      # 3  (acceso por nombre)
print(p[0])     # 3  (acceso por índice, sigue siendo tupla)
x, y = p        # desempaquetado normal
```

## Ejemplos de código

```python
# Contador de palabras con diccionario y get()
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

```python
# Buscar el valor máximo y su índice con enumerate
valores = [4, 9, 2, 7, 9]
indices_max = [i for i, v in enumerate(valores) if v == max(valores)]
print(indices_max)   # [1, 4]  (todas las posiciones del máximo)
```

## Ejercicios relacionados

Esta guía se refuerza con los siguientes ejercicios de la ruta:

- **Nivel 01 — Fundamentos:**
  - [ejercicio-04-listas-basicas](../ejercicios/nivel-01-fundamentos/ejercicio-04-listas-basicas/) — crear, indexar y recorrer listas.
  - [ejercicio-06-diccionarios-basicos](../ejercicios/nivel-01-fundamentos/ejercicio-06-diccionarios-basicos/) — pares clave→valor, acceso con `[]` y `get()`.
- **Nivel 02 — Básico:**
  - [ejercicio-02-list-comprehensions](../ejercicios/nivel-02-basico/ejercicio-02-list-comprehensions/) — comprehensions con filtros y transformaciones.
  - [ejercicio-03-metodos-de-listas](../ejercicios/nivel-02-basico/ejercicio-03-metodos-de-listas/) — `append`, `pop`, `sort`, slicing y copias.
  - [ejercicio-06-tuplas-y-sets](../ejercicios/nivel-02-basico/ejercicio-06-tuplas-y-sets/) — desempaquetado, conjuntos y operadores `|`, `&`, `-`.

## Errores comunes

- **Mutar una lista mientras se itera** → se saltan elementos o se recorren índices desfasados. Itera sobre una copia o usa una comprehension.

```python
# ❌ elimina por valor mientras itera: frágil y saltan elementos
nums = [1, 2, 3, 4, 5]
for n in nums:
    if n % 2 == 0:
        nums.remove(n)

# ✔ iterar sobre una copia y eliminar en la original
nums = [1, 2, 3, 4, 5]
for n in nums[:]:
    if n % 2 == 0:
        nums.remove(n)

# ✔ o directamente con una comprehension (lo más idiomático)
nums = [1, 2, 3, 4, 5]
nums = [n for n in nums if n % 2 != 0]
```

- **Usar una lista como clave de diccionario o elemento de set** → `TypeError: unhashable type: 'list'`. Las claves deben ser inmutables; usa tuplas.

```python
# d[[1, 2]] = "x"        # ❌ TypeError
d = {(1, 2): "x"}        # ✔ tupla como clave
```

- **Confundir tupla, set y dict (llaves vs paréntesis)** → `(1, 2)` es una tupla (ordenada, inmutable, indexable); `{1, 2}` es un set (sin orden, sin duplicados); `{1: "a"}` es un diccionario.

```python
t = (1, 2, 2)    # tupla: mantiene el duplicado
s = {1, 2, 2}    # set: elimina el duplicado -> {1, 2}
d = {1: "a"}     # dict: pares clave -> valor
```

- **`KeyError` al acceder con `[]`** → la clave no existe. Usa `.get(clave, default)` o comprueba antes con `in`.

```python
# usuario["ciudad"]       # ❌ KeyError si no existe
print(usuario.get("ciudad", "desconocida"))   # ✔
if "ciudad" in usuario:   # ✔ comprobación previa
    print(usuario["ciudad"])
```

- **Pensar que `{}` crea un set vacío** → `{}` crea un **diccionario** vacío. Para un set vacío usa `set()`.

- **Confundir `(3)` con una tupla** → `(3)` es solo el `int` 3 (los paréntesis agrupan). Una tupla de un elemento necesita coma: `(3,)`.

- **Copiar listas con `=`** → ambas variables comparten la misma lista; mutar una afecta a la otra. Usa `.copy()`, `[:]` o `list()` para una copia real.

- **Usar `sort()` esperando que devuelva la lista ordenada** → `sort()` ordena *en el lugar* y devuelve `None`. `sorted()` devuelve una lista nueva sin tocar la original.

```python
a = [3, 1, 2]
b = sorted(a)      # b = [1, 2, 3]; a sigue [3, 1, 2]
a.sort()           # a = [1, 2, 3]; devuelve None
```

- **Confundir `remove` y `pop`** → `remove(x)` elimina por **valor** (primera aparición); `pop(i)` elimina por **índice** y devuelve el elemento.

- **`ValueError` con `index()` o `remove()`** → el valor no existe. Compruébalo con `in` antes o usa `.count()`/condiciones.

- **Confundir `remove` de sets con `discard`** → `set.remove(x)` lanza `KeyError` si no existe; `set.discard(x)` no hace nada.

## Recursos

- [Python.org — Estructuras de datos](https://docs.python.org/es/3/tutorial/datastructures.html)
- [Python.org — List comprehensions](https://docs.python.org/es/3/tutorial/datastructures.html#list-comprehensions)
- [Python.org — El módulo collections](https://docs.python.org/es/3/library/collections.html)
- [Real Python — Python Data Structures](https://realpython.com/python-data-structures/)
- [Real Python — List Comprehensions](https://realpython.com/list-comprehension-python/)
- [Real Python — Understanding Python Dictionary Keys](https://realpython.com/python-dicts/)