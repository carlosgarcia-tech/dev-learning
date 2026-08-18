# Ejercicio 05 — Bucles

- **Nivel:** 1/5
- **Tema:** for, while, range, break, continue
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `bucles.py` que:

1. Con un `for` + `range`, imprima los números del 1 al 10 con `1, 2, 3, ...` (mismo formato de salida con `sep=", "`).
2. Imprima la tabla de multiplicar del 7 (del 1 al 10).
3. Con un `while`, sume los números del 1 al 100 e imprima el total.
4. Recorra la lista `[3, 7, 12, 5, 8, 15]` y, usando `continue`, imprima solo los pares.
5. Usando `break`, imprima los números del 1 en adelante hasta que encuentre el primero divisible entre 7 y 3, y luego se detenga.

Salida esperada:

```
1, 2, 3, 4, 5, 6, 7, 8, 9, 10
7 x 1 = 7
7 x 2 = 14
...
7 x 10 = 70
Suma 1..100: 5050
Pares: 12 8
Primer múltiplo de 21: 21
```

## Requisitos

- [ ] Usar `for` con `range` para el punto 1 y la tabla de multiplicar.
- [ ] Usar `while` para sumar del 1 al 100.
- [ ] Usar `continue` para saltar los impares.
- [ ] Usar `break` al encontrar el primer múltiplo de 21.
- [ ] Ejecutarlo localmente con `python3 bucles.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `print(*rango, sep=", ")` imprime los valores separados por coma.
- `range(1, 11)` genera 1..10 (el 11 no se incluye).
- Un número es múltiplo de 21 si `n % 21 == 0`.
- Para los pares: `if n % 2 != 0: continue`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
print(*range(1, 11), sep=", ")

for i in range(1, 11):
    print(f"7 x {i} = {7 * i}")

total = 0
n = 1
while n <= 100:
    total += n
    n += 1
print(f"Suma 1..100: {total}")

pares = []
for numero in [3, 7, 12, 5, 8, 15]:
    if numero % 2 != 0:
        continue
    pares.append(str(numero))
print("Pares:", " ".join(pares))

for n in range(1, 1000):
    if n % 21 == 0:
        print(f"Primer múltiplo de 21: {n}")
        break
````

</details>