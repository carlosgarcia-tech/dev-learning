using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Biblioteca
{
    /// <summary>
    /// Lógica de negocio de la biblioteca: alta de libros y miembros,
    /// préstamos y devoluciones, búsquedas y validaciones.
    /// </summary>
    public class BibliotecaService
    {
        public const int DiasDePrestamo = 15;

        private readonly IRepositorio<Libro> _libros;
        private readonly IRepositorio<Miembro> _miembros;
        private readonly IRepositorio<Prestamo> _prestamos;

        public BibliotecaService(
            IRepositorio<Libro> libros,
            IRepositorio<Miembro> miembros,
            IRepositorio<Prestamo> prestamos)
        {
            _libros = libros;
            _miembros = miembros;
            _prestamos = prestamos;
        }

        /// <summary>Registra un libro nuevo y lo persiste.</summary>
        public async Task<Libro> RegistrarLibroAsync(string titulo, string autor, string isbn, int anioPublicacion, GeneroLibro genero)
        {
            // TODO:
            //   - Lanza ArgumentException si titulo/autor/isbn están en blanco.
            //   - Lanza ArgumentException si anioPublicacion < 1800 o > (año actual + 1).
            //   - Crea el libro con _libros.SiguienteIdAsync() y guárdalo con _libros.AgregarAsync.
            //   - Devuelve el libro creado (Disponible = true).
            throw new NotImplementedException("TODO: implementar BibliotecaService.RegistrarLibroAsync(...)");
        }

        /// <summary>Registra un miembro nuevo y lo persiste.</summary>
        public async Task<Miembro> RegistrarMiembroAsync(string nombre, string email, string telefono)
        {
            // TODO:
            //   - Lanza ArgumentException si nombre o email están en blanco.
            //   - Lanza ArgumentException si email no contiene '@' ni '.' (formato inválido).
            //   - Lanza EmailDuplicadoException si ya existe un miembro con ese email (sin distinguir mayúsculas).
            //   - Crea el miembro con _miembros.SiguienteIdAsync() y guárdalo.
            //   - Devuelve el miembro creado (Activo = true).
            throw new NotImplementedException("TODO: implementar BibliotecaService.RegistrarMiembroAsync(...)");
        }

        /// <summary>Presta un libro a un miembro y persiste el préstamo.</summary>
        public async Task<Prestamo> PrestarLibroAsync(int libroId, int miembroId)
        {
            // TODO:
            //   - Libro inexistente  -> LibroInexistenteException.
            //   - Libro no disponible -> LibroNoDisponibleException.
            //   - Miembro inexistente -> MiembroInexistenteException.
            //   - Miembro inactivo    -> MiembroInactivoException.
            //   - Crea el préstamo con _prestamos.SiguienteIdAsync(), FechaPrestamo = DateTime.Today
            //     y FechaDevolucion = DateTime.Today.AddDays(DiasDePrestamo).
            //   - Marca el libro como no disponible y persiste el cambio.
            //   - Persiste el préstamo y devuélvelo.
            throw new NotImplementedException("TODO: implementar BibliotecaService.PrestarLibroAsync(int, int)");
        }

        /// <summary>Devuelve un libro y deja el préstamo cerrado.</summary>
        public async Task<bool> DevolverLibroAsync(int prestamoId)
        {
            // TODO:
            //   - Préstamo inexistente -> PrestamoInexistenteException.
            //   - Préstamo ya devuelto -> InvalidOperationException.
            //   - Marca Devuelto = true y FechaDevolucionReal = DateTime.Today, persiste.
            //   - Devuelve el libro a disponible y persiste el cambio.
            //   - Devuelve true.
            throw new NotImplementedException("TODO: implementar BibliotecaService.DevolverLibroAsync(int)");
        }

        /// <summary>Devuelve los préstamos activos (no devueltos), ordenados por fecha de préstamo.</summary>
        public async Task<List<Prestamo>> PrestamosActivosAsync()
        {
            // TODO: usa LINQ: Where(Devuelto == false) y OrderBy(FechaPrestamo).
            throw new NotImplementedException("TODO: implementar BibliotecaService.PrestamosActivosAsync()");
        }

        /// <summary>
        /// Busca libros cuyo título, autor o ISBN contengan el texto
        /// (sin distinguir mayúsculas), ordenados por título.
        /// </summary>
        public async Task<List<Libro>> BuscarLibrosAsync(string texto)
        {
            // TODO: usa StringComparison.OrdinalIgnoreCase y OrderBy(Titulo).
            throw new NotImplementedException("TODO: implementar BibliotecaService.BuscarLibrosAsync(string)");
        }

        /// <summary>Devuelve los libros disponibles, ordenados por título.</summary>
        public async Task<List<Libro>> LibrosDisponiblesAsync()
        {
            // TODO: usa LINQ: Where(Disponible == true) y OrderBy(Titulo).
            throw new NotImplementedException("TODO: implementar BibliotecaService.LibrosDisponiblesAsync()");
        }

        /// <summary>Devuelve los libros actualmente prestados, ordenados por título.</summary>
        public async Task<List<Libro>> LibrosPrestadosAsync()
        {
            // TODO: usa LINQ: Where(Disponible == false) y OrderBy(Titulo).
            throw new NotImplementedException("TODO: implementar BibliotecaService.LibrosPrestadosAsync()");
        }
    }
}