# 01 — Fundamentos de Python

## Objetivos

- [ ] Entender qué es Python, sus características principales y su filosofía (baterías incluidas, legibilidad).
- [ ] Instalar y configurar el entorno: verificar `python3 --version` y ejecutar scripts.
- [ ] Usar el REPL interactivo para probar código al vuelo.
- [ ] Escribir programas básicos respetando la indentación (bloques con espacios, no llaves).
- [ ] Identificar los tipos de datos principales (`str`, `int`, `float`, `bool`, `None`) y usar `type()`.
- [ ] Declarar variables y aplicar conversión de tipos (`int`, `float`, `str`).
- [ ] Usar `input()` y `print()` para entrada/salida por consola.
- [ ] Aplicar operadores aritméticos, de comparación, lógicos y de asignación.
- [ ] Escribir condicionales `if/elif/else`, comparaciones encadenadas y el operador ternario.
- [ ] Usar los bucles `for` (con `range`) y `while`, con `break`, `continue`, `else` y `enumerate`.
- [ ] Trabajar con strings: métodos más usados, slicing e interpolación con f-strings.
- [ ] Trabajar con listas: índices, slicing, `append`, `len`, `sum`, `min`, `max` e `in`.
- [ ] Conocer los errores más comunes de principiante y cómo corregirlos.

## Apuntes

### ¿Qué es Python?

Python es un lenguaje de programación **interpretado, de alto nivel y multipropósito** creado por Guido van Rossum en 1991. Se ejecuta en Windows, Linux y macOS, y es uno de los lenguajes más usados del mundo tanto para principiantes como en la industria.

#### Características principales

- **Interpretado**: no hay una fase de compilación separada; el código lo ejecuta directamente el intérprete.
- **Tipado dinámico**: las variables adoptan el tipo del valor que se les asigna en tiempo de ejecución, sin declararlo.
- **Multiparadigma**: soporta programación imperativa, orientada a objetos y funcional.
- **Legible**: la indentación obligatoria produce código ordenado y limpio.
- **Baterías incluidas** (*batteries included*): la biblioteca estándar trae módulos para casi todo (E/S, JSON, HTTP, matemáticas, fechas, etc.).
- **Gestionado**: cuenta con *garbage collector* para la memoria, como C#/Java.
- **Multiplataforma y versátil**: consola/scripts, web (Django, Flask), datos y ciencia (NumPy, pandas, Matplotlib), IA/ML, automatización y DevOps.

#### La filosofía del lenguaje

La comunidad sigue el *Zen de Python* (PEP 20), que se muestra con `import this`. Sus principios más citados:

- "Lo bello es mejor que lo feo" — código que se lee bien.
- "Explícito es mejor que implícito" — no depender de magia o atajos confusos.
- "Simple es mejor que complejo" — buscar la solución más sencilla.
- "La legibilidad cuenta" — el código se lee más veces de las que se escribe.

```python
import this   # muestra el Zen de Python en el REPL
```

> Esta filosofía se refleja en la guía de estilo **PEP 8**: nombres en `snake_case`, 4 espacios de indentación, líneas de ≤79 caracteres, etc.

### Instalación y entorno

