# Ejercicio 17 — Attributes

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Crea una clase con `attr_accessor`, `attr_reader`, `attr_writer`
2. Demuestra el uso de cada uno

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Usuario
  attr_accessor :nombre   # getter y setter
  attr_reader :id         # solo getter
  attr_writer :password   # solo setter

  def initialize(nombre)
    @nombre = nombre
    @id = rand(1000)
  end
end

usuario = Usuario.new("Ana")
puts usuario.nombre
usuario.nombre = "Ana María"
puts usuario.id
usuario.password = "secreto"
```

</details>
