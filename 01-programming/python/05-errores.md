# 05 — Errores en Python

## Objetivos

- [ ] Diferenciar errores de sintaxis, excepciones en tiempo de ejecución y errores lógicos.
- [ ] Conocer la jerarquía de excepciones (`BaseException` → `Exception` → subclases).
- [ ] Identificar las excepciones estándar más comunes y en qué situación se lanzan.
- [ ] Manejar excepciones con `try`, `except`, `else` y `finally`.
- [ ] Capturar múltiples tipos de excepción y el objeto de error con `as e`.
- [ ] Re-lanzar excepciones con `raise` desnudo preservando el traceback original.
- [ ] Lanzar excepciones con `raise` y encadenarlas con `raise ... from`.
- [ ] Definir excepciones personalizadas con atributos propios.
- [ ] Usar `assert` como herramienta de desarrollo (y saber cuándo no).
- [ ] Aplicar el estilo EAFP y compararlo con LBYL.
- [ ] Depurar programas con tracebacks, `print` estratégico, `pdb` y `logging`.
- [ ] Controlar avisos con `PYTHONWARNINGS`.

## Apuntes

### Errores de sintaxis, excepciones y errores lógicos

No todos los "errores" en Python son iguales. Distinguirlos es el primer paso para arreglarlos:

| Tipo | Cuándo aparece | Ejemplo | Quién lo detecta |
|---|---|---|---|
| `SyntaxError` | El código no es válido como programa (falta `:`, paréntesis sin cerrar, indentación incorrecta, `=` en vez de `==`) | `if x > 5 print(x)` | El intérprete, **antes** de ejecutar nada |
| Excepción en runtime | El programa es válido pero una operación falla durante la ejecución | `1 / 0`, `int("abc")`, `lista[10]` | El intérprete, en el punto exacto donde falla |
| Error lógico | El programa corre sin errores pero hace algo distinto de lo que se espera | `if a = b:` en vez de `if a == b`, `x + y` cuando debía ser `x - y` | Solo el programador (y los tests) |

```python
# print("hola"   <- SyntaxError: el intérprete ni siquiera empieza
print(1 / 0)     # ZeroDivisionError en tiempo de ejecución
```

Un `SyntaxError` es el único que **no se puede capturar con `try/except`**: ocurre al parsear, antes de que el programa exista. Un error lógico tampoco lanza nada — no hay traceback que te apunte —, por eso es el más difícil de encontrar.

### Jerarquía de excepciones

Todas las excepciones de Python son clases, y heredan unas de otras. Todo cuelga de `BaseException`, pero **nunca debes capturar ni lanzar `BaseException` directamente** (más abajo, en "Errores comunes").

```text
BaseException
├── SystemExit                # sys.exit()
├── KeyboardInterrupt         # Ctrl+C
├── GeneratorExit             # cierre de un generador
└── Exception                 # ← captura y lanza SIEMPRE a partir de aquí
    ├── ArithmeticError
    │   ├── FloatingPointError
    │   ├── OverflowError
    │   └── ZeroDivisionError
    ├── AssertionError
    ├── AttributeError
    ├── ImportError
    │   └── ModuleNotFoundError
    ├── LookupError
    │   ├── IndexError
    │   └── KeyError
    ├── NameError
    ├── OSError                # base de errores del sistema
    │   ├── FileNotFoundError
    │   └── PermissionError
    ├── RuntimeError
    │   ├── RecursionError
    │   └── NotImplementedError
    ├── StopIteration
    ├── TypeError
    └── ValueError
```

Por qué importa la jerarquía:

- **Capturar una clase captura también a sus hijas.** `except ArithmeticError` atrapa `ZeroDivisionError`, `OverflowError`, etc. Es la base del "atrapa lo más específico que puedas".
- **El orden de los `except` importa**: Python revisa los `except` de arriba hacia abajo y ejecuta el **primero** que coincida. Si pones `except Exception` antes de `except ValueError`, el de `ValueError` jamás se alcanzará (es un error común, ver al final).

