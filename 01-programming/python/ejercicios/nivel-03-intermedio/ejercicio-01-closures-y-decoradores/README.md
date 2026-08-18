# Ejercicio 01 — Closures y decoradores

- **Nivel:** 3/5
- **Tema:** closures, nonlocal, decoradores, functools.wraps
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente:

1. `crear_contador()` — devuelve una función `incrementar()` con una variable `contador` privada modificada con `nonlocal`. Cada llamada a `incrementar()` suma 1 y devuelve el valor actual. Debe permitir crear contadores independientes.
2. `tiempo_ejecucion(func)` — decorador que mida el tiempo con `time.perf_counter()` e imprima `{nombre} tardó {segundos:.4f}s`. Usa `functools.wraps`.
3. `repetir(veces)` — decorador con parámetros que repita la llamada a la función decorada `veces` veces y devuelva el último resultado.

El bloque `if __name__ == "__main__":` puede servir de demo: crea dos contadores `c1` y `c2` y llama a cada uno 3 veces, decora una función `saludar(nombre)` (que espera `time.sleep(0.1)` y devuelve `Hola, {nombre}!`) con `tiempo_ejecucion` y una función `hola()` que imprime `Hola desde repetir` con `@repetir(3)`.

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
- [ ] `crear_contador()` devuelve contadores independientes.
- [ ] Usar `functools.wraps` en el decorador.
- [ ] Decorar una función que llama `time.sleep`.
- [ ] Implementar un decorador con parámetros.
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

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


def tiempo_ejecucion(func):
    @functools.wraps(func)
    def envoltorio(*args, **kwargs):
        inicio = time.perf_counter()
        resultado = func(*args, **kwargs)
        fin = time.perf_counter()
        print(f"{func.__name__} tardó {fin - inicio:.4f}s")
        return resultado

    return envoltorio


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


if __name__ == "__main__":
    c1 = crear_contador()
    c2 = crear_contador()
    print("Contador 1:", c1(), c1(), c1())
    print("Contador 2:", c2(), c2(), c2())

    @tiempo_ejecucion
    def saludar(nombre):
        time.sleep(0.1)
        return f"Hola, {nombre}!"

    print(saludar("Ana"))

    @repetir(3)
    def hola():
        print("Hola desde repetir")

    hola()
````

</details>