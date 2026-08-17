# Ejercicio 01 — Closures y decoradores

- **Nivel:** 3/5
- **Tema:** closures, nonlocal, decoradores, functools.wraps
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `closures_decoradores.py` que:

1. Defina `crear_contador()` que devuelve una función `incrementar()` con una variable `contador` privada modificada con `nonlocal`. Cada llamada a `incrementar()` suma 1 y devuelve el valor actual. Crea dos contadores independientes `c1` y `c2` y llama a cada uno 3 veces.

2. Defina el decorador `tiempo_ejecucion(func)` que mida el tiempo con `time.perf_counter()` e imprima `{nombre} tardó {segundos:.4f}s`. Usa `functools.wraps`.

3. Aplique el decorador a `saludar(nombre)` que espera `time.sleep(0.1)` y devuelve `Hola, {nombre}!`.

4. Defina un decorador con parámetros `repetir(veces)` que repita la llamada a la función decorada `veces` veces (una vez para preparación y las restantes... simplemente repite la llamada `veces` veces y devuelve el último resultado). Aplícalo a `hola()` que imprime `Hola desde repetir`.

Salida esperada (ejemplo):

```
Contador 1: 1 2 3
Contador 2: 1 2 3
saludar tardó 0.1000s
Hola, Ana!
Hola desde repetir
Hola desde repetir
Hola desde repetir
```

## Requisitos

- [ ] Usar `nonlocal` en el closure del contador.
- [ ] Crear dos contadores independientes.
- [ ] Usar `functools.wraps` en el decorador.
- [ ] Decorar una función que llama `time.sleep`.
- [ ] Implementar un decorador con parámetros.
- [ ] Ejecutarlo localmente con `python3 closures_decoradores.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un closure recuerda variables del ámbito donde fue creado.
- `nonlocal` permite modificar una variable del ámbito exterior de una función anidada.
- Un decorador es una función que recibe otra función y devuelve una versión modificada.
- Para decoradores con parámetros necesitas una función que devuelva el decorador.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import functools
import time


def crear_contador():
    contador = 0

    def incrementar():
        nonlocal contador
        contador += 1
        return contador

    return incrementar


c1 = crear_contador()
c2 = crear_contador()
print("Contador 1:", c1(), c1(), c1())
print("Contador 2:", c2(), c2(), c2())


def tiempo_ejecucion(func):
    @functools.wraps(func)
    def envoltorio(*args, **kwargs):
        inicio = time.perf_counter()
        resultado = func(*args, **kwargs)
        fin = time.perf_counter()
        print(f"{func.__name__} tardó {fin - inicio:.4f}s")
        return resultado

    return envoltorio


@tiempo_ejecucion
def saludar(nombre):
    time.sleep(0.1)
    return f"Hola, {nombre}!"


print(saludar("Ana"))


def repetir(veces):
    def decorador(func):
        @functools.wraps(func)
        def envoltorio(*args, **kwargs):
            resultado = None
            for _ in range(veces):
                resultado = func(*args, **kwargs)
            return resultado

        return envoltorio

    return decorador


@repetir(3)
def hola():
    print("Hola desde repetir")


hola()
````

</details>