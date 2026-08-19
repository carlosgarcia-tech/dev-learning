# Ejercicio 08 — Bloques y Procs

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crea un método que reciba un bloque y lo ejecute
2. Crea un Proc que multiplique por 2 y úsalo con `map`
3. Crea una lambda que verifique si un número es par

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
def ejecutar_bloque
  puts "Antes del bloque"
  yield if block_given?
  puts "Después del bloque"
end

ejecutar_bloque { puts "Bloque ejecutado" }

multiplicar_por_2 = Proc.new { |x| x * 2 }
numeros = [1, 2, 3, 4, 5]
puts numeros.map(&multiplicar_por_2).inspect

es_par = lambda { |x| x.even? }
puts es_par.call(4)  # true
puts es_par.call(5)  # false
```

</details>
