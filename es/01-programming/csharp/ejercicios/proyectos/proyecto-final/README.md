# Proyecto Final: Sistema de Gestión de Biblioteca con C#

## Contexto

Desarrollarás una aplicación completa de gestión de biblioteca en **C#**. El sistema permite gestionar libros, miembros y préstamos con persistencia en JSON, validaciones, reportes con LINQ y operaciones asíncronas.

## Tecnologías

- **Lenguaje**: C# 10+ (.NET 8)
- **Persistencia**: archivos JSON (`System.Text.Json`)
- **Modelo**: POCOs, interfaces (`IRepositorio<T>`) y repositorios genéricos
- **Asincronía**: `async/await`, `Task<T>`
- **Consultas**: LINQ (agrupaciones, joins, ordenaciones)
- **Testing**: runner de tests de consola (`csc`/`dotnet`)

## Requisitos Funcionales

### 1. Gestión de Libros
- [ ] Alta de libro (título, autor, ISBN, año, género)
- [ ] Listar todos los libros
- [ ] Buscar libros por texto (título o autor, sin distinguir mayúsculas)
- [ ] Marcar disponible / prestado
- [ ] Validar que el título y el autor no estén vacíos

### 2. Gestión de Miembros
- [ ] Alta de miembro (nombre, email, teléfono)
- [ ] Email único (lanza `EmailDuplicadoException` si se repite)
- [ ] Listar miembros
- [ ] Activar / desactivar miembro

### 3. Gestión de Préstamos
- [ ] Crear préstamo (libro + miembro + fechas)
- [ ] Un libro no puede prestarse si no está disponible
- [ ] Un miembro inactivo no puede tomar préstamos
- [ ] Devolver préstamo
- [ ] Duración máxima de préstamo (`DiasDePrestamo`)

### 4. Reportes
- [ ] Resumen: total de libros, disponibles, prestados, miembros activos, préstamos activos
- [ ] Préstamos vencidos
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
│   ├── Program.cs                  (menú de consola)
│   ├── Modelos/                    (Libro, Miembro, Prestamo, GeneroLibro)
│   ├── Datos/                      (IRepositorio<T>, RepositorioJson, fábrica)
│   ├── Servicios/                  (BibliotecaService, ReportesService, excepciones)
│   └── data/                       (archivos JSON generados en ejecución)
└── tests/                          (tests de referencia)
```

## Fases de Desarrollo

### Fase 1: Modelos y repositorios (1 día)
- Completar las entidades (`Libro`, `Miembro`, `Prestamo`)
- Implementar `RepositorioJson<T>` con `System.Text.Json`

### Fase 2: Servicios (1-2 días)
- Implementar `BibliotecaService`: alta, búsqueda, préstamos y devoluciones
- Implementar las excepciones personalizadas

### Fase 3: Reportes (1 día)
- Implementar `ReportesService` con consultas LINQ

### Fase 4: Interfaz y persistencia (1 día)
- Conectar el menú de `Program.cs` con los servicios
- Verificar que los datos persisten entre ejecuciones

### Fase 5: Testing (1 día)
- Adaptar los tests de referencia y añadir cobertura adicional

## Criterios de Aceptación

1. ✅ El proyecto compila sin errores (`dotnet run`)
2. ✅ Se pueden dar de alta libros, miembros y préstamos
3. ✅ Un libro prestado no puede prestarse de nuevo
4. ✅ Un miembro inactivo no puede pedir prestado
5. ✅ Los datos persisten en JSON entre ejecuciones
6. ✅ Los reportes usan LINQ y devuelven resultados correctos
7. ✅ Las validaciones lanzan excepciones adecuadas
8. ✅ Existen tests que cubren los servicios principales

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los flujos funcionan correctamente |
| Código | 20% | Código limpio, organizado y comentado |
| LINQ | 15% | Consultas correctas en búsquedas y reportes |
| Asincronía | 15% | Operaciones `async/await` bien usadas |
| Tests | 10% | Cobertura de los servicios |
| Buenas prácticas | 10% | Interfaces, validaciones, excepciones |

## Cómo ejecutar

Desde `starter/`:

```bash
dotnet run
```

O con `csc`/Mono desde `starter/` (compilando todos los `.cs`):

```bash
csc Program.cs Modelos/*.cs Datos/*.cs Servicios/*.cs -out:Biblioteca.exe
mono Biblioteca.exe
```

## Recursos

- [Documentación de C#](https://learn.microsoft.com/dotnet/csharp/)
- [System.Text.Json](https://learn.microsoft.com/dotnet/standard/serialization/system-text-json/overview)
- [LINQ (Language Integrated Query)](https://learn.microsoft.com/dotnet/csharp/linq/)
- [Programación asíncrona](https://learn.microsoft.com/dotnet/csharp/asynchronous-programming/)