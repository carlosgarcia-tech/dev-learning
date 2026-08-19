# Ejercicio 16 — Lambdas

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Crea una lambda que calcule el cuadrado de un número
2. Crea una lambda que filtre números pares
3. Usa ambas con arrays

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
cuadrado = lambda { |x| x * x }
es_par = lambda { |x| x.even? }

numeros = [1, 2, 3, 4, 5]

puts numeros.map(&cuadrado).inspect
puts numeros.select(&es_par).inspect
```

</details>
