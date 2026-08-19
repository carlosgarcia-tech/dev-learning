# Ejercicio 23 — Gems y Bundler

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 25 minutos

## Enunciado

1. Crea un Gemfile
2. Agrega gemas: 'json', 'httparty'
3. Usa la gema en el código

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
# Gemfile:
#   source "https://rubygems.org"
#   gem "httparty"
#   gem "json"

require "httparty"
require "json"

response = HTTParty.get("https://jsonplaceholder.typicode.com/posts/1")
data = JSON.parse(response.body)
puts "Título: #{data['title']}"
```

</details>