```python
try:
    x = int("no numérico")
except Exception:          # ❌ demasiado amplio y además ANTES que el específico
    print("cualquier cosa")
except ValueError:
    print("esto nunca se ejecuta")
```

### Excepciones estándar comunes

| Excepción | Se lanza cuando... | Ejemplo |
|---|---|---|
| `ZeroDivisionError` | divides por cero | `10 / 0` |
| `ValueError` | el tipo es correcto pero el valor no es apropiado | `int("abc")`, `int("12.5")` |
| `TypeError` | una operación no admite esos tipos | `"hola" + 1`, `len(42)` |
| `IndexError` | un índice de secuencia está fuera de rango | `[1, 2, 3][10]` |
| `KeyError` | una clave no existe en el diccionario | `{"a": 1}["b"]` |
| `AttributeError` | el objeto no tiene ese atributo o método | `"texto".append(1)`, `None.upper()` |
| `FileNotFoundError` | no existe el archivo que se intenta abrir | `open("no-existe.txt")` |
| `PermissionError` | no hay permisos para abrir/crear el archivo | `open("/root/x")` como usuario normal |
| `StopIteration` | un iterador ya no tiene más elementos | `next(iter([]))` |
| `ImportError` | un `import` o `from ... import` falla | `import modulo_inexistente` |
| `ModuleNotFoundError` | (hija de `ImportError`) no existe el módulo | `import numpy` sin tenerlo instalado |
| `NameError` | usas un nombre que no está definido | `print(contador)` sin definir `contador` |
| `RuntimeError` | error genérico de estado en el runtime | modificar un `dict` mientras se itera sobre él |
| `NotImplementedError` | (hija de `RuntimeError`) método que debe implementar una subclase | método abstracto "en bruto" |
| `RecursionError` | la recursión supera el límite de profundidad | función recursiva sin caso base |
| `OverflowError` | el resultado es demasiado grande para el tipo | `math.exp(1000)` |
| `UnicodeDecodeError` | bytes no decodificables con la codificación indicada | abrir un archivo con la codificación equivocada |
| `AssertionError` | una condición de `assert` es falsa | `assert x > 0` con `x = -1` |

La regla práctica: **si no sabes qué excepción lanza una función, la documentación o un intento con `python3 -c` te lo dicen**, y el traceback siempre te enseña el nombre exacto de la clase.

### `try` / `except` / `else` / `finally` en profundidad

La sentencia completa tiene hasta cuatro bloques:

```python
try:
    # 1. código que puede fallar
    resultado = 10 / divisor
except ZeroDivisionError:
    # 2. se ejecuta SOLO si ocurre esa excepción
    resultado = 0
else:
    # 3. se ejecuta SOLO si NO hubo ninguna excepción
    print(f"División ok: {resultado}")
finally:
    # 4. se ejecuta SIEMPRE (con o sin excepción, incluso con return)
    print("Fin del bloque")
```

#### Múltiples `except`

Captura cada tipo por separado y en orden del más específico al más general:

```python
try:
    datos = [1, 2, 3]
    print(datos[10])      # lanza IndexError
    x = 10 / 0            # no llega a ejecutarse
except ZeroDivisionError:
    print("No se puede dividir entre cero")
except IndexError:
    print("Índice fuera de rango")
except ValueError:
    print("Valor inválido")
```

#### Capturar el objeto (`as e`) y varios tipos

`as e` enlaza el objeto de la excepción (mensaje y atributos); una tupla de tipos captura varios con el mismo tratamiento:

```python
try:
    edad = int("abc")
except ValueError as e:
    print(type(e).__name__)   # ValueError
    print(e)                  # invalid literal for int() with base 10: 'abc'

try:
    registro = datos["cliente"]["telefono"]
except (KeyError, IndexError) as e:
    print(f"Clave o índice inexistente: {e}")
```

#### `else`

