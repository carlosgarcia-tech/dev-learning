# Ejercicio 14 — Mixins y Módulos

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crea un módulo `Volador` con método `volar`
2. Crea un módulo `Nadador` con método `nadar`
3. Crea una clase `Pato` que incluya ambos módulos

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
module Volador
  def volar
    puts "#{self.class}: Volando"
  end
end

module Nadador
  def nadar
    puts "#{self.class}: Nadando"
  end
end

class Pato
  include Volador
  include Nadador

  def hacer_sonido
    puts "¡Cuac!"
  end
end

pato = Pato.new
pato.volar
pato.nadar
```

</details>
