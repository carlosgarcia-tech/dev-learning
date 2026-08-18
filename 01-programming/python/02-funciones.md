# 02 — Funciones en Python

## Objetivos

- [ ] Definir funciones con `def`, parámetros y `return`.
- [ ] Usar parámetros por defecto, *args y **kwargs.
- [ ] Pasar argumentos posicionales y por nombre (keyword).
- [ ] Distinguir parámetros solo posicionales (`/`) y solo por palabra clave (`*`).
- [ ] Entender el scope: variables locales, globales, `global` y `nonlocal`.
- [ ] Devolver varios valores con tuplas y manejar funciones sin `return`.
- [ ] Escribir docstrings estilo PEP 257 y documentar con `help()`.
- [ ] Añadir anotaciones de tipo básicas (`int`, `str`, `Optional`, `list[int]`).
- [ ] Tratar las funciones como valores: asignarlas, pasarlas y anidarlas.
- [ ] Usar `lambda` para funciones anónimas simples.
- [ ] Identificar y corregir los errores de funciones más comunes.

## Apuntes

### ¿Qué es una función?

Una **función** es un bloque de código **con nombre y reutilizable** que recibe datos de entrada (parámetros), ejecuta una tarea y devuelve un resultado. Es la unidad básica de organización del código en Python.

En el nivel 01 ya usaste funciones integradas como `print()`, `len()` o `input()`. En esta guía aprenderás a **crear las tuyas** con `def`.

#### Características principales:

- **Reutilizable**: se define una vez y se puede llamar tantas veces como se necesite.
- **Parametrizable**: recibe argumentos para adaptar su comportamiento a cada llamada.
- **Componible**: una función puede llamar a otras funciones y devolver valores para que otros las usen.
- **De primera clase**: en Python las funciones son valores: se pueden asignar a variables, pasar como argumentos y devolver desde otras funciones.

### ¿Por qué usar funciones?

