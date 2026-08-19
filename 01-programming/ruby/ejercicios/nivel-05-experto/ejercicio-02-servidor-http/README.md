# Ejercicio 26 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 45 minutos

## Enunciado

Crea un servidor HTTP básico que:
1. Sirva archivos estáticos
2. Maneje diferentes rutas
3. Retorne respuestas JSON

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
require "socket"
require "json"

class ServidorHTTP
  def initialize(puerto = 3000)
    @puerto = puerto
  end

  def iniciar
    servidor = TCPServer.new(@puerto)
    puts "Servidor HTTP en puerto #{@puerto}"

    loop do
      cliente = servidor.accept
      manejar_cliente(cliente)
      cliente.close
    end
  end

  def manejar_cliente(cliente)
    request = cliente.gets
    return unless request

    metodo, path, _ = request.split(" ")
    puts "#{metodo} #{path}"

    respuesta = case path
    when "/"
      "Bienvenido al servidor HTTP"
    when "/json"
      { mensaje: "Hola JSON", hora: Time.now }.to_json
    else
      "Ruta no encontrada"
    end

    cliente.puts "HTTP/1.1 200 OK"
    cliente.puts "Content-Type: text/plain"
    cliente.puts "Content-Length: #{respuesta.bytesize}"
    cliente.puts "Connection: close"
    cliente.puts
    cliente.puts respuesta
  end
end

if __FILE__ == $0
  servidor = ServidorHTTP.new(3000)
  servidor.iniciar
end
```

</details>
