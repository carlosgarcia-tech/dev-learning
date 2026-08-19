# 05 — Errores y Gems en Ruby

## Objetivos

- [ ] Manejar excepciones con begin-rescue
- [ ] Crear excepciones personalizadas
- [ ] Usar ensure, retry, raise
- [ ] Trabajar con gems (bibliotecas)
- [ ] Usar Bundler para gestionar dependencias

## Apuntes

### Manejo de Excepciones

```ruby
# Estructura básica
begin
  # Código que puede lanzar excepción
  resultado = 10 / 0
rescue ZeroDivisionError => e
  puts "Error: #{e.message}"
rescue StandardError => e
  puts "Error general: #{e.message}"
else
  puts "Sin errores: #{resultado}"
ensure
  puts "Siempre se ejecuta"
end

# raise - lanzar excepción
def dividir(a, b)
  raise ArgumentError, "Divisor no puede ser cero" if b == 0
  a / b
end

# Excepciones personalizadas
class MiError < StandardError
  attr_reader :codigo

  def initialize(message, codigo)
    super(message)
    @codigo = codigo
  end
end

begin
  raise MiError.new("Algo salió mal", 500)
rescue MiError => e
  puts "Error #{e.codigo}: #{e.message}"
end

# retry - reintentar
intentos = 0
begin
  intentos += 1
  puts "Intento #{intentos}"
  raise "Error" if intentos < 3
rescue
  retry if intentos < 3
end
```

### Gems - Bibliotecas

```ruby
# Instalar una gem
# gem install nombre_gem

# Usar una gem
require 'json'
require 'net/http'
```

Archivo `Gemfile` de ejemplo:

```ruby
source "https://rubygems.org"

gem "rails"
gem "sinatra"
gem "json"
gem "httparty"

group :development do
  gem "pry"
  gem "rspec"
end
```

```bash
# Usar Bundler
bundle install
bundle exec ruby mi_script.rb
```

### Logging

```ruby
require 'logger'

# Crear logger
logger = Logger.new('aplicacion.log')
logger.level = Logger::INFO

# Niveles de log
logger.debug "Mensaje de depuración"
logger.info "Información"
logger.warn "Advertencia"
logger.error "Error"
logger.fatal "Error fatal"

# Formato personalizado
logger.formatter = proc do |severity, datetime, progname, msg|
  "[#{datetime}] #{severity}: #{msg}\n"
end
```

## Ejercicios Relacionados

- [Ejercicio 12: Manejo de Errores](./ejercicios/nivel-02-basico/ejercicio-06-manejo-de-errores/)
- [Ejercicio 23: Gems y Bundler](./ejercicios/nivel-04-avanzado/ejercicio-05-gems-y-bundler/)
