# Estructuras de Datos

> Guía completa de estructuras de datos: qué son, cómo funcionan, sus complejidades y cuándo usar cada una.

## Índice

1. [Arrays](#arrays)
2. [Linked Lists](#linked-lists)
3. [Stacks](#stacks)
4. [Queues](#queues)
5. [Hash Tables](#hash-tables)
6. [Trees](#trees)
7. [Heaps](#heaps)
8. [Graphs](#graphs)
9. [Trie](#trie)
10. [Tabla comparativa de complejidades](#tabla-comparativa-de-complejidades)

---

## Arrays

Un **array** (arreglo) es una colección de elementos del mismo tipo almacenados de forma contigua en memoria. El acceso por índice es O(1) porque se calcula la dirección con: `dirección = base + índice * tamaño`.

### Tipos

- **Estático:** tamaño fijo definido al crearse.
- **Dinámico:** puede crecer (ej: `list` en Python, `ArrayList` en Java, `std::vector` en C++). Al llenarse, se duplica el tamaño subyacente y se copian los elementos.

### Operaciones y complejidad

| Operación | Array estático | Array dinámico |
|-----------|----------------|----------------|
| Acceso por índice | O(1) | O(1) |
| Búsqueda | O(n) | O(n) |
| Inserción al final | — | O(1) amortizado |
| Inserción al inicio/medio | O(n) | O(n) |
| Borrado al inicio/medio | O(n) | O(n) |

### Ejemplo (Python)

```python
arr = [10, 20, 30, 40]
arr.append(50)          # [10, 20, 30, 40, 50]  O(1) amortizado
arr.insert(0, 5)        # [5, 10, 20, 30, 40, 50]  O(n)
arr.pop()               # quita 50  O(1)
arr[2]                  # acceso O(1) -> 20
```

### Por qué duplicar el tamaño

Al doblar la capacidad en cada crecimiento, el coste amortizado de insertar es O(1): aunque una inserción concreta cueste O(n) por copiar, esa copia ocurre cada vez más espaciada.

### Cuándo usar

- Tamaño conocido y estable.
- Acceso aleatorio frecuente por índice.
- Localidad de caché importante (los elementos están juntos en memoria).

---

## Linked Lists

Una **lista enlazada** es una secuencia de nodos, cada uno con un valor y un puntero al siguiente nodo. No están contiguos en memoria.

### Tipos

- **Singly linked (simple):** cada nodo apunta al siguiente.
- **Doubly linked (doble):** cada nodo apunta al siguiente y al anterior.
- **Circular:** el último nodo apunta al primero.

```
Simple:   [A|*] -> [B|*] -> [C|*] -> null

Doble:   null <- [A] <-> [B] <-> [C] -> null
```

### Operaciones y complejidad

| Operación | Singly | Doubly |
|-----------|--------|--------|
| Acceso por índice | O(n) | O(n) |
| Búsqueda | O(n) | O(n) |
| Inserción al inicio | O(1) | O(1) |
| Inserción al final (con tail) | O(1) | O(1) |
| Inserción en medio (con nodo dado) | O(1) | O(1) |
| Borrado de un nodo dado | O(n) (necesita anterior) | O(1) |

### Ejemplo (Python)

```python
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def prepend(self, value):
        node = Node(value)
        node.next = self.head
        self.head = node

    def append(self, value):
        node = Node(value)
        if not self.head:
            self.head = node
            return
        cur = self.head
        while cur.next:
            cur = cur.next
        cur.next = node

    def find(self, value):
        cur = self.head
        while cur:
            if cur.value == value:
                return cur
            cur = cur.next
        return None
```

### Cuándo usar

- Inserciones/eliminaciones frecuentes en los extremos sin mover memoria.
- Tamaño muy variable o desconocido de antemano.
- No necesitas acceso aleatorio por índice.

---

## Stacks

Un **stack** (pila) es una colección **LIFO** (Last In, First Out): el último elemento en entrar es el primero en salir.

```
push(1) push(2) push(3)   ->   [1, 2, 3] (tope = 3)
pop() -> 3                ->   [1, 2]
peek() -> 2
```

### Operaciones y complejidad

| Operación | Complejidad |
|-----------|-------------|
| push (apilar) | O(1) |
| pop (desapilar) | O(1) |
| peek (ver tope) | O(1) |
| búsqueda | O(n) |

### Implementación

Se puede implementar con un array o con una linked list. Ambas dan O(1) en las operaciones clave.

### Ejemplo (Python)

```python
stack = []
stack.append(10)   # push
stack.append(20)
top = stack[-1]    # peek -> 20
stack.pop()        # pop -> 20
```

### Casos de uso

- **Call stack** de funciones (recursión).
- Deshacer/rehacer (undo/redo).
- Evaluación de expresiones y paréntesis balanceados.
- Recorrido DFS de grafos y árboles.
- Conversión infix → postfix.

### Ejemplo: paréntesis balanceados

```python
def balanced(s):
    pairs = {')': '(', ']': '[', '}': '{'}
    stack = []
    for ch in s:
        if ch in '([{':
            stack.append(ch)
        elif ch in ')]}':
            if not stack or stack.pop() != pairs[ch]:
                return False
    return not stack
```

---

## Queues

Una **queue** (cola) es una colección **FIFO** (First In, First Out): el primer elemento en entrar es el primero en salir.

```
enqueue(1) enqueue(2) enqueue(3)   ->  frente [1, 2, 3] final
dequeue() -> 1                     ->  [2, 3]
```

### Variantes

| Tipo | Descripción |
|------|-------------|
| Queue simple | FIFO estándar |
| Deque | Inserción y borrado por ambos extremos |
| Priority Queue | El de mayor prioridad sale primero |
| Circular Queue | Reutiliza espacio de forma circular |
| Monotonic Queue | Mantiene orden para optimizar consultas |

### Operaciones y complejidad

| Operación | Complejidad |
|-----------|-------------|
| enqueue | O(1) |
| dequeue | O(1) |
| peek (frente) | O(1) |
| búsqueda | O(n) |

> Implementar una queue con array desplazando elementos hace dequeue O(n). Para O(1) se usa un array circular o una linked list.

### Ejemplo (Python)

```python
from collections import deque

q = deque()
q.append(1)      # enqueue
q.append(2)
q.popleft()      # dequeue -> 1
q[0]             # peek frente -> 2
```

### Casos de uso

- Buffers y colas de tareas.
- BFS en grafos y árboles.
- Planificación round-robin del SO.
- Productor-consumidor y colas de mensajes.

---

## Hash Tables

Una **hash table** (tabla hash / diccionario / mapa) almacena pares clave-valor. Usa una **función hash** que convierte la clave en un índice del array interno.

```
clave "edad" --hash()--> índice 7 -> bucket[7] = (edad, 30)
```

### Función hash

Idealmente distribuye las claves de forma uniforme para evitar colisiones. Propiedades: determinista, rápida, uniforme.

### Colisiones

Cuando dos claves producen el mismo índice. Estrategias:

| Estrategia | Descripción |
|-----------|-------------|
| Chaining (encadenamiento) | Cada bucket es una linked list con todos los elementos colisionados |
| Open addressing | Se busca otro bucket libre (linear probing, quadratic probing, double hashing) |
| Robin Hood hashing | Variante de open addressing que minimiza la varianza |

### Factor de carga

`load factor = elementos / número de buckets`. Cuando supera un umbral (típicamente 0.7), se hace un **rehash**: se duplica el tamaño del array y se recalculan todos los índices.

### Operaciones y complejidad

| Operación | Promedio | Peor caso |
|-----------|----------|-----------|
| Búsqueda | O(1) | O(n) |
| Inserción | O(1) | O(n) |
| Borrado | O(1) | O(n) |

El peor caso ocurre cuando todas las claves colisionan en el mismo bucket (función hash mala o entrada maliciosa).

### Ejemplo (Python)

```python
d = {}
d["nombre"] = "Ada"
d["edad"] = 36
print(d["nombre"])   # Ada
"edad" in d          # True
del d["edad"]
```

### Cuándo usar

- Búsquedas, inserciones y borrados muy frecuentes por clave.
- Cachés y memoización.
- Contar frecuencias.
- Implementar conjuntos (set).

---

## Trees

Un **árbol** es una jerarquía de nodos. Hay un nodo raíz y cada nodo tiene cero o más hijos. No hay ciclos.

```
        [Raiz]
       /   \
     [A]   [B]
     / \
   [C] [D]
```

### Terminología

| Término | Significado |
|---------|-------------|
| Raíz (root) | Nodo superior |
| Hoja (leaf) | Nodo sin hijos |
| Altura | Distancia máxima de raíz a hoja |
| Profundidad | Distancia de la raíz a un nodo |
| Grado | Número de hijos de un nodo |

### BST (Binary Search Tree)

Árbol binario donde, para cada nodo: los valores del subárbol izquierdo son menores y los del derecho son mayores.

```
        8
       / \
      3   10
     / \    \
    1   6    14
       / \   /
      4   7 13
```

| Operación | Promedio | Peor caso (degenerado) |
|-----------|----------|------------------------|
| Búsqueda | O(log n) | O(n) |
| Inserción | O(log n) | O(n) |
| Borrado | O(log n) | O(n) |

Un BST puede degenerar en una lista enlazada si se insertan datos ya ordenados. Para garantizar O(log n) se usan árboles **auto-balanceados**.

### AVL

Árbol binario de búsqueda **auto-balanceado**: la diferencia de altura entre subárboles de cualquier nodo es como máximo 1 (**factor de balance** ∈ {-1, 0, 1}).

Cuando una inserción o borrado rompe el balance, se aplican **rotaciones**:

- Rotación simple a la derecha (LL).
- Rotación simple a la izquierda (RR).
- Rotación doble izquierda-derecha (LR).
- Rotación doble derecha-izquierda (RL).

```
    desbalanceado            balanceado tras rotación
        30                         20
       /                          /  \
      20          -->            10    30
     /
    10
```

Propiedad: está más estrictamente balanceado que un Red-Black, así que las búsquedas son algo más rápidas, pero las inserciones pueden requerir más rotaciones.

### Red-Black Tree

Árbol binario de búsqueda balanceado con estas reglas:

1. Cada nodo es rojo o negro.
2. La raíz es negra.
3. Las hojas (NIL) son negras.
4. Un nodo rojo no puede tener hijos rojos (no dos rojos seguidos).
5. Todo camino de un nodo a sus hojas NIL tiene el mismo número de nodos negros.

Esas reglas garantizan que la altura sea O(log n), de modo que todas las operaciones son O(log n).

| Árbol | Balance | Búsqueda | Inserción/Borrado |
|-------|---------|----------|-------------------|
| AVL | Muy estricto | Más rápida | Más rotaciones |
| Red-Black | Menos estricto | Algo más lenta | Menos rotaciones, mejor para muchas escrituras |

`std::map` y `std::set` de C++ y el `TreeMap` de Java usan Red-Black trees.

### Recorridos

| Recorrido | Orden | Uso |
|-----------|-------|-----|
| In-order | Izquierda, Raíz, Derecha | Obtiene elementos ordenados en un BST |
| Pre-order | Raíz, Izquierda, Derecha | Copiar un árbol, prefijos |
| Post-order | Izquierda, Derecha, Raíz | Liberar un árbol, postfijo |
| Level-order | Por niveles (BFS) | Recorrido por anchura |

```python
def inorder(node):
    if node:
        inorder(node.left)
        print(node.value)
        inorder(node.right)
```

---

## Heaps

Un **heap** es un árbol binario completo que satisface la propiedad de heap:

- **Max-heap:** cada padre es mayor o igual que sus hijos.
- **Min-heap:** cada padre es menor o igual que sus hijos.

```
Max-heap:        100
                /   \
              80     70
             / \    /
            40 50  60
```

### Implementación con array

Al ser completo, se puede representar en un array sin punteros. Para un nodo en el índice `i` (base 0):

- Padre: `(i - 1) // 2`
- Hijo izquierdo: `2*i + 1`
- Hijo derecho: `2*i + 2`

### Operaciones y complejidad

| Operación | Complejidad |
|-----------|-------------|
| Peek (ver raíz) | O(1) |
| Insert | O(log n) |
| Extract max/min | O(log n) |
| Heapify (build heap) | O(n) |
| Búsqueda | O(n) |

### Insertar (sift up)

1. Se añade el elemento al final del array.
2. Se compara con el padre y se intercambia si es necesario.
3. Se repite hasta que cumpla la propiedad o llegue a la raíz.

### Extraer raíz (sift down)

1. Se guarda la raíz (máx/mín).
2. Se mueve el último elemento a la raíz.
3. Se compara con los hijos y se intercambia con el mayor (max-heap).
4. Se repite hasta cumplir la propiedad.

### Ejemplo (Python)

```python
import heapq

h = []
heapq.heappush(h, 5)     # min-heap por defecto
heapq.heappush(h, 2)
heapq.heappush(h, 8)
heapq.heappop(h)         # -> 2 (el menor)
h[0]                     # peek -> 5

# heapify en O(n)
arr = [3, 1, 4, 1, 5, 9]
heapq.heapify(arr)
```

### Casos de uso

- Priority queues.
- Heapsort (O(n log n) in-place).
- Encontrar los k elementos mayores/menores (k-largest).
- Algoritmos de grafos: Prim y Dijkstra.

---

## Graphs

Un **grafo** es un conjunto de **vértices** (nodos) unidos por **aristas** (arcs).

### Tipos

| Tipo | Descripción |
|------|-------------|
| Dirigido | Las aristas tienen dirección (A → B) |
| No dirigido | Sin dirección (A — B) |
| Ponderado | Las aristas tienen un coste |
| No ponderado | Todas las aristas cuestan igual |
| Cíclico / Acíclico | Contiene / no contiene ciclos |
| DAG | Grafo Dirigido Acíclico (base de topological sort) |

### Representaciones

| Representación | Memoria | Vecinos de v |
|-----------------|---------|--------------|
| Matriz de adyacencia | O(V²) | O(V) |
| Lista de adyacencia | O(V + E) | O(grado(v)) |
| Lista de aristas | O(E) | O(E) |

```python
# Lista de adyacencia
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D'],
    'C': ['A'],
    'D': ['B']
}

# Matriz de adyacencia
#      A  B  C  D
#  A [ 0  1  1  0 ]
#  B [ 1  0  0  1 ]
#  C [ 1  0  0  0 ]
#  D [ 0  1  0  0 ]
```

### Recorridos

#### BFS (Breadth-First Search)

Explora por niveles usando una **cola**. Encuentra el camino más corto en grafos no ponderados.

```python
from collections import deque

def bfs(graph, start):
    visited = {start}
    queue = deque([start])
    while queue:
        node = queue.popleft()
        print(node)
        for n in graph[node]:
            if n not in visited:
                visited.add(n)
                queue.append(n)
```

- Complejidad: O(V + E).

#### DFS (Depth-First Search)

Explora a fondo cada rama usando una **pila** (o recursión).

```python
def dfs(graph, node, visited=None):
    if visited is None:
        visited = set()
    visited.add(node)
    print(node)
    for n in graph[node]:
        if n not in visited:
            dfs(graph, n, visited)
```

- Complejidad: O(V + E).

### Algoritmos importantes

| Algoritmo | Para qué | Complejidad |
|-----------|----------|-------------|
| Dijkstra | Camino mínimo con pesos no negativos | O((V+E) log V) |
| Bellman-Ford | Camino mínimo con pesos negativos | O(V·E) |
| Floyd-Warshall | Todos los pares de caminos mínimos | O(V³) |
| Kruskal / Prim | Árbol de expansión mínima | O(E log V) |
| Topological sort | Orden de tareas en un DAG | O(V + E) |
| Tarjan / Kosaraju | Componentes fuertemente conexos | O(V + E) |

---

## Trie

Un **trie** (árbol de prefijos) almacena strings compartiendo prefijos comunes. Cada arista representa un carácter.

```
Insertar: "cat", "car", "dog"

         (root)
        /      \
       c        d
      /          \
     a            o
    / \            \
   t   r            g
```

### Operaciones y complejidad

| Operación | Complejidad |
|-----------|-------------|
| Insertar | O(m) |
| Buscar | O(m) |
| Borrar | O(m) |
| Buscar prefijo | O(m) |

Donde `m` es la longitud de la palabra. **No depende del número de palabras almacenadas**, a diferencia de un hash set que crece con el total de claves.

### Ejemplo (Python)

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for ch in word:
            if ch not in node.children:
                node.children[ch] = TrieNode()
            node = node.children[ch]
        node.is_end = True

    def search(self, word):
        node = self._walk(word)
        return node is not None and node.is_end

    def starts_with(self, prefix):
        return self._walk(prefix) is not None

    def _walk(self, s):
        node = self.root
        for ch in s:
            if ch not in node.children:
                return None
            node = node.children[ch]
        return node
```

### Casos de uso

- Autocompletado.
- Correctores ortográficos.
- Enrutamiento por prefijo de IP.
- Diccionarios de palabras.
- Compresión de prefijos compartidos.

### Variantes

- **Compressed trie (radix tree):** comprime cadenas de un solo hijo.
- **Suffix tree:** trie de todos los sufijos de un texto, para búsqueda de patrones en O(m).

---

## Tabla comparativa de complejidades

| Estructura | Acceso | Búsqueda | Inserción | Borrado | Memoria |
|------------|--------|----------|-----------|---------|---------|
| Array | O(1) | O(n) | O(n) | O(n) | O(n) |
| Array dinámico | O(1) | O(n) | O(1) amort. | O(n) | O(n) |
| Linked List | O(n) | O(n) | O(1)† | O(1)† | O(n) |
| Stack | O(n)† | O(n) | O(1) | O(1) | O(n) |
| Queue | O(n)† | O(n) | O(1) | O(1) | O(n) |
| Hash Table | — | O(1) | O(1) | O(1) | O(n) |
| BST | O(log n)‡ | O(log n)‡ | O(log n)‡ | O(log n)‡ | O(n) |
| AVL / Red-Black | O(log n) | O(log n) | O(log n) | O(log n) | O(n) |
| Heap | — | O(n) | O(log n) | O(log n)† | O(n) |
| Trie (longitud m) | — | O(m) | O(m) | O(m) | O(Σ·L) |

† solo en los extremos o con referencia al nodo. ‡ si está balanceado; O(n) si degenera.

---

## Resumen

- **Arrays:** acceso O(1), mala inserción. Buena localidad de caché.
- **Linked lists:** inserción O(1), mal acceso por índice.
- **Stacks y queues:** LIFO y FIFO, O(1) en los extremos.
- **Hash tables:** O(1) promedio para todo, pero sin orden.
- **Trees balanceados:** O(log n) garantizado y mantienen orden.
- **Heaps:** O(1) para el extremo y O(log n) para insertar/extraer; base de las priority queues.
- **Graphs:** modelan relaciones; BFS/DFS en O(V+E).
- **Trie:** eficiente para búsquedas por prefijo.

> Siguiente: [algorithms.md](algorithms.md)