Python 3 suele venir instalado en Linux y macOS. En Windows se instala desde [python.org](https://www.python.org/downloads/) marcando la casilla "Add Python to PATH".

Verificar que está instalado y qué versión tenemos:

```bash
python3 --version        # p. ej. Python 3.12.3
which python3            # ruta del ejecutable
```

Ejecutar un script: el código se guarda en archivos `.py` y se pasa el nombre del archivo al intérprete:

```bash
python3 main.py
python3 path/al/script.py
```

El **REPL** (Read-Eval-Print Loop) es el modo interactivo que se abre al ejecutar `python3` sin argumentos. Permite probar expresiones al vuelo:

```bash
$ python3
>>> 2 + 2
4
>>> print("Hola desde el REPL")
Hola desde el REPL
>>> exit()        # o Ctrl+D
```

Otra forma de ejecutar fragmentos sin crear un archivo:

```bash
python3 -c "print('código en una línea')"   # fragmento directo
```

> En esta ruta, cada ejercicio tiene un `main.py` con la solución. Se ejecuta igual: `python3 main.py`.

### Sintaxis básica

#### Indentación

Python usa la **indentación** para delimitar bloques en lugar de llaves `{}`. Todos los niveles de un bloque deben usar la misma indentación; la convención PEP 8 es **4 espacios**. No hace falta `;` al final de línea: el salto de línea separa sentencias.

```python
if 5 > 2:
    print("Cinco es mayor que dos")   # indentado: dentro del bloque
    print("También dentro del bloque")
print("Fuera del bloque")             # sin indentar: fuera del if
```

Mezclar tabulaciones y espacios produce `TabError`; ser inconsistente produce `IndentationError`.

#### Comentarios y docstrings

- `#` comenta hasta el final de la línea.
- Los **docstrings** (`"""..."""`) documentan módulos, funciones y clases; se consultan con `help()`.

```python
# Esto es un comentario de una línea
print("Hola")   # los comentarios pueden ir al final de la línea

"""Este es un docstring de varias líneas.
Suele usarse para documentar archivos, funciones y clases.
"""
```

#### Entrada y salida (I/O)

- `print(*valores, sep=" ", end="\n")` imprime en consola; acepta varios argumentos separados por comas y permite configurar separador y final de línea.
- `input(prompt)` muestra el *prompt* y devuelve el texto tecleado. **Siempre** devuelve un `str`, aunque se escriba un número.

```python
nombre = input("¿Cómo te llamas? ")
print("Hola,", nombre)
print("Un", "mensaje", "con", "espacios", sep="-")   # Un-mensaje-con-espacios
print("Sin salto de línea", end="")
```

### Variables y tipos de datos

Python es de **tipado dinámico**: la variable adopta el tipo del valor asignado y puede reasignarse con otro tipo (aunque no suele ser buena práctica). Los nombres se escriben en **`snake_case`**; las constantes, por convención, en MAYÚSCULAS.

| Tipo | Descripción | Ejemplo |
|---|---|---|
| `int` | número entero | `42`, `-7`, `1_000_000` |
| `float` | número con decimales | `3.14`, `-0.5`, `2.0` |
| `str` | texto (inmutable) | `"hola"`, `'adiós'`, `"""varias líneas"""` |
| `bool` | `True` o `False` | `True`, `5 > 2` |
| `None` | ausencia de valor (≈ `null`) | `None` |

```python
nombre = "Ana"
edad = 30
altura = 1.68
es_programadora = True
sin_valor = None

print(type(nombre))            # <class 'str'>
print(type(edad))              # <class 'int'>
print(type(altura))            # <class 'float'>
print(type(es_programadora))   # <class 'bool'>
print(type(sin_valor))         # <class 'NoneType'>
```

Detalles a tener en cuenta:

- **Los enteros no tienen límite de tamaño** en Python: `2 ** 100` funciona sin desbordamiento.
- `1_000_000` es el mismo número que `1000000` (separador de millares).
- `None` es el único valor del tipo `NoneType`; se compara con `is None`.
- Las estructuras de datos (`list`, `tuple`, `dict`, `set`) se ven con profundidad en la guía 03.

#### Conversión de tipos

Las funciones `int()`, `float()`, `str()` y `bool()` convierten entre tipos. Es imprescindible para procesar lo que devuelve `input()` (siempre un `str`).

```python
n = int("42")          # 42    (str -> int)
pi = float("3.14")     # 3.14  (str -> float)
texto = str(100)       # "100" (int -> str)
entero = int(3.99)     # 3     (float -> int: trunca, no redondea)
print(int("101", 2))   # 5     (interpreta el string en base 2)
print(bool(""))        # False
print(bool("hola"))    # True
```

> Si el texto no se puede convertir (p. ej. `int("hola")`) se lanza un `ValueError`. Por eso conviene validar la entrada; en el nivel 02 se usa `raise` para gestionarlo.

### Operadores

#### Aritméticos

| Operador | Operación | Ejemplo | Resultado |
|---|---|---|---|
| `+` | suma | `7 + 3` | `10` |
| `-` | resta | `7 - 3` | `4` |
| `*` | multiplicación | `7 * 3` | `21` |
| `/` | **división real** | `10 / 4` | `2.5` |
| `//` | división entera | `10 // 4` | `2` |
| `%` | módulo (resto) | `10 % 4` | `2` |
| `**` | potencia | `2 ** 10` | `1024` |

El operador `+` también concatena `str` y `*` repite strings:

```python
print("hola " + "mundo")   # hola mundo
print("ha" * 3)            # hahaha
```

> `+` entre un `str` y un `int` lanza `TypeError`: primero hay que convertir.

#### Comparación

`== != < > <= >=` devuelven siempre un `bool`:

```python
print(5 == 5)        # True
print(5 != "5")      # True (tipos distintos: int vs str)
print(3 < 4 <= 4)    # True (comparación encadenada)
```

#### Lógicos

`and`, `or` y `not` combinan condiciones. Se evalúan en cortocircuito: si el resultado ya está decidido, no se evalúa el resto.

```python
edad = 20
tiene_carnet = True
print(edad >= 18 and tiene_carnet)   # True
print(edad < 18 or tiene_carnet)     # True
print(not tiene_carnet)              # False
```

#### Asignación

`= += -= *= /= //= %= **=` modifican el valor de la variable:

```python
total = 10
total += 5        # total = total + 5 → 15
total *= 2        # 30
total //= 4       # 7
```

#### Precedencia y paréntesis

De mayor a menor: paréntesis `()`, `**`, `* / // %`, `+ -`, comparaciones, `not`, `and`, `or`. Ante la duda, usa paréntesis: el código queda más claro.

```python
print(2 + 3 * 4)          # 14 (la multiplicación va primero)
print((2 + 3) * 4)        # 20
print(not True or False)  # False (not se evalúa antes que or)
```

### F-strings (interpolación de texto)

Los **f-strings** (prefijo `f` antes de las comillas) interpolan expresiones entre `{}` y son la forma recomendada de construir texto:

```python
nombre = "Ana"
edad = 30
print(f"Hola, soy {nombre} y tengo {edad} años.")
print(f"En 5 años tendré {edad + 5}.")          # cualquier expresión
print(f"Pi con 2 decimales: {3.14159:.2f}")     # formato de número
```

Formato dentro de las llaves (`{valor:especificador}`):

```python
precio = 1234.5678
print(f"{precio:.2f}")     # 1234.57    (2 decimales)
print(f"{precio:,.0f}")    # 1,235      (separador de millares)
codigo = 42
print(f"{codigo:05d}")     # 00042      (rellena con ceros)
print(f"{precio:10.2f}")   # '   1234.57' (ancho mínimo 10)
```

Alineación de texto (izquierda `<`, derecha `>`, centrado `^`):

```python
print(f"{'izquierda':<10}|")   # 'izquierda '  → a la izquierda
print(f"{'derecha':>10}|")     # '   derecha'  → a la derecha
print(f"{'centro':^10}|")      # '  centro  '  → centrado
```

> Desde Python 3.12 también existen los f-strings multilínea y mayor flexibilidad con comillas.

### Condicionales

`if`, `elif` y `else` evalúan valores de verdad. Se pueden encadenar tantos `elif` como se necesite.

```python
nota = 85
if nota >= 90:
    print("Excelente")
elif nota >= 70:
    print("Aprobado")
else:
    print("Reprobado")
```

**Valores *truthy* y *falsy*:** se consideran falsos `0`, `0.0`, `""` (y strings vacíos), `[]`, `{}`, `()`, `None` y `False`. Todo lo demás es verdadero.

```python
nombre = input("Nombre (vacío para saltar): ")
if nombre:            # si el string no está vacío
    print(f"Hola, {nombre}")
else:
    print("Sin nombre.")
```

**Comparación encadenada** permite comprobar rangos de forma natural:

```python
x = 7
if 0 < x < 10:
    print("x está entre 0 y 10")
if x % 2 == 0:
    print("x es par")
```

**Operador ternario** devuelve un valor en una sola expresión:

```python
nota = 55
resultado = "aprueba" if nota >= 60 else "reprueba"
print(resultado)          # reprueba
```

> Python 3.10+ añade `match/case` (similar a `switch`). Se verá en niveles posteriores; un vistazo:

```python
dia = "sábado"
match dia:
    case "sábado" | "domingo":
        print("Fin de semana")
    case _:
        print("Día laboral o desconocido")
```

### Bucles

#### `for` con `range`

`range(inicio, fin, paso)` genera enteros; **el fin no se incluye**:

```python
for i in range(3):           # 0, 1, 2
    print(i)

for i in range(2, 8, 2):     # 2, 4, 6
    print(i)

for i in range(5, 0, -1):    # 5, 4, 3, 2, 1
    print(i)
```

`for` también itera sobre cualquier secuencia (strings, listas, diccionarios...):

```python
for fruta in ["manzana", "pera", "uva"]:
    print(fruta)

for letra in "Python":
    print(letra)
```

#### `while`

Repite mientras la condición sea verdadera:

```python
n = 0
suma = 0
while n <= 10:
    suma += n
    n += 1
print(suma)   # 55 (suma del 0 al 10)
```

Cuidado con los **bucles infinitos**: si la condición nunca se vuelve falsa, el bucle no termina. `Ctrl+C` detiene el programa.

#### `break`, `continue` y `else`

- `break` corta el bucle inmediatamente.
- `continue` salta a la siguiente iteración.
- El bloque `else` de un bucle se ejecuta solo si el bucle termina **sin** `break`.

```python
for i in range(10):
    if i == 3:
        continue          # se salta el 3
    if i == 6:
        break             # corta en el 6
    print(i)              # 0, 1, 2, 4, 5

# else con for: buscar un valor
numeros = [4, 7, 1, 9]
buscar = 7
for n in numeros:
    if n == buscar:
        print(f"Encontrado: {n}")
        break
else:
    print("No estaba en la lista")
```

#### `enumerate`

Devuelve parejas `(índice, valor)` al recorrer una secuencia:

```python
nombres = ["Ana", "Luis", "Sara"]
for posicion, nombre in enumerate(nombres):
    print(f"{posicion}: {nombre}")
# 0: Ana
# 1: Luis
# 2: Sara

for posicion, nombre in enumerate(nombres, start=1):
    print(f"{posicion}. {nombre}")   # 1. Ana ...
```

### Strings

Los strings son **inmutables**: los métodos devuelven un *nuevo* string y nunca modifican el original.

| Método | Qué hace | Ejemplo | Resultado |
|---|---|---|---|
| `upper()` | todo en mayúsculas | `"Ana".upper()` | `"ANA"` |
| `lower()` | todo en minúsculas | `"Ana".lower()` | `"ana"` |
| `title()` | mayúscula inicial por palabra | `"hola mundo".title()` | `"Hola Mundo"` |
| `capitalize()` | mayúscula inicial | `"hola mundo".capitalize()` | `"Hola mundo"` |
| `strip()` | elimina espacios extremos | `"  x  ".strip()` | `"x"` |
| `split(sep)` | divide por un separador | `"a,b,c".split(",")` | `["a","b","c"]` |
| `join(lista)` | une elementos con separador | `"-".join(["a","b"])` | `"a-b"` |
| `replace(a, b)` | sustituye ocurrencias | `"aa".replace("a","b")` | `"bb"` |
| `count(sub)` | nº de apariciones | `"banana".count("an")` | `2` |
| `find(sub)` | posición de la subcadena (`-1` si no existe) | `"hola mundo".find("mundo")` | `5` |
| `startswith(x)` | ¿empieza por? | `"Ana".startswith("A")` | `True` |
| `endswith(x)` | ¿termina por? | `"Ana".endswith("a")` | `True` |
| `isdigit()` | ¿solo dígitos? | `"42".isdigit()` | `True` |
| `isalpha()` | ¿solo letras? | `"abc".isalpha()` | `True` |
| `zfill(n)` | rellena con ceros a la izquierda | `"42".zfill(5)` | `"00042"` |

> `len()` es una **función**, no un método: `len("hola")` → `4`.

#### Índices y slicing

Se accede por posición con `[índice]` (empezando en 0; índices negativos cuentan desde el final). El *slicing* `[inicio:fin:paso]` extrae porciones; **el fin no se incluye**:

```python
s = "Python"
print(s[0])      # 'P'
print(s[-1])     # 'n'  (último carácter)
print(s[0:4])    # 'Pyth' (de 0 a 3)
print(s[2:])     # 'thon' (de 2 al final)
print(s[:3])     # 'Pyt'  (del inicio a 2)
print(s[::2])    # 'Pto'  (cada 2 caracteres)
print(s[::-1])   # 'nohtyP' (invertido)
```

### Listas básicas

Las listas son secuencias **mutables** que guardan elementos de cualquier tipo (incluso mezclados):

```python
numeros = [10, 20, 30]
frutas = ["manzana", "pera", "uva"]
mixta = [1, "dos", 3.0, True]
```

Índices y slicing funcionan igual que en strings, pero las listas **sí** se pueden modificar:

```python
numeros = [10, 20, 30, 40]
print(numeros[0])       # 10
print(numeros[-1])      # 40
print(numeros[1:3])     # [20, 30]
numeros[0] = 99         # [99, 20, 30, 40]
```

Operaciones y métodos básicos:

```python
notas = [7, 9, 5, 8]
notas.append(6)         # [7, 9, 5, 8, 6]        (añade al final)
notas.insert(0, 10)     # [10, 7, 9, 5, 8, 6]    (añade en la posición 0)
notas.remove(5)         # [10, 7, 9, 8, 6]        (quita la 1ª aparición de 5)
ultimo = notas.pop()    # 6 — quita y devuelve el último
print(len(notas))       # 5  (número de elementos)
print(sum(notas))       # 34 (suma — solo números)
print(min(notas))       # 7
print(max(notas))       # 10
print(8 in notas)       # True
```

Recorrer una lista:

```python
total = 0
for nota in notas:
    total += nota
print(total)
```

Concatenación, repetición y copia (¡cuidado con las referencias!):

```python
a = [1, 2]
b = a            # b apunta a la MISMA lista
b.append(3)      # a también cambia → [1, 2, 3]

c = a.copy()     # copia independiente
c.append(99)     # a no cambia

print([1, 2] + [3, 4])   # [1, 2, 3, 4]
print([0] * 3)           # [0, 0, 0]
```

> Los `int`, `float`, `str` y `bool` se copian por valor al asignar; las listas (y otros contenedores) se comparten por referencia. Este detalle reaparece en guías posteriores.

### Métodos y funciones (vistazo)

Una **función** agrupa lógica reutilizable con `def`. Este nivel la usa para organizar los ejemplos; se profundiza en el nivel 02.

```python
def saludar(nombre):
    return f"Hola, {nombre}!"

def sumar(a, b=0):        # b tiene valor por defecto
    return a + b

print(saludar("Ana"))     # Hola, Ana!
print(sumar(3, 4))        # 7
print(sumar(3))           # 3 (usa b=0)
```

## Ejemplos de código

```python
# Tabla de multiplicar con f-strings
numero = 7
for i in range(1, 11):
    print(f"{numero} x {i} = {numero * i}")
```

```python
# Clasificador de números
def clasificar(n):
    if n % 2 == 0:
        return f"{n} es par"
    return f"{n} es impar"

print(clasificar(10))   # 10 es par
print(clasificar(7))    # 7 es impar
```

```python
# Conversor de temperatura con entrada del usuario
celsius = float(input("Temperatura en °C: "))
fahrenheit = celsius * 9 / 5 + 32
print(f"{celsius} °C son {fahrenheit:.1f} °F")
```

```python
# Contador de palabras con métodos de strings
frase = input("Escribe una frase: ")
palabras = frase.strip().lower().split()
print(f"Tienes {len(palabras)} palabras.")
```

```python
# Notas: media y máximo con listas
notas = []
while True:
    entrada = input("Nota (o 'fin' para terminar): ")
    if entrada == "fin":
        break
    notas.append(float(entrada))

if notas:
    print(f"Media: {sum(notas) / len(notas):.2f}")
    print(f"Máximo: {max(notas)}")
else:
    print("No se introdujo ninguna nota.")
```

## Cómo se relaciona con los ejercicios

Esta guía es la base teórica de los seis ejercicios del nivel 01. Cada uno practica una sección de estos apuntes:

| Ejercicio | Contenido de la guía que se aplica |
|---|---|
| [Ejercicio 01 — Variables y tipos](../ejercicios/nivel-01-fundamentos/ejercicio-01-variables-y-tipos/) | variables, `type()`, f-strings, conversiones |
| [Ejercicio 02 — Operadores y condicionales](../ejercicios/nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales/) | operadores, `if/elif/else`, ternario |
| [Ejercicio 03 — Strings](../ejercicios/nivel-01-fundamentos/ejercicio-03-strings/) | métodos de strings, slicing, f-strings |
| [Ejercicio 04 — Listas básicas](../ejercicios/nivel-01-fundamentos/ejercicio-04-listas-basicas/) | listas, `append`, índices, slicing |
| [Ejercicio 05 — Bucles](../ejercicios/nivel-01-fundamentos/ejercicio-05-bucles/) | `for`, `while`, `range`, `break`, `continue` |
| [Ejercicio 06 — Diccionarios básicos](../ejercicios/nivel-01-fundamentos/ejercicio-06-diccionarios-basicos/) | `dict`, `get`, `items`, iteración (estructura de datos; guía 03) |

Cada ejercicio tiene un `main.py` (solución) y un `test_main.py` (runner de tests). Para ejecutarlos: `python3 main.py` y `python3 -m pytest test_main.py`.

## Errores comunes

- **Indentación inconsistente** → `IndentationError` (o `TabError` si se mezclan tabulaciones y espacios). Todos los bloques deben usar la misma indentación (4 espacios).

  ```python
  # ❌
  if 5 > 2:
      print("dentro")
        print("otra vez dentro")   # 6 espacios

  # ✅
  if 5 > 2:
      print("dentro")
      print("otra vez dentro")
  ```

- **Olvidar los dos puntos** → `SyntaxError` al escribir `if x > 2` sin el `:`.

  ```python
  # ❌ if x > 2          → SyntaxError: falta ":"
  # ✅
  if x > 2:
      print("mayor")
  ```

- **Sumar `str` y `int`** → `TypeError`. `input()` siempre devuelve texto; conviértelo antes de operar.

  ```python
  # ❌
  edad = input("Edad: ")
  print("Año que viene:", edad + 1)   # TypeError

  # ✅
  edad = int(input("Edad: "))
  print("Año que viene:", edad + 1)
  ```

- **Comparar sin convertir** → falla sin error aparente: `"10" > 5` lanza `TypeError` en Python 3 y `"10" == 10` devuelve `False` aunque "parezca" lo mismo.

  ```python
print("10" == 10)   # False (tipos distintos)
  ```
- **Usar `=` en vez de `==`** → asignación en lugar de comparación.

  ```python
  # ❌ if x = 5:      → SyntaxError: asignación dentro de una condición
  # ✅
  if x == 5:
      print("es cinco")
  ```

- **Confundir `/` con `//`** → `10 / 4` es `2.5` (división real); `10 // 4` es `2` (división entera).

- **Índices fuera de rango** → `IndexError`. El índice del último elemento de una secuencia de `n` elementos es `n - 1`.

  ```python
  # ❌
  numeros = [10, 20]
  print(numeros[2])   # → IndexError

  # ✅
  numeros = [10, 20]
  print(numeros[1])   # → 20
  ```

- **Intentar modificar un string** → `TypeError`, porque los strings son inmutables.

  ```python
  # ❌ s = "hola"; s[0] = "H"
  # ✅ s = "H" + s[1:]
  ```

- **Copiar una lista con `=`** → ambas variables apuntan a la misma lista; usar `copy()`.

  ```python
  # ❌
  a = [1, 2]
  b = a
  b.append(3)        # a también cambia

  # ✅
  a = [1, 2]
  b = a.copy()
  b.append(3)        # a sigue siendo [1, 2]
  ```

- **Llamar a `print` como en otros lenguajes** → en Python `print` es una función: `print("hola")`, no `print "hola"` (eso es sintaxis de Python 2).

- **Bucle `while` sin avance** → bucle infinito si la condición nunca cambia.

  ```python
  # ❌
  n = 1
  while n <= 10:
      print(n)      # n nunca cambia → infinito

  # ✅
  n = 1
  while n <= 10:
      print(n)
      n += 1
  ```

## Recursos

- [Python.org — Tutorial oficial](https://docs.python.org/es/3/tutorial/)
- [Python.org — Documentación en español](https://docs.python.org/es/3/)
- [Real Python — Python Basics](https://realpython.com/tutorials/python-basics/)
- [W3Schools — Python](https://www.w3schools.com/python/)
- [Python download](https://www.python.org/downloads/)