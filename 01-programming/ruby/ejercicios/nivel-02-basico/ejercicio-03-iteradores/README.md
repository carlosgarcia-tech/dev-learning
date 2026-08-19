# Ejercicio 09 — Iteradores

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

Crea una clase `Coleccion` que:
1. Incluya `Enumerable`
2. Implemente `each`
3. Use métodos como `map`, `select`, `reduce`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Coleccion
  include Enumerable

  def initialize(*elementos)
    @elementos = elementos
  end

  def each
    @elementos.each { |e| yield(e) }
  end
end

coleccion = Coleccion.new(1, 2, 3, 4, 5)

puts coleccion.map { |x| x * 2 }.inspect
puts coleccion.select { |x| x.even? }.inspect
puts coleccion.reduce(:+)
```

</details>
