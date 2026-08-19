# Ejercicio 11 — Clases Básicas

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

Crea una clase `Persona` con:
- Atributos: `nombre`, `edad`, `email`
- Getters y setters
- Constructor
- Método `presentarse`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Persona
  attr_accessor :nombre, :edad, :email

  def initialize(nombre, edad, email)
    @nombre = nombre
    @edad = edad
    @email = email
  end

  def presentarse
    puts "Hola, soy #{@nombre}, tengo #{@edad} años y mi email es #{@email}"
  end
end

persona = Persona.new("Ana", 30, "ana@email.com")
persona.presentarse
```

</details>
