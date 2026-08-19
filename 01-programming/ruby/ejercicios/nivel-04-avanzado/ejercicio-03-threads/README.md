# Ejercicio 21 — Threads

- **Nivel:** 4/5
- **Tema:** Avanzado de Ruby
- **Tiempo estimado:** 30 minutos

## Enunciado

1. Crea 3 threads que calculen algo en paralelo
2. Sincroniza los threads con `join`
3. Usa `Mutex` para sincronización

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
require "thread"

mutex = Mutex.new
contador = 0
threads = []

3.times do
  threads << Thread.new do
    100.times do
      mutex.synchronize do
        contador += 1
      end
    end
  end
end

threads.each(&:join)
puts "Contador: #{contador}"
```

</details>
