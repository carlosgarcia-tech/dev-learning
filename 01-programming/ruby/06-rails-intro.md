# 06 — Introducción a Ruby on Rails

## Objetivos

- [ ] Entender el framework Ruby on Rails
- [ ] Conocer la arquitectura MVC
- [ ] Crear un proyecto Rails básico
- [ ] Usar migrations y ActiveRecord
- [ ] Implementar rutas y controladores

## Apuntes

### ¿Qué es Rails?

Ruby on Rails es un framework web que sigue el patrón MVC (Model-View-Controller). Sus principios son:
- **Convención sobre Configuración**: Menos configuración necesaria
- **DRY** (Don't Repeat Yourself): No repetir código
- **Rápido desarrollo**: Prototipado rápido

### Estructura MVC

```
app/
├── models/          # Modelos (ActiveRecord)
├── views/           # Vistas (ERB)
├── controllers/     # Controladores
├── helpers/         # Helpers de vista
├── assets/          # CSS, JS, imágenes
└── mailers/         # Correos

config/
├── routes.rb        # Rutas
├── database.yml     # Configuración de DB
└── ...

db/
├── migrate/         # Migraciones
└── seeds.rb         # Datos iniciales
```

### Crear un Proyecto Rails

```bash
# Instalar Rails
gem install rails

# Crear proyecto
rails new mi_app --database=postgresql
cd mi_app

# Crear modelo (con migración)
rails generate model Producto nombre:string precio:decimal descripcion:text

# Correr migraciones
rails db:create
rails db:migrate

# Crear controlador
rails generate controller Productos

# Ejecutar servidor
rails server
```

### Controladores

```ruby
class ProductosController < ApplicationController
  def index
    @productos = Producto.all
  end

  def show
    @producto = Producto.find(params[:id])
  end

  def new
    @producto = Producto.new
  end

  def create
    @producto = Producto.new(producto_params)
    if @producto.save
      redirect_to @producto, notice: "Producto creado"
    else
      render :new
    end
  end

  private

  def producto_params
    params.require(:producto).permit(:nombre, :precio, :descripcion)
  end
end
```

### Rutas

```ruby
Rails.application.routes.draw do
  # Recursos RESTful
  resources :productos

  # Rutas personalizadas
  get '/productos/buscar/:termino', to: 'productos#buscar'

  # Ruta raíz
  root 'productos#index'
end
```

### Vistas (ERB)

```erb
<!-- app/views/productos/index.html.erb -->
<h1>Lista de Productos</h1>

<%= link_to "Nuevo producto", new_producto_path %>

<table>
  <thead>
    <tr>
      <th>Nombre</th>
      <th>Precio</th>
      <th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <% @productos.each do |producto| %>
      <tr>
        <td><%= producto.nombre %></td>
        <td><%= producto.precio %></td>
        <td>
          <%= link_to "Ver", producto_path(producto) %>
          <%= link_to "Editar", edit_producto_path(producto) %>
          <%= link_to "Eliminar", producto_path(producto), method: :delete %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
```

### Modelos (ActiveRecord)

```ruby
class Producto < ApplicationRecord
  # Validaciones
  validates :nombre, presence: true, length: { minimum: 3 }
  validates :precio, numericality: { greater_than: 0 }

  # Relaciones
  belongs_to :categoria
  has_many :pedidos, through: :detalles_pedido

  # Scopes
  scope :activos, -> { where(activo: true) }
  scope :baratos, -> { where('precio < ?', 10) }

  # Métodos
  def calcular_descuento(porcentaje)
    precio * (1 - porcentaje / 100.0)
  end
end
```

### Migraciones

```ruby
class CreateProductos < ActiveRecord::Migration[7.0]
  def change
    create_table :productos do |t|
      t.string :nombre
      t.decimal :precio, precision: 10, scale: 2
      t.text :descripcion
      t.boolean :activo, default: true
      t.references :categoria, foreign_key: true

      t.timestamps
    end

    add_index :productos, :nombre
  end
end
```

### Seeds

```ruby
# db/seeds.rb
Producto.create!(
  nombre: "Laptop",
  precio: 999.99,
  descripcion: "Laptop de alta gama"
)

Producto.create!(
  nombre: "Teléfono",
  precio: 599.99,
  descripcion: "Teléfono inteligente"
)
```

## Ejercicios Relacionados

Este tema se consolida en el [Proyecto Final](./ejercicios/proyectos/proyecto-final/README.md): un sistema de blog completo construido con Ruby on Rails.

## Recursos

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Rails API Documentation](https://api.rubyonrails.org/)
- [Agile Web Development with Rails](https://pragprog.com/titles/rails7/agile-web-development-with-rails-7/)
