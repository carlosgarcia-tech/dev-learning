# 01 — Fundamentos de Python

## Objetivos

- [ ] Escribir programas básicos respetando la indentación.
- [ ] Identificar los tipos de datos principales y usar `type()`.
- [ ] Declarar variables y aplicar conversión de tipos (`int`, `float`, `str`).
- [ ] Usar `input()` y `print()` para entrada/salida.
- [ ] Escribir condicionales `if/elif/else` y el operador ternario.
- [ ] Usar los bucles `for` y `while` con `break` y `continue`.

## Apuntes

### Sintaxis e indentación

Python usa la **indentación** (4 espacios por convención) para delimitar bloques en lugar de llaves. No hay `;` obligatorio al final de línea: la nueva línea separa sentencias.

```python
if 5 > 2:
    print("Cinco es mayor que dos")   # indentado = dentro del bloque
print("Fuera del bloque")
```

### Variables y tipos de datos

Python es de **tipado dinámico**: la variable adopta el tipo del valor que se le asigna. Se usa `snake_case` por convención.

Tipos principales:

- `int` — enteros: `42`
- `float` — decimales: `3.14`
- `str` — texto: `"hola"`, `'hola'`, `"""texto multilínea"""`
- `bool` — `True` o `False`
- `None` — ausencia de valor (equivalente a `null`)
- `list`, `tuple`, `dict`, `set` — estructuras de datos (ver guía 03)

```python
nombre = "Ana"
edad = 30
altura = 1.68
es_programadora = True
print(type(nombre))   # <class 'str'>
print(type(edad))     # <class 'int'>
print(type(altura))   # <class 'float'>
print(type(es_programadora))  # <class 'bool'>
```

### Conversión de tipos

`int()`, `float()`, `str()` y `bool()` convierten entre tipos. Es especialmente útil para procesar lo que devuelve `input()` (siempre un `str`).

```python
n = int("42")          # 42  (int)
pi = float("3.14")     # 3.14
texto = str(100)       # "100"
print(int("101", 2))   # 5 (interpreta binario)
```

### Entrada y salida (I/O)

`print()` imprime en consola; recibe varios argumentos separados por comas. `input(prompt)` lee texto del usuario y **siempre** devuelve un `str`.

```python
nombre = input("¿Cómo te llamas? ")
edad = int(input("¿Cuántos años tienes? "))
print("Hola", nombre, "el año que viene tendrás", edad + 1, "años.")
```

### F-strings

Los f-strings (prefijo `f` antes de las comillas) permiten interpolación directa con `{}` y expresiones dentro. Desde Python 3.12 también existe el `f-string` con plantillas multilínea.

```python
nombre = "Ana"
edad = 30
print(f"Hola, soy {nombre} y tengo {edad} años.")
print(f"En 5 años tendré {edad + 5}.")
print(f"Pi con 2 decimales: {3.14159:.2f}")
```

### Condicionales

`if`, `elif`, `else` evalúan valores de verdad. Valores *falsy*: `0`, `0.0`, `""`, `[]`, `{}`, `None`, `False`.

El operador ternario `valor_si_true if condicion else valor_si_false` devuelve un valor en una sola expresión.

```python
nota = 85
if nota >= 90:
    print("Excelente")
elif nota >= 70:
    print("Aprobado")
else:
    print("Reprobado")

resultado = "aprueba" if nota >= 60 else "reprueba"
print(resultado)
```

### Operadores

- **Aritméticos:** `+ - * /` (división real), `//` (división entera), `%` (módulo), `**` (potencia).
- **Comparación:** `== != > < >= <=`.
- **Lógicos:** `and or not`.
- **Asignación:** `= += -= *= /=`.

```python
print(7 // 2)    # 3
print(7 % 3)     # 1
print(2 ** 10)   # 1024
print(10 / 4)    # 2.5
print(5 == "5")  # False (tipos distintos)
print(not True)  # False
```

### Bucles

- `for` — itera sobre una secuencia o rango.
- `while` — repite mientras la condición sea verdadera.
- `break` corta el bucle; `continue` salta a la siguiente iteración.
- `range(inicio, fin, paso)` genera secuencias de enteros (el fin no se incluye).

```python
for i in range(3):        # 0, 1, 2
    print(i)

for fruta in ["manzana", "pera", "uva"]:
    print(fruta)

n = 0
while n < 3:
    n += 1

for i in range(10):
    if i == 3:
        continue          # salta el 3
    if i == 6:
        break             # corta en el 6
    print(i)
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

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Indentación inconsistente** → `IndentationError`. Todos los bloques deben usar la misma indentación (4 espacios).
- **Sumar `str` y `int`** → `TypeError`. Convierte con `int()`/`float()` lo que devuelve `input()`.
- **Olvidar los dos puntos** → `SyntaxError` al escribir `if x > 2` sin el `:`.
- **Usar `=` en vez de `==`** → asignación en lugar de comparación (sin error aparente).
- **Confundir `/` con `//`** → `10 / 4` es `2.5`; `10 // 4` es `2`.
- **Índices fuera de rango** → `IndexError`. El índice del último elemento de una lista de `n` es `n - 1`.
- **Llamar `print` con paréntesis de más** → en Python `print` es una función: `print("hola")`, no `print "hola"`.

## Recursos

- [Python.org — Tutorial oficial](https://docs.python.org/es/3/tutorial/)
- [Python.org — Documentación en español](https://docs.python.org/es/3/)
- [Real Python — Python Basics](https://realpython.com/tutorials/python-basics/)
- [W3Schools — Python](https://www.w3schools.com/python/)
- [Python download](https://www.python.org/downloads/)