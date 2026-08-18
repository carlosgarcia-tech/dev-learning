# Ejercicio 01 — Funciones

- **Nivel:** 2/5
- **Tema:** def, parámetros, return, parámetros por defecto
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente:

1. `saludar(nombre)` — devuelve `Hola, <nombre>!`.
2. `area_rectangulo(base, altura)` — devuelve `base * altura`.
3. `potencia(base, exponente=2)` — devuelve `base ** exponente` (usa el valor por defecto cuando no se pase exponente).
4. `es_par(n)` — devuelve `True` si `n` es par.
5. `dividir(a, b)` — devuelve el cociente y el resto con `//` y `%` como una tupla.

Salida esperada (ejemplo de checks):

```
saludar("Ana") devuelve "Hola, Ana!"
area_rectangulo(4, 5) devuelve 20
potencia(3) devuelve 9
potencia(2, 3) devuelve 8
es_par(4) devuelve True
es_par(7) devuelve False
dividir(10, 3) devuelve (3, 1)
```

## Requisitos

- [ ] Definir las 5 funciones con `def`.
- [ ] Usar un parámetro por defecto en `potencia`.
- [ ] Devolver dos valores en `dividir`.
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

- Sin `return` la función devuelve `None`.
- Para devolver dos valores: `return cociente, resto`.
- `n % 2 == 0` detecta pares.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def saludar(nombre):
    return f"Hola, {nombre}!"


def area_rectangulo(base, altura):
    return base * altura


def potencia(base, exponente=2):
    return base ** exponente


def es_par(n):
    return n % 2 == 0


def dividir(a, b):
    return a // b, a % b


if __name__ == "__main__":
    print(saludar("Ana"))
    print(f"Area: {area_rectangulo(4, 5)}")
    print(f"Potencia (defecto): {potencia(3)}")
    print(f"Potencia (explícita): {potencia(2, 3)}")
    print(f"Es par 4: {es_par(4)}")
    print(f"Es par 7: {es_par(7)}")
    print(f"Dividir 10 entre 3: {dividir(10, 3)}")
````

</details>