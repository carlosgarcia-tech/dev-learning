# Tests de referencia — Proyecto Final

Tests de consola que validan el `BibliotecaService` y `ReportesService` del
proyecto final: altas con validaciones, préstamos, devoluciones, búsquedas
con LINQ y reportes.

## Cómo usarlos

1. Copia `src/TestsBiblioteca.cs` dentro de la carpeta `starter/`.
2. Asegúrate de haber implementado `BibliotecaService`, `ReportesService`,
   las excepciones de `ExcepcionesBiblioteca.cs` y la interfaz `IRepositorio<T>`.
3. Para ejecutarlos sin conflictos con el menú, mueve temporalmente `Program.cs`
   del starter (p. ej. a `Program.cs.bak`) y ejecuta:
   ```bash
   csc TestsBiblioteca.cs Modelos/*.cs Datos/*.cs Servicios/*.cs -out:TestsBiblioteca.exe
   mono TestsBiblioteca.exe
   ```
   O con el .NET SDK:
   ```bash
   dotnet run
   ```
   (el `.csproj` ya compila todos los `.cs` del directorio).
4. El runner imprime `[OK]`/`[FALL]` por check y termina con `0` si todo pasa.

## Qué cubre

- Alta de libros y validación de campos vacíos (`ArgumentException`)
- Alta de miembros y email duplicado (`EmailDuplicadoException`)
- Préstamo de libros disponibles y `LibroNoDisponibleException`
- Devolución que deja el libro disponible
- Búsqueda sin distinguir mayúsculas
- `PrestamosActivosAsync` solo con préstamos no devueltos
- `ReportesService.LibrosMasPrestadosAsync` ordenado por cantidad

Adapta estos tests y añade cobertura para `MiembrosMasActivosAsync`,
`PrestamosVencidosAsync`, miembros inactivos y demás reglas de negocio
descritas en el [`README.md`](../README.md) del proyecto.