# Proyecto Final: Sistema de Gestión de Biblioteca con Rust

## Contexto

Desarrollarás una aplicación completa de gestión de biblioteca en **Rust**. El sistema gestiona libros, miembros y préstamos con un repositorio genérico (`Repositorio<T: Identificable>`), validaciones, reglas de negocio con `Result` y reportes. Los tests de integración validan la capa de servicios con `cargo test`.

## Tecnologías

- **Lenguaje**: Rust (edition 2021)
- **Modelo**: structs + `enum` + trait `Identificable` + genéricos
- **Almacenamiento**: `HashMap` en memoria (extensible a archivo con `std::fs`)
- **Fechas**: cadenas ISO ("2006-01-02") para comparar vencimientos
- **Testing**: `#[cfg(test)]` y tests de integración con `cargo test`
- **Errores**: `enum ErrorBiblioteca` que implementa `Display` + `std::error::Error`

## Requisitos Funcionales

### 1. Gestión de Libros
- [ ] Alta de libro (título, autor, ISBN, año, género)
- [ ] Listar todos los libros
- [ ] Buscar libros por texto (título o autor, sin distinguir mayúsculas)
- [ ] Marcar disponible / prestado
- [ ] Validar que el título y el autor no estén vacíos

### 2. Gestión de Miembros
- [ ] Alta de miembro (nombre, email, teléfono)
- [ ] Email único (devuelve `ErrorBiblioteca::EmailDuplicado` si se repite)
- [ ] Listar miembros
- [ ] Activar / desactivar miembro

### 3. Gestión de Préstamos
- [ ] Crear préstamo (libro + miembro)
- [ ] Un libro no puede prestarse si no está disponible (`LibroNoDisponible`)
- [ ] Un miembro inactivo no puede tomar préstamos (`MiembroInactivo`)
- [ ] Devolver préstamo
- [ ] Duración máxima de préstamo (`DiasDePrestamo = 14`)

### 4. Reportes
- [ ] Resumen: total de libros, disponibles, prestados, miembros activos, préstamos activos
- [ ] Top de libros más prestados
- [ ] Top de miembros más activos

### 5. Reglas de Negocio
- [ ] Un libro prestado no se presta de nuevo
- [ ] Solo miembros activos pueden pedir prestado
- [ ] Los préstamos vencidos se detectan comparando fechas

## Estructura del Proyecto

```
proyecto-final/
├── README.md
├── starter/                        (andamiaje para arrancar)
│   ├── Cargo.toml                  (package proyectofinal)
│   └── src/
│       ├── lib.rs                  (re-exporta los módulos)
│       ├── modelos.rs              (Libro, Miembro, Prestamo, GeneroLibro)
│       ├── repositorio.rs          (Repositorio<T: Identificable> genérico)
│       ├── servicios.rs            (BibliotecaService, ReportesService, errores)
│       └── main.rs                 (menú de consola)
└── tests/                          (tests de referencia)
    ├── Cargo.toml                  (depende de proyectofinal => ../starter)
    └── biblioteca_test.rs
```

## Fases de Desarrollo

### Fase 1: Modelos y repositorio (1 día)
- Completar los structs y el `enum GeneroLibro` de `modelos.rs`
- Implementar `Repositorio<T: Identificable>` en `repositorio.rs` (`crear`, `listar`, `obtener`, `actualizar`, `eliminar`)

### Fase 2: Servicios (1-2 días)
- Implementar `BibliotecaService`: alta de libros/miembros, búsqueda, préstamos y devoluciones
- Implementar el `enum ErrorBiblioteca` con `Display`

### Fase 3: Reportes (1 día)
- Implementar `ReportesService`: resumen, top de libros y top de miembros

### Fase 4: Interfaz (1 día)
- Conectar el menú de `main.rs` con los servicios

### Fase 5: Testing (1 día)
- Adaptar los tests de referencia y añadir cobertura adicional

## Criterios de Aceptación

1. ✅ El proyecto compila sin errores (`cargo build`)
2. ✅ Se pueden dar de alta libros, miembros y préstamos
3. ✅ Un libro prestado no puede prestarse de nuevo
4. ✅ Un miembro inactivo no puede pedir prestado
5. ✅ Las validaciones devuelven errores adecuados
6. ✅ Los reportes devuelven resultados correctos
7. ✅ `cargo test` pasa sin errores

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los flujos funcionan correctamente |
| Código | 20% | Código limpio, organizado y comentado |
| Genéricos y traits | 15% | `Repositorio<T: Identificable>` reutilizable y correcto |
| Reglas de negocio | 15% | `enum ErrorBiblioteca` y validaciones |
| Tests | 10% | Cobertura de los servicios |
| Buenas prácticas | 10% | Separación en módulos, `Result`, `cargo fmt`/`clippy` |

## Cómo ejecutar

### Arrancar la aplicación (desde `starter/`)

```bash
cargo run
```

### Ejecutar los tests de referencia (desde `tests/`)

```bash
cargo test
```

> Los tests de integración dependen del paquete `proyectofinal` (el `starter/`)
> mediante una dependencia por ruta en el `Cargo.toml`. Usa Rust 2021 edition
> o superior.

## Recursos

- [Documentación de Rust](https://doc.rust-lang.org/book/)
- [Ownership y borrow checker](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
- [Traits y genéricos](https://doc.rust-lang.org/book/ch10-00-generics.html)
- [Testing en Rust](https://doc.rust-lang.org/book/ch11-00-testing.html)