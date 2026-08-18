# Starter — Sistema de Gestión de Biblioteca

Andamiaje mínimo para arrancar el proyecto final. Incluye:

- `Program.cs` — menú de consola que delega en `BibliotecaService` y `ReportesService`
- `Modelos/` — entidades `Libro`, `Miembro`, `Prestamo` y el enum `GeneroLibro`
- `Datos/` — interfaz `IRepositorio<T>`, `RepositorioJson<T>` (persistencia en JSON) y `FabricaRepositorios`
- `Servicios/` — `BibliotecaService`, `ReportesService` y excepciones personalizadas
- `data/` — carpeta donde se persisten los archivos JSON en ejecución

## Cómo usarlo

1. Copia esta carpeta como base de tu proyecto (o crea uno con `dotnet new console`).
2. Ejecuta:
   ```bash
   dotnet run
   ```
   O compila con `csc`/Mono:
   ```bash
   csc Program.cs Modelos/*.cs Datos/*.cs Servicios/*.cs -out:Biblioteca.exe
   mono Biblioteca.exe
   ```
3. Completa los métodos con `TODO` de `BibliotecaService` y `ReportesService`.
4. Sigue las fases del [`README.md`](../README.md) del proyecto para implementar
   altas, búsquedas, préstamos, devoluciones y reportes con LINQ.
5. Adapta los tests de referencia de la carpeta [`../tests/`](../tests/README.md)
   para validar tu implementación.

> El starter persiste los datos en `data/`. Para empezar limpio, borra el contenido
> de `data/` entre ejecuciones de prueba.