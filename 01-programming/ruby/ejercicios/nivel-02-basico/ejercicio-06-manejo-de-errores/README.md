# Ejercicio 12 — Manejo de Errores

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Implementa un método que divida y maneje división por cero
2. Crea una excepción personalizada
3. Usa `begin-rescue-ensure`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class MiError < StandardError
  def initialize(message = "Error personalizado")
    super(message)
  end
end

def dividir(a, b)
  raise MiError, "División por cero" if b == 0
  a / b
end

begin
  resultado = dividir(10, 0)
  puts resultado
rescue MiError => e
  puts "Error capturado: #{e.message}"
ensure
  puts "Siempre se ejecuta"
end
```

</details>
