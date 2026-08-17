# Proyecto Final: Sistema de Gestión de Biblioteca con Spring Boot

## Contexto

Desarrollarás una API REST completa para la gestión de una biblioteca utilizando **Spring Boot**. El sistema debe permitir gestionar libros, autores, usuarios y préstamos.

## Tecnologías

- **Framework**: Spring Boot 3.x
- **Lenguaje**: Java 17+
- **Base de datos**: H2 (en memoria) o PostgreSQL
- **Persistencia**: Spring Data JPA
- **Seguridad**: Spring Security con JWT
- **Documentación**: Swagger/OpenAPI
- **Testing**: JUnit 5 + Mockito
- **Build Tool**: Maven o Gradle

## Requisitos Funcionales

### 1. Gestión de Autores
- [ ] Crear autor (nombre, biografía, nacionalidad, fecha_nacimiento)
- [ ] Listar todos los autores (con paginación)
- [ ] Obtener autor por ID
- [ ] Actualizar autor
- [ ] Eliminar autor (soft delete o hard delete)
- [ ] Buscar autores por nombre (parcial)

### 2. Gestión de Libros
- [ ] Crear libro (título, ISBN, año_publicación, autor_id, género, disponibilidad)
- [ ] Listar todos los libros (con paginación y filtros)
- [ ] Obtener libro por ID
- [ ] Actualizar libro
- [ ] Eliminar libro
- [ ] Buscar libros por título, autor o género
- [ ] Cambiar estado de disponibilidad de un libro

### 3. Gestión de Usuarios
- [ ] Registrar usuario (nombre, email, contraseña, teléfono, rol)
- [ ] Login (generación de JWT)
- [ ] Listar usuarios (solo admin)
- [ ] Obtener usuario por ID
- [ ] Actualizar perfil propio
- [ ] Cambiar contraseña

### 4. Gestión de Préstamos
- [ ] Crear préstamo (libro_id, usuario_id, fecha_inicio, fecha_devolucion)
- [ ] Listar préstamos (con filtros por usuario y estado)
- [ ] Obtener préstamo por ID
- [ ] Marcar préstamo como devuelto
- [ ] Calcular multas automáticamente (si el préstamo está vencido)
- [ ] Renovar préstamo (extensión de plazo)

### 5. Reglas de Negocio
- [ ] Un usuario no puede tener más de 3 préstamos activos
- [ ] Un libro no puede prestarse si no está disponible
- [ ] Los préstamos tienen un plazo máximo de 14 días
- [ ] Multa de 1€ por día de retraso

## Requisitos No Funcionales

- [ ] API RESTful con buenas prácticas
- [ ] Manejo de errores con excepciones personalizadas y global handler
- [ ] Validación de entrada con Bean Validation
- [ ] Documentación automática con Swagger
- [ ] Logging adecuado
- [ ] Tests unitarios para todas las capas
- [ ] Tests de integración para endpoints principales
- [ ] Código limpio siguiendo estándares de Java
- [ ] Uso de DTOs para la comunicación con el cliente

## Estructura del Proyecto

```
biblioteca-api/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/biblioteca/
│   │   │       ├── BibliotecaApiApplication.java
│   │   │       ├── config/
│   │   │       │   ├── SecurityConfig.java
│   │   │       │   ├── SwaggerConfig.java
│   │   │       │   └── WebConfig.java
│   │   │       ├── controller/
│   │   │       │   ├── AuthController.java
│   │   │       │   ├── AutorController.java
│   │   │       │   ├── LibroController.java
│   │   │       │   ├── PrestamoController.java
│   │   │       │   └── UsuarioController.java
│   │   │       ├── dto/
│   │   │       │   ├── request/
│   │   │       │   │   ├── AutorRequestDTO.java
│   │   │       │   │   ├── LibroRequestDTO.java
│   │   │       │   │   ├── PrestamoRequestDTO.java
│   │   │       │   │   └── UsuarioRequestDTO.java
│   │   │       │   └── response/
│   │   │       │       ├── AutorResponseDTO.java
│   │   │       │       ├── LibroResponseDTO.java
│   │   │       │       ├── PrestamoResponseDTO.java
│   │   │       │       └── UsuarioResponseDTO.java
│   │   │       ├── entity/
│   │   │       │   ├── Autor.java
│   │   │       │   ├── Libro.java
│   │   │       │   ├── Prestamo.java
│   │   │       │   ├── Usuario.java
│   │   │       │   └── Rol.java (enum)
│   │   │       ├── repository/
│   │   │       │   ├── AutorRepository.java
│   │   │       │   ├── LibroRepository.java
│   │   │       │   ├── PrestamoRepository.java
│   │   │       │   └── UsuarioRepository.java
│   │   │       ├── service/
│   │   │       │   ├── AutorService.java
│   │   │       │   ├── LibroService.java
│   │   │       │   ├── PrestamoService.java
│   │   │       │   ├── UsuarioService.java
│   │   │       │   └── AuthService.java (JWT)
│   │   │       ├── exception/
│   │   │       │   ├── ResourceNotFoundException.java
│   │   │       │   ├── BusinessException.java
│   │   │       │   └── GlobalExceptionHandler.java
│   │   │       └── util/
│   │   │           └── JwtUtil.java
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── data.sql (datos de ejemplo)
│   │       └── schema.sql
│   └── test/
│       └── java/
│           └── com/biblioteca/
│               ├── controller/
│               ├── service/
│               └── repository/
├── pom.xml (o build.gradle)
└── README.md
```

