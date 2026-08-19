# Ejercicio 15 — Enumerable

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

Crea una clase `RangoPersonalizado` que:
1. Incluya `Enumerable`
2. Implemente `each`
3. Use `map`, `select`, `reduce`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class RangoPersonalizado
  include Enumerable

  def initialize(inicio, fin)
    @inicio = inicio
    @fin = fin
  end

  def each
    (@inicio..@fin).each { |i| yield(i) }
  end
end

rango = RangoPersonalizado.new(0, 5)
puts rango.map { |x| x * 2 }.inspect
puts rango.select { |x| x.even? }.inspect
puts rango.reduce(:+)
```

</details>
