# Proyecto Final: Sistema de Gestión de Biblioteca con Go

## Contexto

Desarrollarás una aplicación completa de gestión de biblioteca en **Go**. El sistema permite gestionar libros, miembros y préstamos con repositorios genéricos, validaciones, reglas de negocio y reportes. Los tests validan la capa de servicios con `go test`.

## Tecnologías

- **Lenguaje**: Go 1.21+
- **Modelo**: structs + genéricos (`Repositorio[T]`)
- **Persistencia**: en memoria (extensible a JSON con `encoding/json`)
- **Fechas**: `time.Time` y cadenas ISO (comparación de vencimientos)
- **Testing**: `go test` + `testing`

## Requisitos Funcionales

### 1. Gestión de Libros
- [ ] Alta de libro (título, autor, ISBN, año, género)
- [ ] Listar todos los libros
- [ ] Buscar libros por texto (título o autor, sin distinguir mayúsculas)
- [ ] Marcar disponible / prestado
- [ ] Validar que el título y el autor no estén vacíos

### 2. Gestión de Miembros
- [ ] Alta de miembro (nombre, email, teléfono)
- [ ] Email único (devuelve `EmailDuplicadoError` si se repite)
- [ ] Listar miembros
- [ ] Activar / desactivar miembro

### 3. Gestión de Préstamos
- [ ] Crear préstamo (libro + miembro)
- [ ] Un libro no puede prestarse si no está disponible (`LibroNoDisponibleError`)
- [ ] Un miembro inactivo no puede tomar préstamos (`MiembroInactivoError`)
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
│   ├── go.mod                      (module proyectofinal)
│   ├── main.go                     (menú de consola)
│   ├── modelos/                    (Libro, Miembro, Prestamo, GeneroLibro)
│   ├── datos/                      (Repositorio[T] genérico)
│   └── servicios/                  (BibliotecaService, ReportesService, errores)
└── tests/                          (tests de referencia)
    ├── go.mod                      (module proyectofinal-tests, replace => ../starter)
    └── biblioteca_test.go
```

## Fases de Desarrollo

### Fase 1: Modelos y repositorio (1 día)
- Completar los structs de `modelos/` (`Libro`, `Miembro`, `Prestamo`)
- Implementar `Repositorio[T]` genérico en `datos/` (Crear, Listar, Obtener, Actualizar, Eliminar)

### Fase 2: Servicios (1-2 días)
- Implementar `BibliotecaService`: alta de libros/miembros, búsqueda, préstamos y devoluciones
- Implementar los errores personalizados (`LibroNoDisponibleError`, etc.)

### Fase 3: Reportes (1 día)
- Implementar `ReportesService`: resumen, top de libros y top de miembros

### Fase 4: Interfaz (1 día)
- Conectar el menú de `main.go` con los servicios

### Fase 5: Testing (1 día)
- Adaptar los tests de referencia y añadir cobertura adicional

## Criterios de Aceptación

1. ✅ El proyecto compila sin errores (`go build ./...` desde `starter/`)
2. ✅ Se pueden dar de alta libros, miembros y préstamos
3. ✅ Un libro prestado no puede prestarse de nuevo
4. ✅ Un miembro inactivo no puede pedir prestado
5. ✅ Las validaciones devuelven errores adecuados
6. ✅ Los reportes devuelven resultados correctos
7. ✅ `go test ./...` desde `tests/` pasa sin errores

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los flujos funcionan correctamente |
| Código | 20% | Código limpio, organizado y comentado |
| Genéricos | 15% | `Repositorio[T]` reutilizable y correcto |
| Reglas de negocio | 15% | Errores personalizados y validaciones |
| Tests | 10% | Cobertura de los servicios |
| Buenas prácticas | 10% | Separación en paquetes, errores, `go vet`/`gofmt` |

## Cómo ejecutar

### Arrancar la aplicación (desde `starter/`)

```bash
go run .
```

### Ejecutar los tests de referencia (desde `tests/`)

```bash
go test ./...
```

> Los tests importan el módulo `proyectofinal` del `starter/` mediante un
> `replace` en el `go.mod`. Ejecuta `go test` con Go 1.21 o superior.

## Recursos

- [Documentación de Go](https://go.dev/doc/)
- [Genéricos en Go](https://go.dev/blog/intro-generics)
- [Package testing](https://pkg.go.dev/testing)
- [Package encoding/json](https://pkg.go.dev/encoding/json)