Solo se ejecuta si **no** hubo excepción. Sirve para separar el código que puede fallar de lo que se hace cuando todo salió bien, evitando capturar errores del propio manejo:

```python
try:
    numero = int(texto)
except ValueError:
    numero = 0
else:
    print(f"Conversión limpia, número: {numero}")
```

#### `finally`

Se ejecuta **siempre**, aunque haya `return` en el `try` o en un `except`, y aunque se lance otra excepción. Es el lugar natural para liberar recursos cuando no usas `with`:

```python
f = open("datos.txt")
try:
    contenido = f.read()
finally:
    f.close()          # se cierra pase lo que pase
```

#### Re-lanzar con `raise` desnudo

Dentro de un `except`, un `raise` sin argumentos **re-lanza la misma excepción** intacta: conserva el traceback original y el tipo. Es útil para registrar en una capa y dejar que la excepción siga subiendo:

```python
def convertir(texto):
    try:
        return int(texto)
    except ValueError:
        print("Conversión fallida — re-lanzo al llamador")
        raise                # el llamador decide qué hacer

# convertir("abc")  # imprime el aviso y lanza ValueError hacia arriba
```

#### Patrones de `try`/`except`: cuándo usar cada uno

| Patrón | Qué consigue | Cuándo usarlo |
|---|---|---|
| `try/except` y sigues | el error se maneja y el flujo continúa | errores **esperables** (entrada de usuario, archivo que puede faltar) |
| `except` + `raise` desnudo | registrar/limpiar y propagar intacto | capas intermedias que no saben cómo resolver el error |
| `except ... as e` + `raise ... from e` | cambiar de tipo añadiendo contexto | convertir el error de una librería en un error de tu dominio |
| `try/else` | distinguir "pudo fallar" de "funcionó" | validación + uso del valor validado |
| `try/finally` o `with` | garantizar limpieza | recursos (archivos, conexiones, locks) |

### Lanzar excepciones: `raise`

Creas una excepción (con mensaje) y la lanzas con `raise`. El mensaje debe explicar **qué pasó y por qué**:

```python
def dividir(a, b):
    if b == 0:
        raise ValueError("El divisor no puede ser cero")
    return a / b
```

#### `raise ... from e` (encadenado)

Cuando una excepción es la **causa** de otra, `from e` las encadena: el traceback muestra la cadena completa y el `except` superior accede a la causa con `e.__cause__`. Es clave en capas que traducen errores de librerías al lenguaje del dominio:

```python
def cargar_config(ruta):
    try:
        with open(ruta) as f:
            return f.read()
    except FileNotFoundError as e:
        raise RuntimeError(f"No se pudo cargar la configuración en {ruta}") from e
```

Si quieres ocultar la causa (rara vez es buena idea), usa `from None`.

#### Excepciones personalizadas

Heredan de `Exception` (o de una subclase más específica, como `ValueError`) y pueden llevar atributos propios:

```python
class SaldoInsuficienteError(Exception):
    """Error cuando no hay saldo suficiente para un retiro."""

    def __init__(self, saldo, cantidad):
        super().__init__(f"Saldo insuficiente: retiro de {cantidad} con saldo {saldo}")
        self.saldo = saldo
        self.cantidad = cantidad


def retirar(saldo, cantidad):
    if cantidad > saldo:
        raise SaldoInsuficienteError(saldo, cantidad)
    return saldo - cantidad


try:
    retirar(100, 150)
except SaldoInsuficienteError as e:
    print(f"Te faltan {e.cantidad - e.saldo}")   # accede a los atributos
```

Buenas prácticas:

- Nombra terminando en `Error`, deriva de `Exception` (o de una más específica) y envía un mensaje claro y **accionable** con el contexto necesario.
- Puedes usar una jerarquía propia: `class ErrorDePago(ErrorAplicacion)`, etc. Esto permite al llamador capturar tu base o cada caso concreto.
- Lanza excepciones para **casos excepcionales**, no para control de flujo normal (eso es lo que son los condicionales).

