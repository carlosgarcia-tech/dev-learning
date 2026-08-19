# Tests de referencia

Specs de referencia (RSpec) para validar los criterios de aceptación del proyecto final. Cópialas a `spec/` en tu proyecto Rails una vez tengas los modelos creados.

```ruby
# spec/models/post_spec.rb
require "rails_helper"

RSpec.describe Post, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  describe ".published" do
    it "solo retorna posts publicados" do
      publicado = create(:post, published: true)
      borrador = create(:post, published: false)

      expect(Post.published).to include(publicado)
      expect(Post.published).not_to include(borrador)
    end
  end
end

# spec/models/comment_spec.rb
require "rails_helper"

RSpec.describe Comment, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:body) }
end

# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:posts) }
  it { should have_many(:comments) }

  describe "roles" do
    it "por defecto es lector" do
      user = create(:user)
      expect(user.lector?).to be true
    end
  end
end
```

```ruby
# spec/factories/factories.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "usuario#{n}@example.com" }
    password { "password123" }
  end

  factory :category do
    sequence(:name) { |n| "Categoría #{n}" }
  end

  factory :post do
    title { "Título de ejemplo" }
    body { "Contenido de ejemplo" }
    published { true }
    user
    category
  end

  factory :comment do
    body { "Comentario de ejemplo" }
    user
    post
  end
end
```
