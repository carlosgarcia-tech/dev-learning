# Starter — Sistema de Gestión de Biblioteca

Andamiaje mínimo para arrancar el proyecto final. Incluye:

- `pom.xml` con las dependencias necesarias (Web, JPA, Validation, Security, H2, JWT, OpenAPI, Test)
- `BibliotecaApiApplication.java` — clase principal de Spring Boot
- `application.properties` — configuración de base de datos, JWT y reglas de negocio

## Cómo usarlo

1. Copia esta carpeta como base de tu proyecto (o usa [Spring Initializr](https://start.spring.io/)
   con las mismas dependencias y sustituye `pom.xml` y `application.properties`).
2. Ejecuta:
   ```bash
   mvn spring-boot:run
   ```
3. Verifica que arranca en `http://localhost:8080` y que la consola H2 está disponible en
   `http://localhost:8080/h2-console`.
4. Sigue las fases del [`README.md`](../README.md) del proyecto para completar entidades,
   repositorios, servicios, controladores y tests.

> Este starter no compila ejercicios de este repositorio con `javac` porque depende de
> Maven y las librerías de Spring Boot (no forman parte del JDK estándar). Instálalas con
> `mvn` en tu propio entorno.