### `assert` como herramienta de desarrollo

`assert condicion, mensaje` verifica un invariante y lanza `AssertionError` si es falso. Es una **herramienta de desarrollo**: documenta suposiciones y detecta bugs temprano.

```python
def raiz_cuadrada(x):
    assert x >= 0, "x debe ser no negativa"
    return x ** 0.5
```

**Por qué NO usarlo para validar entradas de usuario:**

1. **Se puede desactivar**: al ejecutar con `python3 -O` (optimizar), todos los `assert` se eliminan. Tu validación desaparecería en producción.
2. **No es manejable**: `AssertionError` no es un error de dominio, y su mensaje es para el programador, no para el usuario final.

Para validar entrada se usa `raise ValueError(...)` (o una excepción propia):

```python
def registrar_edad(edad):
    if not isinstance(edad, int):
        raise ValueError("La edad debe ser un número entero")
    if not 0 <= edad <= 130:
        raise ValueError(f"Edad fuera de rango: {edad}")
    return f"Edad registrada: {edad}"
```

### EAFP vs LBYL

Dos filosofías para lidiar con operaciones que pueden fallar:

| | LBYL — Look Before You Leap | EAFP — Easier to Ask for Forgiveness than Permission |
|---|---|---|
| Enfoque | **Verificas** las condiciones antes de operar | **Intentas** la operación y capturas el error |
| Ventaja | Flujo explícito, sin "saltos" | Idiomático en Python; no hay carreras entre verificar y usar |
| Riesgo | Doble trabajo (validas y luego usas), condiciones que se escapan | Hay que capturar los tipos correctos |

```python
# LBYL
def convertir_lbyl(texto):
    if isinstance(texto, str) and texto.isdigit():
        return int(texto)
    return 0

# EAFP (idiomático en Python)
def convertir_eafp(texto):
    try:
        return int(texto)
    except (ValueError, TypeError):
        return 0
```

En Python, EAFP es el estilo preferido: `try/except` es barato si no hay excepción y evita el "comprobé pero seguía mal" (p. ej. entre `isdigit()` y `int()`). LBYL sigue siendo útil cuando el fallo es raro y caro de capturar, o cuando quieres evitar efectos secundarios.

### Depuración

#### Lectura de tracebacks

El traceback es un mapa del error. Se lee **de abajo hacia arriba**:

```text
Traceback (most recent call last):
  File "demo.py", line 11, in <module>
    nivel1()
  File "demo.py", line 9, in nivel1
    return nivel2()
  File "demo.py", line 6, in nivel2
    return nivel3()
  File "demo.py", line 3, in nivel3
    return 1 / 0
ZeroDivisionError: division by zero
```

- **Línea inferior**: el tipo de la excepción y su mensaje. Es lo que *sabemos* que falló.
- **Cada bloque `File ... in ...`**: un *frame* de la pila de llamadas; `line N` es la línea exacta y el código a la derecha es su contenido.
- El error **se origina en el frame más profundo** (aquí, `nivel3`, línea 3) y sube por `nivel2` → `nivel1` → `<module>`. La línea 11 no es la causa: es solo el punto de entrada. Empieza siempre por el frame más abajo; si hay `raise ... from`, verás dos tracebacks unidos por *"The above exception was the direct cause..."* con la cadena completa.

#### `print` estratégico

Para flujos simples, imprimir valores intermedios es la herramienta más rápida (cero setup):

```python
def promedio(numeros):
    total = sum(numeros)
    print(f"DEBUG total={total} len={len(numeros)}")   # temporal
    return total / len(numeros)
```

Consejos: imprime **qué** es cada valor (`f"total={total}"`), no solo el valor; márcalos con `DEBUG` para encontrarlos y borrarlos después; cuando necesites más control, pasa a `pdb` o `logging`.

#### `pdb` — depurador interactivo

Pausa el programa en un punto y te deja inspeccionar el estado paso a paso. Tienes dos formas de entrar:

