# 06 — Introducción a Spring Boot

## Objetivos

- [ ] Entender qué es Spring Boot y la inyección de dependencias
- [ ] Crear un proyecto con Spring Initializr
- [ ] Construir controladores REST (`@RestController`)
- [ ] Persistir datos con Spring Data JPA
- [ ] Usar DTOs y validación de entrada
- [ ] Manejar errores de forma centralizada
- [ ] Documentar la API con Swagger/OpenAPI
- [ ] Entender los fundamentos de seguridad con JWT

## Apuntes

### ¿Qué es Spring Boot?

Spring Boot es un framework sobre Spring que simplifica la creación de aplicaciones Java
mediante **autoconfiguración**, un **servidor embebido** (Tomcat por defecto) y la gestión
de dependencias mediante *starters*. Su filosofía es "convención sobre configuración".

### Crear un proyecto

La forma habitual es usar [Spring Initializr](https://start.spring.io/) con las dependencias:
`Spring Web`, `Spring Data JPA`, `H2 Database` (o el driver de tu base de datos), `Validation`,
y opcionalmente `Spring Security` y `springdoc-openapi`.

```
project/
├── src/main/java/com/ejemplo/
│   ├── EjemploApplication.java   (clase con @SpringBootApplication y main())
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── entity/
│   └── dto/
├── src/main/resources/
│   └── application.properties
└── pom.xml
```

```java
package com.ejemplo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EjemploApplication {
    public static void main(String[] args) {
        SpringApplication.run(EjemploApplication.class, args);
    }
}
```

### Inyección de dependencias

Spring gestiona el ciclo de vida de los objetos (*beans*) y los inyecta donde se necesiten.

```java
import org.springframework.stereotype.Service;

@Service
public class SaludoService {
    public String saludar(String nombre) {
        return "Hola, " + nombre;
    }
}

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/saludo")
public class SaludoController {

    private final SaludoService saludoService;

    // Inyección por constructor (recomendada frente a @Autowired en campos)
    public SaludoController(SaludoService saludoService) {
        this.saludoService = saludoService;
    }

    @GetMapping("/{nombre}")
    public String saludar(@PathVariable String nombre) {
        return saludoService.saludar(nombre);
    }
}
```

### Entidad JPA y Repositorio

```java
package com.ejemplo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "libros")
public class Libro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titulo;

    private String isbn;
    private Integer anioPublicacion;
    private boolean disponible = true;

    // Constructores, getters y setters
    public Libro() {}

    public Libro(String titulo, String isbn, Integer anioPublicacion) {
        this.titulo = titulo;
        this.isbn = isbn;
        this.anioPublicacion = anioPublicacion;
    }

    public Long getId() { return id; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public Integer getAnioPublicacion() { return anioPublicacion; }
    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }
}
```

```java
package com.ejemplo.repository;

import com.ejemplo.entity.Libro;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface LibroRepository extends JpaRepository<Libro, Long> {
    // Spring Data genera la implementación a partir del nombre del método
    List<Libro> findByTituloContainingIgnoreCase(String titulo);
    List<Libro> findByDisponibleTrue();
}
```

### DTOs y validación

Los DTOs (Data Transfer Objects) evitan exponer las entidades JPA directamente en la API.

```java
package com.ejemplo.dto;

import jakarta.validation.constraints.*;

public record LibroRequestDTO(
    @NotBlank(message = "El título es obligatorio")
    String titulo,

    @NotBlank
    @Size(min = 10, max = 13, message = "El ISBN debe tener entre 10 y 13 caracteres")
    String isbn,

    @NotNull
    @Min(value = 1450, message = "Año de publicación inválido")
    Integer anioPublicacion
) {}

public record LibroResponseDTO(
    Long id,
    String titulo,
    String isbn,
    Integer anioPublicacion,
    boolean disponible
) {}
```

### Service, Controller y manejo de errores

```java
package com.ejemplo.service;

import com.ejemplo.dto.LibroRequestDTO;
import com.ejemplo.dto.LibroResponseDTO;
import com.ejemplo.entity.Libro;
import com.ejemplo.exception.ResourceNotFoundException;
import com.ejemplo.repository.LibroRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class LibroService {

    private final LibroRepository repository;

    public LibroService(LibroRepository repository) {
        this.repository = repository;
    }

    public LibroResponseDTO crear(LibroRequestDTO dto) {
        Libro libro = new Libro(dto.titulo(), dto.isbn(), dto.anioPublicacion());
        Libro guardado = repository.save(libro);
        return toDto(guardado);
    }

    public List<LibroResponseDTO> listarTodos() {
        return repository.findAll().stream().map(this::toDto).toList();
    }

    public LibroResponseDTO obtenerPorId(Long id) {
        Libro libro = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Libro no encontrado: " + id));
        return toDto(libro);
    }

    private LibroResponseDTO toDto(Libro libro) {
        return new LibroResponseDTO(libro.getId(), libro.getTitulo(), libro.getIsbn(),
            libro.getAnioPublicacion(), libro.isDisponible());
    }
}
```

```java
package com.ejemplo.controller;

import com.ejemplo.dto.LibroRequestDTO;
import com.ejemplo.dto.LibroResponseDTO;
import com.ejemplo.service.LibroService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/libros")
public class LibroController {

    private final LibroService service;

    public LibroController(LibroService service) {
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<LibroResponseDTO> crear(@Valid @RequestBody LibroRequestDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.crear(dto));
    }

    @GetMapping
    public List<LibroResponseDTO> listar() {
        return service.listarTodos();
    }

    @GetMapping("/{id}")
    public LibroResponseDTO obtener(@PathVariable Long id) {
        return service.obtenerPorId(id);
    }
}
```

```java
package com.ejemplo.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String mensaje) {
        super(mensaje);
    }
}
```

```java
package com.ejemplo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, String>> manejarNoEncontrado(ResourceNotFoundException e) {
        Map<String, String> body = new HashMap<>();
        body.put("error", e.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> manejarValidacion(MethodArgumentNotValidException e) {
        Map<String, String> errores = new HashMap<>();
        e.getBindingResult().getFieldErrors()
            .forEach(err -> errores.put(err.getField(), err.getDefaultMessage()));
        return ResponseEntity.badRequest().body(errores);
    }
}
```

### `application.properties` de ejemplo

```properties
spring.application.name=ejemplo-api
server.port=8080

# H2 en memoria (útil para desarrollo/tests)
spring.datasource.url=jdbc:h2:mem:ejemplodb
spring.datasource.driver-class-name=org.h2.Driver
spring.h2.console.enabled=true

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Nociones de seguridad con JWT

En una API protegida con JWT: el cliente hace login, recibe un token firmado, y lo envía
en la cabecera `Authorization: Bearer <token>` en cada petición posterior. Un filtro valida
el token antes de que la petición llegue al controlador.

```java
// Esquema simplificado (sin librería concreta) de generación/validación
public class JwtUtil {
    private final String secreto = "clave-secreta-de-ejemplo"; // en producción: variable de entorno

    public String generarToken(String usuario) {
        // firmar un token con el usuario, fecha de emisión y expiración
        // (usando io.jsonwebtoken:jjwt u otra librería)
        return "token-simulado-para." + usuario;
    }

    public boolean validarToken(String token) {
        // verificar firma y expiración
        return token != null && token.startsWith("token-simulado-para.");
    }
}
```

> Para una implementación real se recomienda usar `spring-boot-starter-security` junto con
> una librería JWT (por ejemplo `jjwt`), definiendo un `SecurityFilterChain` que registre
> un filtro de autenticación antes de `UsernamePasswordAuthenticationFilter`.

### Documentación con Swagger/OpenAPI

Añadiendo la dependencia `springdoc-openapi-starter-webmvc-ui`, Spring Boot expone
automáticamente la documentación interactiva en `/swagger-ui.html` a partir de las
anotaciones de los controladores, sin configuración adicional obligatoria.

### Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Whitelabel Error Page` | No hay controlador para la ruta solicitada | Verificar `@RequestMapping`/`@GetMapping` y el puerto |
| `No qualifying bean of type ...` | Spring no encuentra una dependencia para inyectar | Anotar la clase con `@Service`/`@Component`/`@Repository` |
| `Could not autowire` en tests | Falta contexto de Spring en el test | Usar `@SpringBootTest` o mocks con Mockito |
| `LazyInitializationException` | Acceso a una relación JPA fuera de la sesión | Usar `@Transactional` o cargar con `JOIN FETCH` |
| Validaciones de `@Valid` ignoradas | Falta la anotación `@Valid` en el parámetro del controlador | Añadir `@Valid @RequestBody ...` |

## Ejercicios Relacionados

- [Ejercicio 29: API REST](./ejercicios/nivel-05-experto/ejercicio-05-api-rest/)
- [Proyecto Final: Sistema de Biblioteca](./ejercicios/proyectos/proyecto-final/)

## Recursos

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Spring Security](https://spring.io/projects/spring-security)
- [JWT.io](https://jwt.io/)
- [Swagger/OpenAPI](https://swagger.io/)
- [H2 Database](https://www.h2database.com/)