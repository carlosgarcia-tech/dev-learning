# Tests de referencia — Proyecto Final

Ejemplos de tests que puedes adaptar a tu implementación:

- `src/test/java/com/biblioteca/controller/LibroControllerIT.java` — test de integración
  con `MockMvc` que crea y consulta libros vía HTTP, valida errores 400/404.

## Cómo usarlos

1. Copia el archivo dentro de tu proyecto Spring Boot, en la misma ruta de paquete
   (`src/test/java/com/biblioteca/controller/`).
2. Asegúrate de tener implementado `LibroController`, `LibroService`, `LibroRepository`,
   `LibroRequestDTO` y `LibroResponseDTO` según la guía [`06-spring-boot.md`](../../../../06-spring-boot.md).
3. Ejecuta:
   ```bash
   mvn test
   ```

Sigue este mismo patrón (`@SpringBootTest` + `MockMvc` para tests de integración,
`@ExtendWith(MockitoExtension.class)` para tests unitarios de servicios) para cubrir
`AutorController`, `UsuarioController`, `PrestamoController` y `AuthController`.
