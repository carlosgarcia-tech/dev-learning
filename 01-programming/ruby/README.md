# Ruby — Curso Completo desde Cero hasta Experto

Curso completo de Ruby en español, estructurado en 6 guías de estudio y 30 ejercicios prácticos organizados en 5 niveles de dificultad, más un proyecto final con Ruby on Rails.

## 📚 Guías de Estudio

| # | Guía | Tema |
|---|------|------|
| 1 | [01-fundamentos.md](./01-fundamentos.md) | Sintaxis básica, variables, tipos, control de flujo, métodos |
| 2 | [02-metodos-y-bloques.md](./02-metodos-y-bloques.md) | Métodos avanzados, bloques, Procs, Lambdas, iteradores |
| 3 | [03-oop.md](./03-oop.md) | Clases, objetos, herencia, polimorfismo, sobrecarga de operadores |
| 4 | [04-modulos-y-mixins.md](./04-modulos-y-mixins.md) | Módulos, mixins, Enumerable, Comparable, refinements |
| 5 | [05-errores-y-gems.md](./05-errores-y-gems.md) | Manejo de excepciones, gems, Bundler, logging |
| 6 | [06-rails-intro.md](./06-rails-intro.md) | Introducción a Ruby on Rails, MVC, ActiveRecord |

## 🏋️ Ejercicios

Los ejercicios están organizados en [`ejercicios/`](./ejercicios/) por nivel de dificultad. Ver el [índice completo de ejercicios](./ejercicios/README.md).

| Nivel | Tema | Ejercicios |
|-------|------|------------|
| 1 — Fundamentos | Sintaxis básica | 6 |
| 2 — Básico | Métodos, bloques, clases | 6 |
| 3 — Intermedio | Herencia, mixins, Enumerable | 6 |
| 4 — Avanzado | Metaprogramación, threads, testing | 6 |
| 5 — Experto | Proyectos CLI, servidores, cache | 6 |

Cada ejercicio incluye:
- `README.md` — enunciado, requisitos y solución
- `main.rb` — plantilla (stub) para resolver
- `test_main.rb` — tests automatizados con Minitest

## 🎓 Proyecto Final

[Sistema de Blog con Ruby on Rails](./ejercicios/proyectos/proyecto-final/README.md) — proyecto integrador con autenticación, CRUD de posts, comentarios, roles de usuario y más de 20 criterios de aceptación.

## 🛠️ Requisitos Previos

```bash
# Instalar Ruby con rbenv
rbenv install 3.2.2
rbenv global 3.2.2

# Verificar instalación
ruby --version
irb
```

## 🚀 Cómo usar este curso

1. Lee la guía correspondiente al nivel en el que estás.
2. Resuelve el `main.rb` de cada ejercicio relacionado.
3. Corre los tests: `ruby test_main.rb`
4. Compara tu solución con la propuesta en el `README.md` del ejercicio.
5. Al completar los 5 niveles, aborda el proyecto final.

## 📊 Estadísticas del Curso

| Componente | Cantidad |
|------------|----------|
| Guías de estudio | 6 |
| Ejercicios totales | 30 |
| Archivos por ejercicio | 3 (README.md, main.rb, test_main.rb) |
| Proyecto final | 1 (Ruby on Rails) |
| Tests | 30 suites (Minitest) |

## 🎯 Al finalizar este curso podrás

1. Programar en Ruby con confianza
2. Aplicar OOP y mixins en proyectos reales
3. Usar bloques, Procs y Lambdas efectivamente
4. Desarrollar aplicaciones web con Ruby on Rails
5. Escribir tests con RSpec/Minitest
6. Gestionar dependencias con Bundler
7. Comprender el ecosistema Ruby en profundidad

## 🔗 Recursos Generales

- [Documentación oficial de Ruby](https://ruby-doc.org/)
- [Ruby Koans](http://rubykoans.com/)
- [Learn Ruby in Y Minutes](https://learnxinyminutes.com/docs/ruby/)
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
