# Ejercicio 01 — Funciones

- **Nivel:** 2/5
- **Tema:** def, parámetros, return, parámetros por defecto
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `funciones.py` con estas funciones:

1. `saludar(nombre)` → devuelve `Hola, <nombre>!`.
2. `area_rectangulo(base, altura)` → devuelve `base * altura`.
3. `potencia(base, exponente=2)` → devuelve `base ** exponente` (usa el valor por defecto cuando no se pase exponente).
4. `es_par(n)` → devuelve `True` si `n` es par.
5. `dividir(a, b)` → devuelve el cociente y el resto con `//` y `%` como una tupla.

Al final, llama a todas las funciones e imprime los resultados.

Salida esperada:

```
Hola, Ana!
Area: 20
Potencia (defecto): 9
Potencia (explícita): 8
Es par 4: True
Es par 7: False
Dividir 10 entre 3: (3, 1)
```

## Requisitos

- [ ] Definir las 5 funciones con `def`.
- [ ] Usar un parámetro por defecto en `potencia`.
- [ ] Devolver dos valores en `dividir`.
- [ ] Llamar a cada función e imprimir el resultado.
- [ ] Ejecutarlo localmente con `python3 funciones.py` y verificar la salida.

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

print(saludar("Ana"))
print(f"Area: {area_rectangulo(4, 5)}")
print(f"Potencia (defecto): {potencia(3)}")
print(f"Potencia (explícita): {potencia(2, 3)}")
print(f"Es par 4: {es_par(4)}")
print(f"Es par 7: {es_par(7)}")
print(f"Dividir 10 entre 3: {dividir(10, 3)}")
````

</details>