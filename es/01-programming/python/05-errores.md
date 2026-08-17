# 05 — Errores en Python

## Objetivos

- [ ] Diferenciar errores de sintaxis de excepciones en tiempo de ejecución.
- [ ] Manejar excepciones con `try`, `except`, `else` y `finally`.
- [ ] Capturar múltiples tipos de excepción y el objeto de error.
- [ ] Lanzar excepciones propias con `raise` y definir excepciones personalizadas.
- [ ] Conocer las excepciones estándar más comunes.
- [ ] Depurar programas con `pdb`, `print` estratégico y lectura de tracebacks.

## Apuntes

### Errores de sintaxis vs excepciones

- **`SyntaxError`** — el código no es válido y no puede ejecutarse (falta `:`, paréntesis sin cerrar, indentación).
- **Excepciones** — el código es válido pero falla en tiempo de ejecución (`ZeroDivisionError`, `TypeError`, `ValueError`...).

```python
# print("hola"   <- SyntaxError
print(1 / 0)     # ZeroDivisionError en tiempo de ejecución
```

### try / except / else / finally

- `try` — bloque que puede fallar.
- `except` — se ejecuta si ocurre el error.
- `else` — se ejecuta si **no** hubo error (opcional).
- `finally` — se ejecuta **siempre**, haya error o no (ideal para cerrar recursos).

```python
try:
    num = int("abc")
except ValueError as e:
    print(f"Error: {e}")
else:
    print("Conversión exitosa")
finally:
    print("Siempre se ejecuta")
```

### Capturar varios tipos

Puedes capturar varios tipos en un solo `except` usando una tupla, o capturar cada tipo por separado. `as e` guarda el objeto de excepción para inspeccionarlo.

```python
try:
    datos = [1, 2, 3]
    print(datos[10])
except (IndexError, KeyError) as e:
    print(f"Índice o clave inválida: {e}")
except Exception as e:
    print(f"Otro error: {e}")
```

### raise y excepciones personalizadas

`raise` lanza una excepción manualmente. Puedes usar excepciones estándar con un mensaje o crear la tuya heredando de `Exception`.

```python
def validar_edad(edad):
    if edad < 0:
        raise ValueError("La edad no puede ser negativa")
    if edad < 18:
        raise PermissionError("Menor de edad")
    return "Acceso permitido"

print(validar_edad(20))   # Acceso permitido
```

```python
class SaldoInsuficienteError(Exception):
    pass

def retirar(saldo, cantidad):
    if cantidad > saldo:
        raise SaldoInsuficienteError(
            f"Saldo {saldo}, intentó retirar {cantidad}"
        )
    return saldo - cantidad
```

### Excepciones estándar comunes

- `ValueError` — valor correcto en tipo pero inapropiado (`int("abc")`).
- `TypeError` — operación entre tipos incompatibles (`"a" + 1`).
- `IndexError` — índice de secuencia fuera de rango.
- `KeyError` — clave inexistente en un diccionario.
- `ZeroDivisionError` — división entre cero.
- `FileNotFoundError` — abrir un archivo que no existe.
- `AttributeError` — atributo o método inexistente.
- `StopIteration` — el iterador no tiene más elementos.

### Depuración

- **Tracebacks:** lee el traceback de abajo hacia arriba: la línea inferior señala el error y el archivo/línea exactos.
- **`print()` estratégico:** imprime valores intermedios para seguir el flujo.
- **`pdb`:** el depurador interactivo. Puntos de ruptura con `breakpoint()` (Python 3.7+).

```python
# python3 -m pdb script.py  (o breakpoint() dentro del código)
def dividir(a, b):
    breakpoint()          # abre el depurador aquí
    return a / b
```

Comandos de `pdb`: `n` (next), `s` (step into), `c` (continue), `p expresion` (print), `q` (quit).

### Context managers (relacionado)

La sentencia `with` garantiza la limpieza de recursos aunque haya errores, y es la forma idiomática de manejar archivos.

```python
with open("datos.txt", "r") as f:
    contenido = f.read()
# el archivo se cierra automáticamente, incluso si hay una excepción
```

## Ejemplos de código

```python
# Apertura de archivo robusta
nombre_archivo = "no-existe.txt"
try:
    with open(nombre_archivo, "r") as f:
        print(f.read())
except FileNotFoundError:
    print(f"El archivo {nombre_archivo} no existe")
finally:
    print("Fin del intento")
```

```python
# Validación con excepción personalizada
class EdadInvalidaError(Exception):
    pass

def registrar_edad(edad):
    if not isinstance(edad, int):
        raise EdadInvalidaError("La edad debe ser un entero")
    if edad < 0 or edad > 130:
        raise EdadInvalidaError(f"Edad fuera de rango: {edad}")
    return f"Edad registrada: {edad}"

try:
    print(registrar_edad(25))
    print(registrar_edad(-3))
except EdadInvalidaError as e:
    print(f"Rechazado: {e}")
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **Capturar `except:` a secas** — oculta todos los errores y dificulta el diagnóstico. Captura tipos concretos.
- **No capturar la excepción que realmente ocurre** — e.g. capturar `ValueError` cuando se lanza `KeyError`.
- **Usar `except` vacío sin registrar** — el error desaparece y el programa sigue con estado corrupto.
- **`return` dentro de `finally`** — sobrescribe el valor de retorno del `try` y enmascara excepciones.
- **Lanzar `Exception` genérica** — es preferible usar la excepción más específica o crear una personalizada.
- **No leer el traceback completo** — la última línea no siempre es la causa raíz; revisa la cadena de llamadas.

## Recursos

- [Python.org — Errores y excepciones](https://docs.python.org/es/3/tutorial/errors.html)
- [Python.org — Excepciones incorporadas](https://docs.python.org/es/3/library/exceptions.html)
- [Real Python — Python Exceptions](https://realpython.com/python-exceptions/)
- [Python.org — pdb](https://docs.python.org/es/3/library/pdb.html)