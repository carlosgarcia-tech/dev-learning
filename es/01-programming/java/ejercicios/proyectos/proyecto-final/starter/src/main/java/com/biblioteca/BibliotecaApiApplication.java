package com.biblioteca;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Punto de entrada del Sistema de Gestión de Biblioteca.
 *
 * A partir de aquí, sigue las fases descritas en el README.md del proyecto:
 * 1. Crea las entidades JPA en el paquete `entity` (Autor, Libro, Usuario, Prestamo).
 * 2. Crea los repositorios en `repository`.
 * 3. Implementa la lógica de negocio en `service`.
 * 4. Expón los endpoints REST en `controller`, usando DTOs de `dto`.
 * 5. Centraliza el manejo de errores en `exception.GlobalExceptionHandler`.
 */
@SpringBootApplication
public class BibliotecaApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(BibliotecaApiApplication.class, args);
    }
}
