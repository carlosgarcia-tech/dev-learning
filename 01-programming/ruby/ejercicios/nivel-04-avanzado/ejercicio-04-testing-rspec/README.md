# Ejercicio 22 — Testing con RSpec

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Instala RSpec
2. Escribe tests para una clase `Calculadora`
3. Usa `describe`, `context`, `it`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
# calculadora.rb
class Calculadora
  def sumar(a, b) = a + b
  def restar(a, b) = a - b
  def multiplicar(a, b) = a * b

  def dividir(a, b)
    raise "División por cero" if b == 0
    a / b
  end
end

# spec/calculadora_spec.rb
require "rspec"
require_relative "../calculadora"

RSpec.describe Calculadora do
  let(:calc) { Calculadora.new }

  describe "#sumar" do
    it "suma dos números" do
      expect(calc.sumar(2, 3)).to eq(5)
    end
  end

  describe "#dividir" do
    it "lanza error al dividir por cero" do
      expect { calc.dividir(10, 0) }.to raise_error("División por cero")
    end
  end
end
```

</details>