```bash
python3 -m pdb script.py     # entra al depurador desde el inicio
```

```python
def dividir(a, b):
    breakpoint()              # Python 3.7+ (antes: pdb.set_trace() con import pdb)
    return a / b
```

Comandos esenciales:

| Comando | Acción |
|---|---|
| `n` (next) | ejecuta la línea actual sin entrar en funciones |
| `s` (step) | entra en la función llamada |
| `c` (continue) | continúa hasta el siguiente breakpoint |
| `l` (list) | muestra el código alrededor de la línea actual |
| `p expresión` | evalúa e imprime una expresión (`p x`, `p len(datos)`) |
| `pp expresión` | imprime con formato legible (diccionarios, listas grandes) |
| `w` (where) | muestra dónde estás en la pila de llamadas |
| `u` / `d` (up/down) | sube/baja por la pila de llamadas |
| `q` (quit) | sale del depurador (aborta) |

En `pdb` también puedes ejecutar código Python normal mientras estás pausado, para probar hipótesis sin modificar el archivo.

#### `logging` — registros con niveles

Cuando el programa crece, los `print` de depuración se vuelven ruido. El módulo estándar `logging` imprime con **niveles** (`DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`), marca la hora y se configura sin tocar el código:

```python
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)s %(message)s",
)

def procesar(nombre):
    logging.info("Procesando %r", nombre)
    try:
        return int(nombre)
    except ValueError:
        logging.error("No se pudo convertir %r", nombre)
        return None
```

Dos detalles: el formato `%r`/`%s` con argumentos (en lugar de f-strings) retrasa el formateo hasta emitir el registro, y subir `level` a `INFO` oculta los `DEBUG` sin tocar el código. En el ejercicio del nivel 04 con `argparse` verás una CLI bien instrumentada.

#### `PYTHONWARNINGS`

Controla cómo se muestran los avisos del módulo `warnings` (deprecaciones, clases sin `__slots__`, etc.), no los errores:

```bash
PYTHONWARNINGS=error python3 script.py    # los avisos se tratan como excepciones
PYTHONWARNINGS=ignore python3 script.py   # silencia los avisos
```

En código también puedes filtrarlos:

```python
import warnings
warnings.simplefilter("error", DeprecationWarning)
warnings.warn("Esto quedará obsoleto", DeprecationWarning)
```

#### Comparativa de herramientas de depuración

| Herramienta | Cuándo usarla | Ventaja | Coste |
|---|---|---|---|
| `print` | seguimiento rápido de un flujo simple | cero setup, visible al instante | hay que borrarlo; no escala |
| `logging` | programas medianos/grandes, producción | niveles, marcas de tiempo, configuración sin tocar código | más setup inicial |
| `pdb` / `breakpoint()` | entender un fallo concreto de forma interactiva | inspeccionas y mutas el estado en vivo | pausa la ejecución; requiere interacción |
| `PYTHONWARNINGS` | cazar deprecaciones y avisos ignorados | actúa sobre todo el programa a la vez | solo cubre avisos, no errores |

### Context managers (relacionado)

La sentencia `with` garantiza la limpieza de recursos aunque haya excepciones, y es la forma idiomática de manejar archivos (equivalente a un `try/finally` "empaquetado" en el objeto):

```python
with open("datos.txt", "r") as f:
    contenido = f.read()
# el archivo se cierra automáticamente, incluso si hay una excepción
```

Lo profundizarás en el ejercicio de context managers del nivel 04.

## Ejemplos de código

```python
# Apertura de archivo robusta con todos los bloques
nombre_archivo = "no-existe.txt"
try:
    with open(nombre_archivo, "r") as f:
        contenido = f.read()
except FileNotFoundError:
    print(f"El archivo {nombre_archivo} no existe")
except PermissionError:
    print(f"Sin permisos para leer {nombre_archivo}")
else:
    print(f"Leídos {len(contenido)} caracteres")
finally:
    print("Fin del intento")
```

