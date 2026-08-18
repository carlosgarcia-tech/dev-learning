using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Biblioteca
{
    /// <summary>
    /// Interfaz de consola del Sistema de Gestión de Biblioteca.
    /// El menú delega en BibliotecaService y ReportesService; la persistencia
    /// usa los repositorios JSON de la carpeta ./data.
    /// </summary>
    public static class Programa
    {
        private static BibliotecaService _servicio = null!;
        private static ReportesService _reportes = null!;

        public static async Task<int> Main()
        {
            string dirDatos = Path.Combine(Environment.CurrentDirectory, "data");
            Directory.CreateDirectory(dirDatos);

            var libros = FabricaRepositorios.CrearRepositorioLibros(Path.Combine(dirDatos, "libros.json"));
            var miembros = FabricaRepositorios.CrearRepositorioMiembros(Path.Combine(dirDatos, "miembros.json"));
            var prestamos = FabricaRepositorios.CrearRepositorioPrestamos(Path.Combine(dirDatos, "prestamos.json"));

            _servicio = new BibliotecaService(libros, miembros, prestamos);
            _reportes = new ReportesService(libros, miembros, prestamos);

            Console.WriteLine("=== Sistema de Gestión de Biblioteca ===");
            bool salir = false;
            while (!salir)
            {
                MostrarMenu();
                string? opcion = Console.ReadLine();
                try
                {
                    salir = opcion switch
                    {
                        "1" => await RegistrarLibroAsync(),
                        "2" => await RegistrarMiembroAsync(),
                        "3" => await PrestarAsync(),
                        "4" => await DevolverAsync(),
                        "5" => await BuscarAsync(),
                        "6" => await ListarAsync(),
                        "7" => await MostrarReportesAsync(),
                        "0" => true,
                        _ => false
                    };
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"  ERROR: {ex.Message}");
                }
            }
            Console.WriteLine("¡Hasta pronto!");
            return 0;
        }

        private static void MostrarMenu()
        {
            Console.WriteLine();
            Console.WriteLine("1. Registrar libro");
            Console.WriteLine("2. Registrar miembro");
            Console.WriteLine("3. Prestar libro");
            Console.WriteLine("4. Devolver libro");
            Console.WriteLine("5. Buscar libros");
            Console.WriteLine("6. Listar disponibles / prestados");
            Console.WriteLine("7. Reportes");
            Console.WriteLine("0. Salir");
            Console.Write("Opción: ");
        }

        private static async Task<bool> RegistrarLibroAsync()
        {
            Console.Write("Título: ");
            string titulo = Console.ReadLine() ?? "";
            Console.Write("Autor: ");
            string autor = Console.ReadLine() ?? "";
            Console.Write("ISBN: ");
            string isbn = Console.ReadLine() ?? "";
            Console.Write("Año de publicación: ");
            int anio = int.Parse(Console.ReadLine() ?? "0");
            Console.Write("Género (Ficcion, NoFiccion, Ciencia, Historia, Tecnologia, Infantil, Otro): ");
            var genero = Enum.TryParse<GeneroLibro>(Console.ReadLine(), true, out var g) ? g : GeneroLibro.Otro;

            var libro = await _servicio.RegistrarLibroAsync(titulo, autor, isbn, anio, genero);
            Console.WriteLine($"  Libro registrado con id {libro.Id}: '{libro.Titulo}'");
            return false;
        }

        private static async Task<bool> RegistrarMiembroAsync()
        {
            Console.Write("Nombre: ");
            string nombre = Console.ReadLine() ?? "";
            Console.Write("Email: ");
            string email = Console.ReadLine() ?? "";
            Console.Write("Teléfono: ");
            string telefono = Console.ReadLine() ?? "";

            var miembro = await _servicio.RegistrarMiembroAsync(nombre, email, telefono);
            Console.WriteLine($"  Miembro registrado con id {miembro.Id}: {miembro.Nombre}");
            return false;
        }

        private static async Task<bool> PrestarAsync()
        {
            Console.Write("Id del libro: ");
            int libroId = int.Parse(Console.ReadLine() ?? "0");
            Console.Write("Id del miembro: ");
            int miembroId = int.Parse(Console.ReadLine() ?? "0");

            var prestamo = await _servicio.PrestarLibroAsync(libroId, miembroId);
            Console.WriteLine($"  Préstamo {prestamo.Id} creado. Devolución prevista: {prestamo.FechaDevolucion:yyyy-MM-dd}");
            return false;
        }

        private static async Task<bool> DevolverAsync()
        {
            Console.Write("Id del préstamo: ");
            int prestamoId = int.Parse(Console.ReadLine() ?? "0");

            await _servicio.DevolverLibroAsync(prestamoId);
            Console.WriteLine("  Préstamo devuelto.");
            return false;
        }

        private static async Task<bool> BuscarAsync()
        {
            Console.Write("Texto a buscar: ");
            string texto = Console.ReadLine() ?? "";
            var resultados = await _servicio.BuscarLibrosAsync(texto);
            if (resultados.Count == 0)
            {
                Console.WriteLine("  Sin resultados.");
                return false;
            }
            foreach (var libro in resultados)
            {
                Console.WriteLine($"  [{libro.Id}] {libro.Titulo} — {libro.Autor} ({(libro.Disponible ? "disponible" : "prestado")})");
            }
            return false;
        }

        private static async Task<bool> ListarAsync()
        {
            var disponibles = await _servicio.LibrosDisponiblesAsync();
            var prestados = await _servicio.LibrosPrestadosAsync();
            Console.WriteLine($"  Disponibles ({disponibles.Count}):");
            foreach (var l in disponibles) Console.WriteLine($"    - {l.Titulo}");
            Console.WriteLine($"  Prestados ({prestados.Count}):");
            foreach (var l in prestados) Console.WriteLine($"    - {l.Titulo}");
            return false;
        }

        private static async Task<bool> MostrarReportesAsync()
        {
            var resumen = await _reportes.ResumenAsync();
            Console.WriteLine($"  Total libros: {resumen.TotalLibros} | Disponibles: {resumen.Disponibles} | Prestados: {resumen.Prestados}");
            Console.WriteLine($"  Miembros activos: {resumen.MiembrosActivos} | Préstamos activos: {resumen.PrestamosActivos}");
            Console.WriteLine($"  Vencidos: {await _reportes.ContarPrestamosVencidosAsync()}");

            var top = await _reportes.LibrosMasPrestadosAsync(3);
            Console.WriteLine("  Libros más prestados:");
            foreach (var (titulo, cantidad) in top)
                Console.WriteLine($"    - {titulo}: {cantidad}");
            return false;
        }
    }
}