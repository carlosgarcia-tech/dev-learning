# Ejercicio 02 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores, if/elif/else, entrada de usuario
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `calculadora.py` que pida al usuario dos números (`float`) y un operador (`+`, `-`, `*`, `/`) con `input()`, y muestre el resultado.

Reglas:

- Si el operador es `+`, `-`, `*` o `/`, muestra `resultado = <operando1> <op> <operando2> = <valor>`.
- Si el operador no es válido, muestra `Operador no válido`.
- Si el operador es `/` y el segundo número es `0`, muestra `No se puede dividir entre cero`.
- Los números se leen con `input()` y se convierten con `float()`.

Salida esperada (ejemplo con `10`, `3`, `/`):

```
Resultado: 10.0 / 3.0 = 3.3333333333333335
```

## Requisitos

- [ ] Leer los dos números y el operador con `input()`.
- [ ] Usar `if/elif/else` para distinguir los operadores.
- [ ] Manejar la división entre cero sin que el programa falle.
- [ ] Ejecutarlo localmente con `python3 calculadora.py` y probar los casos `+`, `/`, operador inválido y división entre cero.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `float(input("..."))` convierte lo leído a número.
- Compara el operador con `==`: `if operador == "+":`.
- La división entre cero lanza `ZeroDivisionError`; evítala comprobando `if b == 0` antes.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
a = float(input("Primer número: "))
b = float(input("Segundo número: "))
op = input("Operador (+, -, *, /): ")

if op == "+":
    print(f"Resultado: {a} + {b} = {a + b}")
elif op == "-":
    print(f"Resultado: {a} - {b} = {a - b}")
elif op == "*":
    print(f"Resultado: {a} * {b} = {a * b}")
elif op == "/":
    if b == 0:
        print("No se puede dividir entre cero")
    else:
        print(f"Resultado: {a} / {b} = {a / b}")
else:
    print("Operador no válido")
````

</details>