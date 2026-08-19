# Ejercicio 27 — API REST Mínima

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 60 minutos

## Enunciado

Desarrolla una API REST con:
- CRUD de productos
- JSON como formato
- Sin dependencias externas

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
require "json"

class APIProductos
  def initialize
    @productos = []
    @contador = 0
  end

  def crear(params)
    @contador += 1
    producto = { id: @contador, nombre: params[:nombre], precio: params[:precio] }
    @productos << producto
    { status: "created", data: producto }
  end

  def listar
    { status: "success", data: @productos }
  end

  def obtener(id)
    producto = @productos.find { |p| p[:id] == id }
    if producto
      { status: "success", data: producto }
    else
      { status: "not_found", data: nil }
    end
  end

  def actualizar(id, params)
    producto = @productos.find { |p| p[:id] == id }
    if producto
      producto[:nombre] = params[:nombre] if params[:nombre]
      producto[:precio] = params[:precio] if params[:precio]
      { status: "updated", data: producto }
    else
      { status: "not_found", data: nil }
    end
  end

  def eliminar(id)
    producto = @productos.find { |p| p[:id] == id }
    if producto
      @productos.delete(producto)
      { status: "deleted", data: nil }
    else
      { status: "not_found", data: nil }
    end
  end
end

if __FILE__ == $0
  api = APIProductos.new
  creado = api.crear(nombre: "Laptop", precio: 999.99)
  puts creado.to_json
  puts api.listar.to_json
  puts api.actualizar(creado[:data][:id], precio: 899.99).to_json
  puts api.eliminar(creado[:data][:id]).to_json
end
```

</details>
