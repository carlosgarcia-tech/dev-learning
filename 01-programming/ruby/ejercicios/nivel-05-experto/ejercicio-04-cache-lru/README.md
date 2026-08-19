# Ejercicio 28 — Cache LRU

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 45 minutos

## Enunciado

Implementa un cache LRU con:
- Capacidad limitada
- Operaciones: get, put
- Evicta el menos usado recientemente

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class CacheLRU
  def initialize(capacidad)
    @capacidad = capacidad
    @cache = {}
    @orden = []
  end

  def obtener(clave)
    if @cache.key?(clave)
      @orden.delete(clave)
      @orden.push(clave)
      return @cache[clave]
    end
    nil
  end

  def guardar(clave, valor)
    if @cache.key?(clave)
      @orden.delete(clave)
    elsif @orden.size >= @capacidad
      mas_antiguo = @orden.shift
      @cache.delete(mas_antiguo)
    end

    @cache[clave] = valor
    @orden.push(clave)
  end

  def mostrar
    @orden.map { |clave| [clave, @cache[clave]] }
  end
end

cache = CacheLRU.new(3)
cache.guardar("a", 1)
cache.guardar("b", 2)
cache.guardar("c", 3)
cache.obtener("a")
cache.guardar("d", 4)
puts cache.mostrar.inspect # [["c", 3], ["a", 1], ["d", 4]]  ("b" fue evictado por ser el menos usado)
```

</details>
