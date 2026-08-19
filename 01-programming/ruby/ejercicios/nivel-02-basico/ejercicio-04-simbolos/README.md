# Ejercicio 10 — Símbolos

- **Nivel:** 2/5
- **Tema:** Básico de Ruby
- **Tiempo estimado:** 20 minutos

## Enunciado

1. Crea un hash con símbolos como claves
2. Convierte strings a símbolos
3. Compara símbolos y strings

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
persona = { nombre: "Ana", edad: 30, ciudad: "Madrid" }

puts persona[:nombre]  # Ana

texto = "nombre"
simbolo = texto.to_sym
puts persona[simbolo]  # Ana

# Comparación
puts :nombre == "nombre"        # false
puts :nombre.to_s == "nombre"   # true
puts :nombre == :nombre         # true
```

</details>
