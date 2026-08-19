# Starter

Aquí va el andamiaje inicial de tu proyecto Rails (`rails new blog`). Este directorio se deja intencionalmente vacío de código: genera el proyecto con Rails y muévelo aquí, o usa esta carpeta como raíz de tu `rails new`.

Sugerencia de comandos iniciales:

```bash
rails new . --database=postgresql --skip-test
bundle add devise pundit rspec-rails factory_bot_rails faker
rails generate devise:install
rails generate rspec:install
```

## Modelos sugeridos

```ruby
# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: { lector: 0, autor: 1, admin: 2 }
end

# app/models/category.rb
class Category < ApplicationRecord
  has_many :posts
  validates :name, presence: true, uniqueness: true
end

# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3 }
  validates :body, presence: true

  scope :published, -> { where(published: true) }
end

# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true
end
```