| Beneficio | Qué aporta |
|---|---|
| **DRY** (Don't Repeat Yourself) | El código que se repite se escribe una sola vez; los cambios se hacen en un único lugar |
| **Modularidad** | Se divide el problema en piezas pequeñas y legibles; cada función hace una cosa |
| **Testabilidad** | Una función con entradas y salidas claras se puede comprobar de forma aislada |
| **Legibilidad** | Un nombre bien elegido documenta la intención: `es_primo(n)` dice más que el bloque de código |
| **Abstracción** | Quien llama no necesita saber *cómo* funciona, solo *qué* hace |

```python
# Sin funciones: la lógica del área se repite por cada radio
a1 = 3.1416 * 2 ** 2
a2 = 3.1416 * 5 ** 2

# Con una función: se define una vez y se llama con cada radio
def area_circulo(radio):
    return 3.1416 * radio ** 2

print(area_circulo(2))    # 12.5664
print(area_circulo(5))    # 78.54
```

### Sintaxis básica

Una función se define con `def`, un nombre, parámetros entre paréntesis, dos puntos y un cuerpo **indentado** (4 espacios por convención):

```python
def saludar(nombre):            # def + nombre + parámetros
    """Devuelve un saludo."""   # docstring (opcional pero recomendado)
    return f"Hola, {nombre}!"   # cuerpo: devuelve el resultado

print(saludar("Ana"))           # Hola, Ana!
```

Elementos de la definición:

| Elemento | Función |
|---|---|
| `def` | Palabra clave que inicia la definición |
| `saludar` | Nombre de la función (en `snake_case`) |
| `(nombre)` | Lista de parámetros, separados por comas |
| `:` | Fin de la cabecera, comienza el cuerpo indentado |
| `"""..."""` | Docstring: documentación asociada a la función |
| `return ...` | Devuelve un valor y termina la ejecución |
| `pass` | Cuerpo vacío válido (función aún sin implementar) |

```python
def pendiente():
    pass   # evita SyntaxError mientras no se implementa

print(pendiente())   # None
```

> El nombre de la función se escribe en **minúsculas con guiones bajos** (`snake_case`): `calcular_imc`, `leer_archivo`. Los nombres con mayúsculas se reservan para clases.

### Parámetros y argumentos en profundidad

En Python se distingue entre **parámetro** (el nombre en la definición) y **argumento** (el valor que se pasa en la llamada). Hay varias formas de pasar argumentos.

#### Argumentos posicionales

Se pasan en el mismo orden que la definición:

```python
def resta(a, b):
    return a - b

print(resta(10, 3))   # 7  → a=10, b=3
print(resta(3, 10))   # -7 → a=3, b=10  (el orden importa)
```

#### Argumentos por nombre (keyword)

Se indica el nombre del parámetro en la llamada. El orden deja de importar:

```python
print(resta(b=3, a=10))   # 7
```

Ventajas: la llamada es autoexplicativa (`area(base=5, altura=3)`) y permite omitir parámetros intermedios que tienen valor por defecto.

#### Parámetros con valores por defecto

Un parámetro puede tener un valor inicial que se usa si la llamada no lo aporta:

```python
def potencia(base, exponente=2):
    return base ** exponente

print(potencia(5))              # 25  (usa exponente=2)
print(potencia(5, 3))           # 125
print(potencia(2, exponente=10))  # 1024
```

Reglas:

- Los parámetros **con** valor por defecto deben ir **después** de los obligatorios.
- El valor por defecto se evalúa **una sola vez**, en el momento de definir la función (esto causa el famoso error de las listas mutables, ver "Errores comunes").

```python
def saludar(nombre, idioma="es"):   # ✔ correcto
    ...

def saludar(idioma="es", nombre):   # ✘ SyntaxError: non-default argument follows default
    ...
```

#### `*args`: argumentos posicionales variables

Un parámetro precedido de `*` recoge **todos los argumentos posicionales extra** en una **tupla**:

```python
def sumar_todos(*args):
    return sum(args)

print(sumar_todos(1, 2, 3, 4))   # 10
print(sumar_todos())             # 0
```

El nombre `args` es convención; `*numeros` o cualquier otro también funciona. El asterisco es lo que importa.

#### `**kwargs`: argumentos por nombre variables

Un parámetro precedido de `**` recoge **todos los argumentos por nombre extra** en un **diccionario**:

```python
def imprimir_config(**kwargs):
    for clave, valor in kwargs.items():
        print(f"{clave} = {valor}")

imprimir_config(tema="oscuro", idioma="es")
# tema = oscuro
# idioma = es
```

#### Combinar `*args` y `**kwargs`

Ambos se pueden combinar con parámetros normales. Orden habitual: obligatorios, `*args`, por defecto, `**kwargs`:

```python
def registrar_venta(producto, *cantidades, **detalles):
    total = sum(cantidades)
    info = f"{producto}: {total} unidades"
    if detalles.get("moneda"):
        info += f" ({detalles['moneda']})"
    return info

print(registrar_venta("libro", 2, 3, moneda="USD"))
# libro: 5 unidades (USD)
```

#### Parámetros solo posicionales (`/`)

El `/` en la firma marca que los parámetros **a su izquierda** solo pueden pasarse por posición:

```python
def dividir_entero(a, b, /):
    return a // b

print(dividir_entero(10, 3))     # 3
# dividir_entero(a=10, b=3)      # TypeError: got some positional-only arguments
```

#### Parámetros solo por palabra clave (`*`)

El `*` en la firma marca que los parámetros **a su derecha** solo pueden pasarse por nombre:

```python
def formatear(texto, *, mayusculas=False):
    return texto.upper() if mayusculas else texto

print(formatear("hola"))                      # hola
print(formatear("hola", mayusculas=True))     # HOLA
# formatear("hola", True)                     # TypeError: takes 1 positional argument
```

Es útil para evitar llamadas confusas cuando el orden de los argumentos no es obvio.

#### Combinando `/` y `*`

```python
def configurar(nombre, /, version=1, *, seguro=True):
    return f"{nombre}-v{version}-{'seguro' if seguro else 'publico'}"

print(configurar("app"))                  # app-v1-seguro
print(configurar("app", 2))               # app-v2-seguro
print(configurar("app", 2, seguro=False)) # app-v2-publico
# configurar(nombre="app")                # TypeError
```

#### Resumen: modos de llamada

| Modo | Firma | Llamada válida | Observación |
|---|---|---|---|
| Posicional | `def f(a, b)` | `f(1, 2)` | Asigna en orden |
| Por nombre | `def f(a, b)` | `f(a=1, b=2)` | El orden no importa |
| Por defecto | `def f(a, b=2)` | `f(1)` | `b` usa el valor por defecto |
| `*args` | `def f(*args)` | `f(1, 2, 3)` | Posicionales extra en **tupla** |
| `**kwargs` | `def f(**kwargs)` | `f(x=1, y=2)` | Por nombre extra en **dict** |
| Solo posicional | `def f(a, /)` | `f(1)` | No acepta `a=1` |
| Solo keyword | `def f(*, a)` | `f(a=1)` | No acepta `f(1)` |

### Retorno

#### `return` simple

`return` devuelve un valor y **termina la ejecución** de la función; las líneas posteriores no se ejecutan:

```python
def es_mayor_edad(edad):
    if edad >= 18:
        return True
    return False

print(es_mayor_edad(20))   # True
print(es_mayor_edad(15))   # False
```

#### Funciones sin `return`: devuelven `None`

Si una función no tiene `return` (o lo tiene vacío), devuelve `None` implícitamente:

```python
def imprimir_suma(a, b):
    print(a + b)          # imprime, pero no devuelve nada

resultado = imprimir_suma(3, 4)
print(resultado)          # None

def solo_efecto():
    return                # return vacío equivale a `return None`
```

Las funciones que solo imprimen o modifican algo (efecto) no necesitan devolver un valor; las que **calculan** deben usar `return`.

#### Devolver múltiples valores

`return` puede devolver varios valores separados por comas; Python los empaqueta en una **tupla**:

```python
def dividir(a, b):
    return a // b, a % b    # se empaqueta como (cociente, resto)

c, r = dividir(10, 3)       # desempaquetado
print(c, r)                 # 3 1

resultado = dividir(10, 3)  # sin desempaquetar
print(resultado)            # (3, 1)
print(type(resultado))      # <class 'tuple'>
```

#### Salidas tempranas

Un `return` en medio del código permite "cortar" la ejecución cuando ya se tiene el resultado, evitando anidar condicionales:

```python
def buscar(lista, valor):
    for i, x in enumerate(lista):
        if x == valor:
            return i        # sale en cuanto encuentra
    return -1               # no encontrado

print(buscar([4, 8, 15, 16], 15))   # 2
print(buscar([4, 8, 15, 16], 99))   # -1
```

### Scope: variables locales y globales

El **scope** (ámbito) determina dónde existe una variable y desde dónde se puede acceder.

#### Variables locales

Las variables definidas **dentro** de una función son locales: solo existen mientras la función se ejecuta y no se ven desde fuera:

```python
def mi_funcion():
    local = 10
    return local

mi_funcion()
# print(local)   # NameError: name 'local' is not defined
```

Cada llamada crea su propio espacio de variables; no comparten estado entre llamadas (salvo closures, ver más abajo).

#### Variables globales

Las variables definidas a nivel de **módulo** (fuera de toda función) son globales. Dentro de una función se pueden **leer** sin problema:

```python
mensaje = "Hola desde el módulo"

def leer_global():
    print(mensaje)   # solo lectura

leer_global()        # Hola desde el módulo
```

Pero **asignar** a una variable global sin declararla crea una local nueva (y provoca un error clásico):

```python
contador = 0

def incrementar_mal():
    contador += 1        # UnboundLocalError: local variable 'contador' referenced before assignment

incrementar_mal()
```

#### La regla LEGB

Cuando Python resuelve un nombre busca, en este orden: **L**ocal → **E**nclosing → **G**lobal → **B**uilt-in.

| Ámbito | Letra | Dónde se define |
|---|---|---|
| Local | L | Dentro de la función actual |
| Enclosing | E | Funciones externas en funciones anidadas |
| Global | G | A nivel de módulo (top-level) |
| Built-in | B | Funciones integradas (`len`, `print`, `sum`…) |

#### Modificar una global con `global`

Para **modificar** una variable global dentro de una función hay que declararla con `global`:

```python
contador = 0

def incrementar():
    global contador
    contador += 1

incrementar()
incrementar()
print(contador)   # 2
```

> Usar `global` con moderación: abusar de él dificulta razonar sobre el código. Mejor pasar y devolver valores explícitamente.

#### Ámbitos anidados y `nonlocal`

En funciones anidadas, `nonlocal` permite modificar una variable del ámbito **enclosing** (la función externa) sin que sea global:

```python
def externa():
    valor = 10

    def interna():
        nonlocal valor
        valor += 5

    interna()
    return valor

print(externa())   # 15
```

#### Comparación de scope

| Situación | ¿Se puede leer? | ¿Se puede modificar? |
|---|---|---|
| Local, desde su propia función | Sí | Sí |
| Global, desde una función | Sí | No, sin `global` |
| Enclosing, desde una función anidada | Sí | No, sin `nonlocal` |
| Local, desde fuera de la función | No | No |

#### Closures (introducción)

Una **closure** es una función anidada que "recuerda" y conserva el estado de su entorno, incluso después de que la función externa haya terminado:

```python
def crear_contador():
    cuenta = 0

    def incrementar():
        nonlocal cuenta
        cuenta += 1
        return cuenta

    return incrementar

contador_a = crear_contador()
print(contador_a())   # 1
print(contador_a())   # 2

contador_b = crear_contador()   # estado independiente
print(contador_b())   # 1
```

Cada llamada a `crear_contador()` crea una variable `cuenta` independiente que la función devuelta conserva. En profundidad las verás en la guía 03 (closures y decoradores).

### Anotaciones de tipo (type hints)

Las **type hints** documentan los tipos esperados de parámetros y del valor de retorno:

```python
def saludar(nombre: str) -> str:
    return f"Hola, {nombre}"

def sumar(a: int, b: int) -> int:
    return a + b
```

> Las anotaciones son **opcionales y no se aplican en tiempo de ejecución**: Python no lanza errores si pasas un tipo distinto. Son útiles para leer el código y para herramientas de análisis estático como `mypy`.

Tipos más comunes:

| Anotación | Significado | Ejemplo |
|---|---|---|
| `int` | entero | `def doble(x: int) -> int` |
| `float` | coma flotante | `def area(r: float) -> float` |
| `str` | cadena de texto | `def saludo(n: str) -> str` |
| `bool` | booleano | `def es_par(n: int) -> bool` |
| `list[int]` | lista de enteros | `def suma(ls: list[int]) -> int` |
| `dict[str, int]` | dict con claves `str` y valores `int` | `def cuenta(d: dict[str, int])` |
| `Optional[str]` | `str` **o** `None` | `def f(x: Optional[str]) -> str` |
| `Union[int, str]` | `int` **o** `str` | `def f(x: Union[int, str]) -> str` |
| `int \| None` | igual que `Optional[int]` (Python 3.10+) | `def f(x: int \| None) -> int` |

`Optional` y `Union` se importan de `typing`:

```python
from typing import Optional, Union

def formatear(texto: Optional[str]) -> str:
    return texto.upper() if texto is not None else ""

def sumar_lista(numeros: list[int]) -> int:
    return sum(numeros)

def buscar_por_id(usuarios: dict[str, int], nombre: str) -> int | None:
    return usuarios.get(nombre)
```

### Funciones como valores

Las funciones son **objetos de primera clase**: se pueden guardar en variables, pasar como argumentos, meter en colecciones y devolver desde otras funciones.

#### Asignar una función a una variable

Al asignar **sin paréntesis** no se llama: se guarda la referencia:

```python
def doble(x):
    return x * 2

operacion = doble          # sin paréntesis → referencia
print(operacion(4))        # 8
print(doble is operacion)  # True (es la misma función)
```

#### Pasar una función como argumento

Las funciones se pueden pasar a otras funciones que deciden cuándo llamarlas (patrón *callback*):

```python
def aplicar(op, valor):
    return op(valor)

def cuadrado(x):
    return x * x

print(aplicar(cuadrado, 5))   # 25
print(aplicar(lambda x: x + 1, 5))   # 6 (lambda, ver más abajo)
```

#### Funciones anidadas y que devuelven funciones

Una función puede definirse dentro de otra y/o devolverse como resultado:

```python
def fabricar_multiplicador(factor):
    def multiplicar(x):
        return x * factor
    return multiplicar

por_tres = fabricar_multiplicador(3)
print(por_tres(7))   # 21
```

Esta combinación (función que devuelve función + variables del entorno) es la base de las closures.

### Funciones anónimas: `lambda`

Una `lambda` es una **función anónima de una sola expresión**: `lambda argumentos: expresión`. No lleva `def`, ni nombre, ni `return` (el resultado de la expresión es el valor devuelto).

```python
doble = lambda x: x * 2
print(doble(4))   # 8

print((lambda a, b: a + b)(3, 4))   # 7
```

Se usan mucho como argumento de otras funciones que reciben un "callback" (`sorted`, `filter`, `map`):

```python
puntos = [(1, 3), (4, 1), (2, 2)]
print(sorted(puntos, key=lambda p: p[1]))
# [(4, 1), (2, 2), (1, 3)]  ordenado por el segundo elemento
```

> Si la lógica necesita más de una expresión o un `if` complejo, usa `def`. En profundidad (uso con `map`, `filter`, `sorted`) las verás en la guía 03 y en los ejercicios.

### Documentación: docstrings

El **docstring** es la primera declaración del cuerpo: un string literal que documenta la función. Se accede con `help()`, `__doc__` y las herramientas de documentación automática.

#### Docstring de una línea

```python
def area_rectangulo(base, altura):
    """Calcula el área de un rectángulo."""
    return base * altura
```

#### Docstring multilínea (PEP 257)

Para funciones con más detalle, se describe la acción, los `Args` y el `Returns`:

```python
def calcular_imc(peso: float, altura: float) -> float:
    """Calcula el índice de masa corporal (IMC).

    Args:
        peso: peso en kilogramos.
        altura: altura en metros.

    Returns:
        El IMC calculado como float.
    """
    return peso / altura ** 2

print(calcular_imc(70, 1.75))   # 22.857...
```

#### `help()` y `__doc__`

```python
help(area_rectangulo)
# Help on function area_rectangulo in module __main__:
#
# area_rectangulo(base, altura)
#     Calcula el área de un rectángulo.

print(area_rectangulo.__doc__)   # Calcula el área de un rectángulo.
```

> Convención: los docstrings usan comillas dobles `"""` y describen **qué** hace la función, no cómo. El `print()` fuera de la función solo sirve para mostrar la documentación; no forma parte de ella.

## Ejemplos de código

```python
# Calculadora básica con funciones
def suma(a, b): return a + b
def resta(a, b): return a - b
def multiplica(a, b): return a * b
def divide(a, b):
    if b == 0:
        return "Error: división entre cero"
    return a / b

print(suma(10, 5))            # 15
print(resta(10, 5))           # 5
print(multiplica(10, 5))      # 50
print(divide(10, 0))          # Error: división entre cero
```

```python
# Función con *args y **kwargs combinados
def resumen(nombre, *numeros, **opciones):
    total = sum(numeros)
    promedio = total / len(numeros) if numeros else 0
    linea = f"{nombre}: total={total}, promedio={promedio:.1f}"
    if opciones.get("moneda"):
        linea += f" en {opciones['moneda']}"
    return linea

print(resumen("Ventas", 10, 20, 30, moneda="USD"))
# Ventas: total=60, promedio=20.0 en USD
```

```python
# Función que devuelve otra función (closure)
def crear_taxa(porcentaje):
    def aplicar(monto):
        return monto * (1 + porcentaje / 100)
    return aplicar

iva = crear_taxa(21)
print(iva(100))    # 121.0
```

## Errores comunes

Estos son los fallos más típicos al trabajar con funciones y sus correcciones:

### 1. Olvidar `return`

```python
def cuadrado(n):        # ✘ mal: calcula pero no devuelve
    n * n

print(cuadrado(4))      # None
```

```python
def cuadrado(n):        # ✔ bien
    return n * n

print(cuadrado(4))      # 16
```

Si una función "no hace nada" con el valor que calcula, seguro que le falta un `return`.

### 2. Parámetro por defecto mutable

El valor por defecto se evalúa **una sola vez**; si es mutable (lista, dict…), se comparte entre todas las llamadas:

```python
def agregar_item(lista=[], item=1):   # ✘ mal
    lista.append(item)
    return lista

print(agregar_item())   # [1]
print(agregar_item())   # [1, 1]  ← la lista se acumula entre llamadas
```

```python
def agregar_item(lista=None, item=1):   # ✔ bien
    if lista is None:
        lista = []
    lista.append(item)
    return lista

print(agregar_item())   # [1]
print(agregar_item())   # [1]  ← cada llamada usa una lista nueva
```

Regla: los valores por defecto mutables se sustituyen por `None` y se inicializan dentro.

### 3. Modificar una variable global sin `global`

```python
contador = 0

def incrementar():      # ✘ mal
    contador += 1

incrementar()   # UnboundLocalError: local variable 'contador' referenced before assignment
```

```python
contador = 0

def incrementar():      # ✔ bien
    global contador
    contador += 1
```

Recuerda: **asignar** dentro de una función crea una variable local, aunque exista una global con el mismo nombre.

### 4. Sombreado de variables

Un parámetro (o variable local) con el mismo nombre que una variable global **la oculta** dentro de la función:

```python
precio = 100

def calcular_precio(precio):   # el parámetro "sombrea" la global
    return precio * 0.9

print(calcular_precio(50))     # 45.0  (usa el parámetro, no la global)
print(precio)                  # 100   (la global no cambió)
```

No es un error de ejecución, pero confunde. Usa nombres distintos para evitar ambigüedad.

### 5. Falta de argumentos obligatorios

```python
def area(base, altura):
    return base * altura

area(5)   # TypeError: area() missing 1 required positional argument: 'altura'
```

Corrección: pasa todos los argumentos obligatorios o dales valor por defecto en la firma.

### 6. Confundir `*args` con `**kwargs`

- `*args` recoge **posicionales** en una **tupla**.
- `**kwargs` recoge **por nombre** en un **diccionario**.

```python
def f(*args, **kwargs):
    print(args, kwargs)

f(1, 2, x=3)   # (1, 2) {'x': 3}
```

Intentar iterar uno como si fuera el otro, o esperar claves donde hay índices, produce errores o resultados vacíos.

### 7. Pasar una función en vez de llamarla

```python
def cuadrado(n):
    return n * n

operacion = cuadrado    # sin paréntesis: referencia, NO se llama
print(operacion(3))     # 9  (se llama al final)

print(cuadrado)         # <function cuadrado at 0x...>  (la referencia, no su resultado)
```

Sin paréntesis se pasa la función como valor; con paréntesis se ejecuta. Confundirlos es un clásico con `sorted(key=...)` y similares.

## Ejercicios relacionados

Pon en práctica lo aprendido con los ejercicios del **nivel 02**:

- [Ejercicio 01 — Funciones](../ejercicios/nivel-02-basico/ejercicio-01-funciones/): `def`, parámetros, valores por defecto y retorno de tuplas. Es el ejercicio directo de esta guía.
- [Ejercicio 06 — Tuplas y sets](../ejercicios/nivel-02-basico/ejercicio-06-tuplas-y-sets/): reforzarás el desempaquetado de los retornos múltiples.
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/): las closures, decoradores y **recursión** se trabajan en el nivel 03, una vez dominada esta guía.

Consejo de práctica: define cada función con su **docstring** y sus **type hints**, y comprueba los retornos con casos como `None`, tuplas vacías o listas vacías.

## Recursos

- [Python.org — Definición de funciones](https://docs.python.org/es/3/tutorial/controlflow.html#definiendo-funciones)
- [Python.org — Argumentos especiales (`/` y `*`)](https://docs.python.org/es/3/tutorial/controlflow.html#mas-sobre-la-definicion-de-funciones)
- [Real Python — Python Functions](https://realpython.com/defining-your-own-python-function/)
- [Real Python — Scope (regla LEGB)](https://realpython.com/python-scope-legb-rule/)
- [PEP 257 — Docstring Conventions](https://peps.python.org/pep-0257/)
- [mypy — Cheat Sheet de type hints](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html)