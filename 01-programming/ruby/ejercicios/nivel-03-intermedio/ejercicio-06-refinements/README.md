# Ejercicio 18 — Refinements

- **Nivel:** 3/5
- **Tema:** Intermedio de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

Crea un refinamiento para String que:
1. Añada `to_camel_case`
2. Añada `to_snake_case`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
module StringRefinements
  refine String do
    def to_camel_case
      split.map(&:capitalize).join
    end

    def to_snake_case
      gsub(/([A-Z])/, '_\1').downcase
    end
  end
end

using StringRefinements

puts "hola mundo".to_camel_case
puts "HolaMundo".to_snake_case
```

</details>
