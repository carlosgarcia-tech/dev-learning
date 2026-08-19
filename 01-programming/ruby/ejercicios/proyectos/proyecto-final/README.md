# Proyecto Final: Sistema de Blog con Ruby on Rails

## Contexto

Desarrolla un blog completo usando Ruby on Rails con autenticación, categorías y comentarios.

## Tecnologías

- Ruby on Rails 7.0+
- PostgreSQL (o SQLite)
- Bootstrap
- Devise (autenticación)
- Pundit (autorización)

## Requisitos Funcionales

### Autenticación
- [ ] Registro de usuarios
- [ ] Login/Logout
- [ ] Recuperación de contraseña

### Posts
- [ ] CRUD completo
- [ ] Asignación de categorías
- [ ] Publicar/Despublicar
- [ ] Búsqueda por título/contenido

### Comentarios
- [ ] Agregar comentarios
- [ ] Editar/eliminar comentarios
- [ ] Moderación (solo admin)

### Usuarios
- [ ] Perfil de usuario
- [ ] Roles (admin, autor, lector)
- [ ] Avatar

### Otros
- [ ] Notificaciones por email
- [ ] Sitemap
- [ ] SEO básico

## Estructura

```
blog/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── helpers/
│   └── mailers/
├── config/
│   ├── routes.rb
│   └── environments/
├── db/
│   └── migrate/
├── spec/
│   ├── models/
│   ├── controllers/
│   └── features/
├── Gemfile
└── README.md
```

Este repositorio incluye un `starter/` con el andamiaje mínimo de carpetas para arrancar el proyecto y un `tests/` con la referencia de specs esperadas — ver esas carpetas para comenzar a trabajar.

## Criterios de Aceptación

1. Registro de usuarios
2. Login con email/contraseña
3. CRUD de posts
4. Posts con categorías
5. Comentarios en posts
6. Edición de comentarios
7. Perfil de usuario
8. Roles (admin/autor/lector)
9. Admin puede gestionar usuarios
10. Búsqueda de posts
11. Paginación en posts
12. Validaciones en modelos
13. Tests con RSpec
14. Factories con FactoryBot
15. Seeds con datos iniciales
16. Bootstrap estilizado
17. Responsive
18. Email de bienvenida
19. Recuperación de contraseña
20. Notificaciones de comentarios

## Rúbrica

| Criterio | Peso |
|----------|------|
| Funcionalidad | 30% |
| Código y Arquitectura | 25% |
| Tests | 20% |
| UI/UX | 15% |
| Seguridad | 10% |

## Cómo empezar

```bash
gem install rails
rails new blog --database=postgresql
cd blog
bundle add devise pundit rspec-rails factory_bot_rails
rails generate devise:install
rails generate devise User
```

Luego sigue el orden sugerido:
1. Modela `User`, `Post`, `Category`, `Comment` con sus migraciones y relaciones.
2. Implementa autenticación con Devise.
3. Implementa autorización de roles con Pundit.
4. Construye los controladores y vistas CRUD.
5. Agrega tests con RSpec + FactoryBot conforme avanzas (no al final).
6. Estiliza con Bootstrap y ajusta la responsividad.

## Recursos

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Pundit Documentation](https://github.com/varvet/pundit)
- [Bootstrap Documentation](https://getbootstrap.com/)
- [RSpec Documentation](https://rspec.info/)
