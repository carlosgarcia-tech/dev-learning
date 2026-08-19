# Ejercicio 07 — Métodos

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

Implementa los métodos:
1. `sumar(a, b)`: retorna la suma
2. `restar(a, b)`: retorna la resta
3. `multiplicar(a, b)`: retorna el producto
4. `dividir(a, b)`: retorna el cociente y maneja división por cero

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
def sumar(a, b)
  a + b
end

def restar(a, b)
  a - b
end

def multiplicar(a, b)
  a * b
end

def dividir(a, b)
  return nil, "División por cero" if b == 0
  return a / b, nil
end

puts "10 + 5 = #{sumar(10, 5)}"
puts "10 - 5 = #{restar(10, 5)}"
puts "10 * 5 = #{multiplicar(10, 5)}"
resultado, error = dividir(10, 5)
puts "10 / 5 = #{resultado}" if resultado
resultado, error = dividir(10, 0)
puts "Error: #{error}" if error
```

</details>
