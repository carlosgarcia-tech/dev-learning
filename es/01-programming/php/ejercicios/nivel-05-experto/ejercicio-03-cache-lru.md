# Ejercicio 03 — Caché LRU

- **Nivel:** 5/5
- **Tema:** estructura de datos, LRU (Least Recently Used), orden de inserción en arrays
- **Tiempo estimado:** 40 min

## Enunciado

Completa la clase `CacheLru` en `ejercicio-03-cache-lru.php`:

1. Constructor `__construct(int $capacidad)` con `capacidad >= 1`.
2. `poner(string $clave, mixed $valor)`: guarda el valor; si la clave ya existe, la actualiza y la marca como la más reciente. Si el tamaño supera la capacidad, **expulsa la clave menos recientemente usada**.
3. `obtener(string $clave)`: devuelve el valor y lo marca como el más reciente; `null` si no existe.
4. `tiene(string $clave)`: `true` si existe.
5. `tamano(): int` y `capacidad(): int`.

Pista de implementación: un array asociativo conserva el orden de inserción; `unset()` + reinsertar mueve una clave al final (= más reciente).

## Requisitos

- [ ] Con capacidad 2, `poner("a"), poner("b"), poner("c")` expulsa `"a"`.
- [ ] `obtener` no devuelve claves expulsadas.
- [ ] `obtener("a")` la marca como reciente y al insertar la siguiente se expulsa la correcta.
- [ ] `tamano()` nunca supera la capacidad.
- [ ] Los tests pasan: `php ejercicio-03-cache-lru_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$this->items[$clave] = $valor;` al final del array.
- `unset($this->items[$clave]); $this->items[$clave] = $valor;` para mover al final.
- `array_key_first($this->items)` devuelve la clave más antigua.
- `count($this->items)` para el tamaño.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
class CacheLru
{
    private array $items = [];

    public function __construct(private int $capacidad)
    {
        if ($capacidad < 1) {
            throw new InvalidArgumentException("La capacidad debe ser al menos 1");
        }
    }

    public function poner(string $clave, mixed $valor): void
    {
        unset($this->items[$clave]);
        $this->items[$clave] = $valor;

        if (count($this->items) > $this->capacidad) {
            $masAntigua = array_key_first($this->items);
            unset($this->items[$masAntigua]);
        }
    }

    public function obtener(string $clave): mixed
    {
        if (!array_key_exists($clave, $this->items)) {
            return null;
        }
        $valor = $this->items[$clave];
        unset($this->items[$clave]);
        $this->items[$clave] = $valor;
        return $valor;
    }

    public function tiene(string $clave): bool
    {
        return array_key_exists($clave, $this->items);
    }

    public function tamano(): int
    {
        return count($this->items);
    }

    public function capacidad(): int
    {
        return $this->capacidad;
    }
}
````

</details>