> La carpeta `starter/` de este proyecto contiene un andamiaje mínimo (README, pom.xml
> de ejemplo y la clase principal) para arrancar más rápido. La carpeta `tests/`
> incluye un ejemplo de test de integración como referencia.

## Fases de Desarrollo

### Fase 1: Setup y Modelos (1-2 días)
- Configurar el proyecto Spring Boot
- Crear las entidades JPA (Autor, Libro, Usuario, Prestamo)
- Configurar la base de datos H2
- Crear los repositorios

### Fase 2: Services y Lógica de Negocio (2-3 días)
- Implementar los servicios para cada entidad
- Implementar las reglas de negocio
- Manejo de excepciones personalizadas
- Servicio de autenticación con JWT

### Fase 3: Controllers y DTOs (2-3 días)
- Crear los endpoints REST para cada recurso
- Implementar DTOs para request y response
- Validación de entrada
- Documentación con Swagger

### Fase 4: Testing (2 días)
- Tests unitarios para services
- Tests de integración para controllers
- Tests de seguridad

### Fase 5: Mejoras y Deploy (1-2 días)
- Paginación y ordenamiento
- Filtros avanzados
- Logging
- Configuración para producción
- Documentación final

## Criterios de Aceptación

1. ✅ El proyecto compila sin errores
2. ✅ La API se ejecuta correctamente en el puerto configurado
3. ✅ Swagger UI está disponible en `/swagger-ui.html`
4. ✅ Se pueden crear autores
5. ✅ Se pueden listar autores
6. ✅ Se pueden crear libros asociados a autores
7. ✅ Se pueden listar libros con filtros
8. ✅ Se pueden registrar usuarios
9. ✅ El login genera un JWT válido
10. ✅ Los endpoints protegidos requieren autenticación
11. ✅ Los usuarios pueden ver su propio perfil
12. ✅ Los administradores pueden ver todos los usuarios
13. ✅ Se pueden crear préstamos
14. ✅ Un libro no puede prestarse dos veces
15. ✅ Un usuario no puede tener más de 3 préstamos activos
16. ✅ La fecha de devolución se calcula automáticamente (14 días)
17. ✅ La multa se calcula al devolver un préstamo retrasado
18. ✅ Los datos se persisten correctamente en H2
19. ✅ Las validaciones funcionan correctamente
20. ✅ Los errores se manejan de manera consistente
21. ✅ Existen tests unitarios para los services
22. ✅ Existen tests de integración para los endpoints
23. ✅ El código sigue las convenciones de Java
24. ✅ La documentación del código es adecuada
25. ✅ Los DTOs encapsulan correctamente los datos

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los endpoints funcionan correctamente |
| Código | 20% | Código limpio, organizado y bien comentado |
| Tests | 20% | Cobertura de pruebas adecuada |
| Seguridad | 15% | Autenticación y autorización funcionan |
| Documentación | 10% | Swagger/OpenAPI completo y claro |
| Buenas prácticas | 5% | Uso de DTOs, validaciones, excepciones |

## Recursos

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Spring Security](https://spring.io/projects/spring-security)
- [JWT.io](https://jwt.io/)
- [Swagger/OpenAPI](https://swagger.io/)
- [H2 Database](https://www.h2database.com/)
