# Algoritmos

> Guía de algoritmos fundamentales: análisis de complejidad, ordenamiento, búsqueda, recursión, programación dinámica, greedy y backtracking.

## Índice

1. [Complejidad y notación Big O](#complejidad-y-notación-big-o)
2. [Algoritmos de ordenamiento](#algoritmos-de-ordenamiento)
3. [Algoritmos de búsqueda](#algoritmos-de-búsqueda)
4. [Recursión](#recursión)
5. [Programación dinámica (DP)](#programación-dinámica-dp)
6. [Algoritmos greedy](#algoritmos-greedy)
7. [Backtracking](#backtracking)
8. [Resumen de complejidades](#resumen-de-complejidades)

---

## Complejidad y notación Big O

La **notación Big O** describe cómo crece el tiempo o espacio de un algoritmo a medida que aumenta el tamaño de la entrada `n`. Describe el límite asintótico superior, ignorando constantes y términos menores.

### Funciones de crecimiento

| Notación | Nombre | n=10 | n=100 | n=1000 |
|----------|--------|------|-------|--------|
| O(1) | Constante | 1 | 1 | 1 |
| O(log n) | Logarítmica | 3 | 7 | 10 |
| O(n) | Lineal | 10 | 100 | 1000 |
| O(n log n) | Linealítmica | 33 | 664 | 9966 |
| O(n²) | Cuadrática | 100 | 10000 | 10⁶ |
| O(n³) | Cúbica | 1000 | 10⁶ | 10⁹ |
| O(2ⁿ) | Exponencial | 1024 | 10³⁰ | ∞ |
| O(n!) | Factorial | 3.6·10⁶ | ∞ | ∞ |

```
Crecimiento (eje vertical = operaciones)

O(n!)      /
O(2^n)    /
O(n^3)   /
O(n^2)   /
O(n log n)  /
O(n)    /
O(log n)/
O(1)  ______________________
        n=1            n=grande
```

### Reglas

- **Constantes:** O(2n) → O(n).
- **Términos dominantes:** O(n² + n) → O(n²).
- **Suma de bucles:** el que más crece domina.
- **Anidados:** se multiplican: dos bucles de n iteraciones → O(n²).

### Notaciones relacionadas

| Notación | Significado |
|----------|-------------|
| O(f(n)) | Cota superior asintótica (peor caso) |
| Ω(f(n)) | Cota inferior (mejor caso) |
| Θ(f(n)) | Cota ajustada (O y Ω a la vez) |

### Complejidad de espacio

Cuenta la memoria extra que usa el algoritmo (sin contar la entrada). Por ejemplo, mergesort usa O(n) extra; quicksort in-place O(log n) por la pila de recursión.

### Análisis amortizado

A veces una operación puntual es cara, pero el promedio a lo largo de muchas operaciones es barato. Ejemplo clásico: `append` en un array dinámico es O(n) cuando hay que redimensionar, pero O(1) amortizado.

---

## Algoritmos de ordenamiento

Ordenar es reorganizar una colección en un orden definido (ascendente, descendente, lexicográfico, etc.).

### Comparativa general

| Algoritmo | Mejor | Promedio | Peor | Espacio | Estable |
|-----------|-------|----------|------|---------|---------|
| Bubble sort | O(n) | O(n²) | O(n²) | O(1) | Sí |
| Selection sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion sort | O(n) | O(n²) | O(n²) | O(1) | Sí |
| Merge sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Sí |
| Quick sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Counting sort | O(n+k) | O(n+k) | O(n+k) | O(k) | Sí |
| Radix sort | O(d·(n+k)) | O(d·(n+k)) | O(d·(n+k)) | O(n+k) | Sí |

- **Estable:** conserva el orden relativo de elementos iguales.
- `k` = rango de valores, `d` = número de dígitos.

### Bubble sort

Compara pares adyacentes y los intercambia si están desordenados. Repite hasta que no haya intercambios. Simple pero lento.

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr
```

### Selection sort

Encuentra el mínimo del resto y lo coloca en su posición. Siempre hace O(n²) comparaciones pero solo O(n) intercambios.

```python
def selection_sort(arr):
    for i in range(len(arr)):
        min_idx = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr
```

### Insertion sort

Construye el array ordenado insertando cada elemento en su posición correcta. Muy eficiente en arrays casi ordenados o pequeños.

```python
def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    return arr
```

### Merge sort

Divide el array por la mitad, ordena cada mitad recursivamente y las fusiona. Estable y O(n log n) garantizado, pero usa O(n) memoria extra.

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

### Quick sort

Elige un **pivote**, particiona los menores a la izquierda y los mayores a la derecha, y ordena cada lado recursivamente. En promedio O(n log n); en el peor caso (pivote malo) O(n²).

```python
def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    mid = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + mid + quick_sort(right)
```

**Estrategias de pivote:** primer elemento, último, aleatorio, mediana de tres. Elegir aleatorio o mediana reduce la probabilidad del peor caso.

**In-place:** existe una versión que particiona intercambiando en el mismo array sin listas auxiliares, usando O(log n) espacio para la pila de llamadas.

### Heap sort

Construye un max-heap a partir del array (heapify en O(n)) y va extrayendo el máximo colocándolo al final. In-place y O(n log n).

```python
def heap_sort(arr):
    n = len(arr)

    def heapify(n, i):
        largest = i
        l, r = 2*i + 1, 2*i + 2
        if l < n and arr[l] > arr[largest]:
            largest = l
        if r < n and arr[r] > arr[largest]:
            largest = r
        if largest != i:
            arr[i], arr[largest] = arr[largest], arr[i]
            heapify(n, largest)

    for i in range(n // 2 - 1, -1, -1):
        heapify(n, i)
    for i in range(n - 1, 0, -1):
        arr[0], arr[i] = arr[i], arr[0]
        heapify(i, 0)
    return arr
```

### Counting sort y Radix sort

Son **no comparativos** y pueden superar el límite teórico de Ω(n log n) para los comparativos, pero requieren supuestos sobre los datos (rango acotado).

- **Counting sort:** cuenta ocurrencias de cada valor. O(n+k).
- **Radix sort:** ordena dígito a dígito usando counting sort como subrutina. O(d·(n+k)).

---

## Algoritmos de búsqueda

### Búsqueda lineal

Recorre uno a uno hasta encontrar el elemento. Funciona en cualquier colección.

```python
def linear_search(arr, target):
    for i, v in enumerate(arr):
        if v == target:
            return i
    return -1
```

- Complejidad: O(n).

### Búsqueda binaria

Requiere un array **ordenado**. Compara con el elemento central y descarta la mitad en cada paso.

```python
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```

- Complejidad: O(log n).
- Cuidado con el desbordamiento: `mid = lo + (hi - lo) // 2` es más seguro en lenguajes con enteros acotados.

### Búsqueda binaria en la respuesta

Muchos problemas se resuelven buscando el valor mínimo/máximo posible que cumple una propiedad, aplicando búsqueda binaria sobre el rango de respuestas.

```python
# Ejemplo: capacidad mínima de un barco para enviar cargas en D días
def ship_within_days(weights, D):
    lo, hi = max(weights), sum(weights)
    while lo < hi:
        mid = (lo + hi) // 2
        if can_ship(weights, mid, D):
            hi = mid
        else:
            lo = mid + 1
    return lo
```

### Búsqueda en grafos

- **BFS:** encuentra el camino más corto en grafos no ponderados.
- **DFS:** explora a profundidad, útil para detección de ciclos y componentes conexas.
- Ambas en O(V + E).

---

## Recursión

Una función **recursiva** se llama a sí misma con un caso más pequeño hasta llegar a un **caso base** que detiene la recursión.

### Estructura

1. **Caso base:** condición de salida, sin llamada recursiva.
2. **Caso recursivo:** se llama con un subproblema menor avanzando hacia el caso base.

```python
def factorial(n):
    if n <= 1:          # caso base
        return 1
    return n * factorial(n - 1)   # caso recursivo
```

### La pila de llamadas

Cada llamada recursiva ocupa un **stack frame**. Demasiadas llamadas provocan un **stack overflow**. Python, por ejemplo, tiene un límite por defecto de 1000.

```python
import sys
sys.getrecursionlimit()   # 1000 por defecto
sys.setrecursionlimit(5000)
```

### Recursión vs iteración

Toda recursión puede escribirse como iteración usando una pila explícita. La iteración suele ser más eficiente; la recursión suele ser más legible para problemas con estructura recursiva (árboles, divide y vencerás).

### Tail recursion

Cuando la llamada recursiva es la **última** operación. Algunos lenguajes (Scheme, Scala, Haskell) hacen **tail call optimization** y reutilizan el frame, evitando el stack overflow. Python no lo hace.

```python
# No es tail recursion (multiplica después de la llamada)
def factorial(n):
    return 1 if n <= 1 else n * factorial(n - 1)

# Tail recursion (el acumulador lleva el resultado)
def factorial(n, acc=1):
    if n <= 1:
        return acc
    return factorial(n - 1, n * acc)
```

### Patrones recursivos comunes

- **Divide y vencerás:** dividir en mitades (merge sort, quick sort).
- **Backtracking:** explorar opciones y descartar (DFS con poda).
- **DP top-down:** recursión + memoización.

---

## Programación dinámica (DP)

La **programación dinámica** resuelve problemas dividiéndolos en subproblemas que se solapan, guardando los resultados para no recalcularlos.

### Cuándo aplicar DP

1. **Subproblemas solapados:** el mismo subproblema se resuelve muchas veces.
2. **Subestructura óptima:** la solución óptima del problema se compone de soluciones óptimas de subproblemas.

### Dos enfoques

#### 1. Top-down (memoización)

Se resuelve recursivamente y se guarda cada resultado en una caché (memo).

```python
from functools import lru_cache

@lru_cache(maxsize=None)
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
```

Sin memoización, `fib(n)` tiene complejidad O(2ⁿ). Con memoización pasa a O(n).

#### 2. Bottom-up (tabulación)

Se construye una tabla iterativamente desde los casos base.

```python
def fib(n):
    if n < 2:
        return n
    dp = [0] * (n + 1)
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]
```

### Optimización de espacio

A menudo no hace falta guardar toda la tabla, solo los últimos valores:

```python
def fib(n):
    if n < 2:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

### Ejemplo: mochila 0/1 (Knapsack)

Dados objetos con peso y valor, maximizar el valor sin superar la capacidad W.

```python
def knapsack(weights, values, W):
    n = len(weights)
    dp = [0] * (W + 1)
    for i in range(n):
        for w in range(W, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    return dp[W]
```

### Ejemplo: longest common subsequence (LCS)

```python
def lcs(s1, s2):
    m, n = len(s1), len(s2)
    dp = [[0]*(n+1) for _ in range(m+1)]
    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    return dp[m][n]
```

### Patrones DP comunes

| Patrón | Ejemplo |
|-------|---------|
| Secuencia / subsecuencia | LIS, LCS, edit distance |
| Intervalos | multiplicación de matrices, burst balloons |
| Subconjuntos / mochila | 0/1 knapsack, subset sum |
| Caminos en una matriz | DP en grid, unique paths |
| Cadena de决策 | DP sobre estados |

---

## Algoritmos greedy

Un algoritmo **greedy** (voraz) toma la mejor decisión **local** en cada paso, esperando llegar al óptimo global. No siempre funciona; solo cuando el problema tiene ** elección greedy óptima** y **subestructura óptima**.

### Cuándo funciona el greedy

- **Subestructura óptima:** la solución óptima contiene subsoluciones óptimas.
- **Elección greedy:** elegir lo mejor localmente lleva al óptimo global.

### Ejemplo: problema del cambio (monedas)

Con un sistema de monedas **canónico** (como el euro: 1, 2, 5, 10, 20, 50, 100, 200), siempre tomar la moneda más grande posible da la solución óptima.

```python
def change(amount, coins):
    coins.sort(reverse=True)
    result = []
    for c in coins:
        while amount >= c:
            amount -= c
            result.append(c)
    return result
```

> Ojo: con monedas arbitrarias (ej: 1, 3, 4) el greedy puede fallar y se necesita DP.

### Ejemplo: interval scheduling

Elegir el máximo número de actividades no solapadas: ordenar por hora de fin y tomar siempre la siguiente que empieza antes.

```python
def max_activities(activities):
    activities.sort(key=lambda x: x[1])   # por fin
    count = 0
    last_end = float('-inf')
    for start, end in activities:
        if start >= last_end:
            count += 1
            last_end = end
    return count
```

### Otros ejemplos greedy

- **Huffman coding:** construir el código óptimo de prefijo para compresión.
- **Algoritmo de Dijkstra:** camino mínimo eligiendo el nodo no visitado más cercano.
- **Árbol de expansión mínima (Kruskal/Prim):** elegir la arista más barata que no forme ciclo.
- **Fraccional knapsack:** se puede dividir el objeto, siempre greedy funciona.

### Greedy vs DP

| Aspecto | Greedy | DP |
|---------|--------|----|
| Decisiones | Una sola, irrevocable | Explora combinaciones |
| Velocidad | Suele ser O(n log n) o O(n) | O(n²) o mayor |
| Optimalidad | Solo si el problema lo permite | Garantizada (si está bien modelado) |

---

## Backtracking

El **backtracking** explora sistemáticamente todas las posibles soluciones construyéndolas incrementalmente y **descartando** (backtrack) las ramas que no pueden llevar a una solución válida (poda).

### Esquema general

```python
def backtrack(camino, opciones):
    if es_solucion(camino):
        registrar(camino)
        return
    for opcion in opciones_validas(camino):
        camino.append(opcion)            # elegir
        backtrack(camino, opciones)      # explorar
        camino.pop()                     # deshacer (backtrack)
```

### Ejemplo: permutaciones

```python
def permutations(nums):
    result = []

    def backtrack(path, remaining):
        if not remaining:
            result.append(path[:])
            return
        for i in range(len(remaining)):
            path.append(remaining[i])
            backtrack(path, remaining[:i] + remaining[i+1:])
            path.pop()

    backtrack([], nums)
    return result
```

### Ejemplo: N-Reinas

Colocar N reinas en un tablero NxN sin que se ataquen.

```python
def solve_n_queens(n):
    solutions = []

    def is_safe(board, row, col):
        for r in range(row):
            c = board[r]
            if c == col or abs(c - col) == row - r:
                return False
        return True

    def backtrack(row, board):
        if row == n:
            solutions.append(board[:])
            return
        for col in range(n):
            if is_safe(board, row, col):
                board.append(col)
                backtrack(row + 1, board)
                board.pop()

    backtrack(0, [])
    return solutions
```

Complejidad del backtracking puro: O(N!) porque hay N! permutaciones; la poda lo reduce en la práctica.

### Poda (pruning)

La clave para que backtracking sea viable es **podar** ramas inválidas lo antes posible:

- En N-Reinas, descartar columnas y diagonales atacadas antes de profundizar.
- En problemas de optimización, descartar ramas que ya superan el mejor valor encontrado.

### Otros ejemplos

- Resolver un **Sudoku**.
- Subconjuntos cuya suma es un valor (subset sum).
- Laberintos y búsqueda de caminos.
- Combinaciones y subconjuntos.

---

## Resumen de complejidades

### Ordenamiento

| Algoritmo | Tiempo promedio | Peor caso | Espacio | Estable |
|-----------|----------------|-----------|---------|---------|
| Bubble | O(n²) | O(n²) | O(1) | Sí |
| Insertion | O(n²) | O(n²) | O(1) | Sí |
| Merge | O(n log n) | O(n log n) | O(n) | Sí |
| Quick | O(n log n) | O(n²) | O(log n) | No |
| Heap | O(n log n) | O(n log n) | O(1) | No |

### Búsqueda

| Algoritmo | Tiempo | Requisito |
|-----------|--------|-----------|
| Lineal | O(n) | ninguno |
| Binaria | O(log n) | array ordenado |
| BFS / DFS | O(V+E) | estructura de grafo |

### Otros

| Técnica | Cuándo | Complejidad típica |
|---------|--------|--------------------|
| Divide y vencerás | Partes independientes | O(n log n) |
| DP | subproblemas solapados | O(n²) o similar |
| Greedy | elección local óptima | O(n log n) |
| Backtracking | explorar todas las soluciones | O(2ⁿ) o O(n!) con poda |

---

## Resumen

- **Big O** describe el crecimiento asintótico, ignorando constantes.
- Los algoritmos **comparativos** no bajan de O(n log n) en promedio.
- **Merge sort** es estable y garantizado; **quick sort** es rápido en promedio; **heap sort** es in-place.
- La **búsqueda binaria** requiere datos ordenados y da O(log n).
- La **recursión** es elegante pero cuidado con la pila; la **tail recursion** puede optimizarse.
- La **DP** aprovecha subproblemas solapados con memoización o tabulación.
- Los **greedy** son rápidos pero solo óptimos bajo condiciones concretas.
- El **backtracking** explora todas las soluciones con poda para ser viable.

> Siguiente: [system-design.md](system-design.md)
