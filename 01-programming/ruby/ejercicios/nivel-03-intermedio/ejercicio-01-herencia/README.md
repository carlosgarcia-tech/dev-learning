# Ejercicio 13 — Herencia

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

Crea una jerarquía de clases:
- `Animal` (base) con `nombre` y `hacer_sonido`
- `Perro` y `Gato` (hijas) que sobrescriban `hacer_sonido`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Animal
  attr_reader :nombre

  def initialize(nombre)
    @nombre = nombre
  end

  def hacer_sonido
    puts "El animal hace un sonido"
  end
end

class Perro < Animal
  def hacer_sonido
    puts "#{@nombre}: ¡Guau!"
  end
end

class Gato < Animal
  def hacer_sonido
    puts "#{@nombre}: ¡Miau!"
  end
end

perro = Perro.new("Rex")
gato = Gato.new("Mishi")
perro.hacer_sonido
gato.hacer_sonido
```

</details>
