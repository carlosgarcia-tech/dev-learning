# Ejercicio 29 — Mini Proyecto

- **Nivel:** 5/5
- **Tema:** Experto en Ruby
- **Tiempo estimado:** 90 minutos

## Enunciado

Desarrolla un sistema de blog con:
- Posts, autores y comentarios
- Persistencia en archivos
- CLI básico

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] La lógica pedida en el enunciado está implementada
- [ ] Los tests pasan: `ruby test_main.rb`

## Solución

<details>
<summary>Mostrar solución</summary>

```ruby
require "json"

class Autor
  attr_accessor :nombre, :email

  def initialize(nombre, email)
    @nombre = nombre
    @email = email
  end

  def to_h
    { nombre: @nombre, email: @email }
  end
end

class Comentario
  attr_accessor :autor, :contenido, :fecha

  def initialize(autor, contenido)
    @autor = autor
    @contenido = contenido
    @fecha = Time.now
  end

  def to_h
    { autor: @autor.to_h, contenido: @contenido, fecha: @fecha.to_s }
  end
end

class Post
  attr_accessor :titulo, :contenido, :autor, :comentarios

  def initialize(titulo, contenido, autor)
    @titulo = titulo
    @contenido = contenido
    @autor = autor
    @comentarios = []
  end

  def agregar_comentario(comentario)
    @comentarios << comentario
  end

  def to_h
    {
      titulo: @titulo,
      contenido: @contenido,
      autor: @autor.to_h,
      comentarios: @comentarios.map(&:to_h)
    }
  end
end

class Blog
  def initialize
    @posts = []
  end

  def agregar_post(post)
    @posts << post
  end

  def listar_posts
    @posts.each_with_index do |post, i|
      puts "#{i + 1}. #{post.titulo} (por #{post.autor.nombre})"
    end
  end

  def guardar(archivo)
    File.write(archivo, @posts.map(&:to_h).to_json)
  end

  def cargar(archivo)
    return unless File.exist?(archivo)

    data = JSON.parse(File.read(archivo), symbolize_names: true)
    @posts = data.map do |post_h|
      autor = Autor.new(post_h[:autor][:nombre], post_h[:autor][:email])
      post = Post.new(post_h[:titulo], post_h[:contenido], autor)
      post_h[:comentarios].each do |c|
        comentario_autor = Autor.new(c[:autor][:nombre], c[:autor][:email])
        post.agregar_comentario(Comentario.new(comentario_autor, c[:contenido]))
      end
      post
    end
  end
end

if __FILE__ == $0
  blog = Blog.new
  autor = Autor.new("Ana", "ana@email.com")
  post = Post.new("Mi primer post", "Contenido del post", autor)
  blog.agregar_post(post)
  blog.listar_posts
  blog.guardar("blog.json")
end
```

</details>
