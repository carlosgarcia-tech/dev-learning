# Ejercicio 24 — Patrones

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 35 minutos

## Enunciado

Implementa el patrón:
1. Singleton
2. Observer
3. Factory

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
require "singleton"

# Singleton
class Configuracion
  include Singleton

  attr_accessor :url, :port

  def initialize
    @url = "localhost"
    @port = 3000
  end
end

# Observer
module Observable
  def observers
    @observers ||= []
  end

  def add_observer(observer)
    observers << observer
  end

  def notify_observers
    observers.each { |o| o.update(self) }
  end
end

# Factory
class EmailNotificacion
  def enviar
    puts "Enviando notificación por email"
  end
end

class SMSNotificacion
  def enviar
    puts "Enviando notificación por SMS"
  end
end

class NotificacionFactory
  def self.crear(tipo)
    case tipo
    when :email then EmailNotificacion.new
    when :sms then SMSNotificacion.new
    else raise "Tipo no soportado"
    end
  end
end

# Uso
config = Configuracion.instance
puts config.url

notificacion = NotificacionFactory.crear(:email)
notificacion.enviar
```

</details>
