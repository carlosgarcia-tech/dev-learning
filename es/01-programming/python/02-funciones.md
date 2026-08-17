# 02 — Funciones en Python

## Objetivos

- [ ] Definir funciones con `def`, parámetros y `return`.
- [ ] Usar parámetros por defecto, *args y **kwargs.
- [ ] Pasar argumentos posicionales y por nombre (keyword).
- [ ] Entender el scope: variables locales, globales y `global`.
- [ ] Devolver varios valores con tuplas.
- [ ] Escribir docstrings y anotaciones de tipo básicas.

## Apuntes

### Definición de funciones

Una función se define con `def`, tiene un nombre, parámetros entre paréntesis y un cuerpo indentado. Si no hay `return`, la función devuelve `None` implícitamente.

```python
def saludar(nombre):
    return f"Hola, {nombre}"

print(saludar("Ana"))   # Hola, Ana

def imprimir_mensaje():
    print("Sin return devuelve None")
resultado = imprimir_mensaje()
print(resultado)        # None
```

### Parámetros y argumentos

- **Posicionales:** se pasan en el mismo orden que la definición.
- **Por nombre (keyword):** `def area(base, altura)` → `area(altura=3, base=5)`.
- **Por defecto:** parámetros con valor inicial si no se pasan. Deben ir después de los obligatorios.

```python
def potencia(base, exponente=2):
    return base ** exponente

print(potencia(5))       # 25 (usa el valor por defecto)
print(potencia(5, 3))    # 125
print(potencia(exponente=3, base=2))  # 8
```

### *args y **kwargs

- `*args` recoge argumentos posicionales extra en una **tupla**.
- `**kwargs` recoge argumentos por nombre extra en un **diccionario**.

```python
def sumar_todos(*args):
    return sum(args)

print(sumar_todos(1, 2, 3, 4))   # 10

def imprimir_datos(**kwargs):
    for clave, valor in kwargs.items():
        print(f"{clave}: {valor}")

imprimir_datos(nombre="Ana", edad=30)
```

### return y múltiples valores

`return` puede devolver varios valores separados por comas; Python los empaqueta en una **tupla** que puedes desempaquetar.

```python
def dividir(a, b):
    cociente = a // b
    resto = a % b
    return cociente, resto

c, r = dividir(10, 3)
print(c, r)   # 3 1
```

### Scope: local vs global

- Las variables definidas **dentro** de una función son locales: no existen fuera.
- Las variables **globales** se pueden leer dentro, pero para modificarlas hay que declararlas con `global`.
- Regla LEGB: Local → Enclosing → Global → Built-in.

```python
contador = 0

def incrementar():
    global contador
    contador += 1

incrementar()
print(contador)   # 1
```

En funciones anidadas, `nonlocal` permite modificar una variable del ámbito exterior (enclosing) sin que sea global.

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

### Lambdas

Una lambda es una función anónima de una sola expresión: `lambda argumentos: expresión`. Útil como argumento de otras funciones (`map`, `filter`, `sorted`).

```python
doble = lambda x: x * 2
print(doble(4))          # 8
print((lambda a, b: a + b)(3, 4))   # 7
```

### Docstrings y anotaciones de tipo

- El **docstring** es el string de la primera línea que documenta la función.
- Las **anotaciones de tipo** (`nombre: str`, `-> int`) son opcionales: ayudan a herramientas como mypy pero no se aplican en tiempo de ejecución.

```python
def calcular_imc(peso: float, altura: float) -> float:
    """Calcula el índice de masa corporal.

    Args:
        peso: en kilogramos.
        altura: en metros.

    Returns:
        IMC como float.
    """
    return peso / altura ** 2

print(calcular_imc(70, 1.75))
```

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
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **Olvidar `return`** → la función devuelve `None` en vez del valor esperado.
- **Modificar una variable global sin `global`** → `UnboundLocalError: local variable referenced before assignment`.
- **Usar el nombre de una variable global igual a un parámetro** → el parámetro lo sombrea.
- **`TypeError: missing positional argument`** → olvidar pasar un argumento obligatorio.
- **Mutar el valor por defecto mutable** → `def f(x, lista=[])` comparte la misma lista entre llamadas. Usa `None` como default.
- **Confundir `*args` (tupla) con `**kwargs` (diccionario)** → iterar uno como si fuera el otro.

## Recursos

- [Python.org — Definición de funciones](https://docs.python.org/es/3/tutorial/controlflow.html#definiendo-funciones)
- [Real Python — Python Functions](https://realpython.com/defining-your-own-python-function/)
- [Real Python — Scope](https://realpython.com/python-scope-legb-rule/)
- [PEP 257 — Docstring Conventions](https://peps.python.org/pep-0257/)