```python
# Validación con excepción personalizada con atributos
class EdadInvalidaError(Exception):
    def __init__(self, edad, mensaje):
        super().__init__(mensaje)
        self.edad = edad


def registrar_edad(edad):
    if not isinstance(edad, int):
        raise EdadInvalidaError(edad, "La edad debe ser un entero")
    if not 0 <= edad <= 130:
        raise EdadInvalidaError(edad, f"Edad fuera de rango: {edad}")
    return f"Edad registrada: {edad}"


try:
    registrar_edad(-3)
except EdadInvalidaError as e:
    print(f"Rechazada la edad {e.edad}: {e}")
```

## Ejercicios relacionados

- [Nivel 02 — Ejercicio 04: manejo de errores](../ejercicios/nivel-02-basico/ejercicio-04-manejo-de-errores/) — `try/except/else`, `ValueError`, `ZeroDivisionError`.
- [Nivel 03 — Ejercicio 05: recursión](../ejercicios/nivel-03-intermedio/ejercicio-05-recursion/) — `RecursionError` cuando falta el caso base.
- [Nivel 04 — Ejercicio 03: context managers](../ejercicios/nivel-04-avanzado/ejercicio-03-context-managers/) — `with`, `__exit__` y supresión de excepciones.
- [Nivel 04 — Ejercicio 05: testing con pytest/unittest](../ejercicios/nivel-04-avanzado/ejercicio-05-testing-con-pytest/) — verifica errores con `assertRaises`/`pytest.raises`.
- [Nivel 04 — Ejercicio 06: CLI con argparse](../ejercicios/nivel-04-avanzado/ejercicio-06-cli-con-argparse/) — argumentos inválidos y errores de línea de comandos.
- [Nivel 05 — Experto](../ejercicios/nivel-05-experto/) — proyectos que integran manejo de errores robusto y logging.

## Errores comunes

| Error | Corrección |
|---|---|
| `except:` a secas (sin tipo) | Captura tipos concretos (`except ValueError:`) o, como máximo, `except Exception`. |
| `except Exception` **antes** que tipos específicos | Ordena del más específico al más general; el primero en coincidir es el que se ejecuta. |
| `except Exception:` sin `as e` y sin usar el objeto | Usa `as e` para registrar el mensaje o los atributos; si no lo necesitas, no lo captures. |
| `except Exception: pass` (tragarse el error en silencio) | El programa sigue con estado potencialmente corrupto y sin pista de qué falló. Registra con `logging` o re-lanza con `raise`. |
| Lanzar `BaseException` (o capturarla) | `BaseException` es para `KeyboardInterrupt`/`SystemExit`. Lanza subclases de `Exception`. |
| `raise e` dentro de `except` | Reinicia el traceback y pierde el frame original. Usa `raise` desnudo. |
| `return` (o `raise`) dentro de `finally` | Sobrescribe el valor de retorno del `try` y puede enmascarar la excepción en curso. El `finally` solo debe limpiar. |
| Usar `assert` para validar entradas | `python3 -O` elimina los `assert`. Valida con `if` + `raise ValueError(...)`. |
| Lanzar `Exception` genérica con mensaje | Prefiere la excepción más específica del estándar o crea una personalizada con contexto. |
| Leer solo la última línea del traceback | El error se origina en el frame más profundo; recorre la cadena de arriba a abajo antes de decidir. |
| `try/except` para control de flujo normal | Si el "error" es un caso esperado (clave que puede faltar, archivo opcional), valóralo con condicionales o `.get()`/`dict.get()` donde tenga sentido. |

## Recursos

- [Python.org — Errores y excepciones](https://docs.python.org/es/3/tutorial/errors.html)
- [Python.org — Excepciones incorporadas](https://docs.python.org/es/3/library/exceptions.html)
- [Python.org — pdb](https://docs.python.org/es/3/library/pdb.html)
- [Python.org — logging](https://docs.python.org/es/3/library/logging.html)
- [Real Python — Python Exceptions](https://realpython.com/python-exceptions/)