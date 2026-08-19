# Ejercicio 20 — Metaprogramación

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 35 minutos

## Enunciado

1. Define métodos dinámicamente
2. Usa `define_method`
3. Usa `method_missing`

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
class Dinamico
  [:saludar, :despedir, :presentar].each do |nombre|
    define_method(nombre) do |*args|
      puts "Método #{nombre} llamado con #{args.inspect}"
    end
  end

  def method_missing(nombre, *args, &block)
    if nombre.to_s.start_with?("obtener_")
      puts "Obteniendo #{nombre.to_s.gsub('obtener_', '')}"
    else
      super
    end
  end

  def respond_to_missing?(nombre, include_private = false)
    nombre.to_s.start_with?("obtener_") || super
  end
end

d = Dinamico.new
d.saludar("Ana")
d.obtener_usuario
d.obtener_producto
```

</details>
