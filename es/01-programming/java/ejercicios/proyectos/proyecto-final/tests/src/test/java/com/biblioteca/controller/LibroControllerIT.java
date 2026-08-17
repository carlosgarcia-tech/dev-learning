package com.biblioteca.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Ejemplo de test de integración para el endpoint de Libros.
 * Requiere que existan LibroController, LibroService, LibroRepository y las
 * entidades/DTOs correspondientes (ver README.md del proyecto).
 *
 * Copia este archivo a src/test/java/com/biblioteca/controller/ de tu proyecto
 * una vez tengas implementado LibroController.
 */
@SpringBootTest
@AutoConfigureMockMvc
class LibroControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void deberiaCrearYListarUnLibro() throws Exception {
        String nuevoLibro = """
            {
              "titulo": "Cien años de soledad",
              "isbn": "9780307474728",
              "anioPublicacion": 1967
            }
            """;

        mockMvc.perform(post("/api/libros")
                .contentType(MediaType.APPLICATION_JSON)
                .content(nuevoLibro))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.titulo").value("Cien años de soledad"));

        mockMvc.perform(get("/api/libros"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].titulo").value("Cien años de soledad"));
    }

    @Test
    void deberiaRechazarUnLibroSinTitulo() throws Exception {
        String libroInvalido = """
            {
              "titulo": "",
              "isbn": "9780307474728",
              "anioPublicacion": 1967
            }
            """;

        mockMvc.perform(post("/api/libros")
                .contentType(MediaType.APPLICATION_JSON)
                .content(libroInvalido))
            .andExpect(status().isBadRequest());
    }

    @Test
    void deberiaDevolver404SiElLibroNoExiste() throws Exception {
        mockMvc.perform(get("/api/libros/99999"))
            .andExpect(status().isNotFound());
    }
}
