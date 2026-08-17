using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Biblioteca
{
    /// <summary>
    /// Reportes y estadísticas de la biblioteca con consultas LINQ.
    /// </summary>
    public class ReportesService
    {
        private readonly IRepositorio<Libro> _libros;
        private readonly IRepositorio<Miembro> _miembros;
        private readonly IRepositorio<Prestamo> _prestamos;

        public ReportesService(
            IRepositorio<Libro> libros,
            IRepositorio<Miembro> miembros,
            IRepositorio<Prestamo> prestamos)
        {
            _libros = libros;
            _miembros = miembros;
            _prestamos = prestamos;
        }

        /// <summary>
        /// Devuelve los n libros más prestados como tuplas (Titulo, Cantidad),
        /// ordenados por cantidad descendente y, en caso de empate, por título.
        /// </summary>
        public async Task<List<(string Titulo, int Cantidad)>> LibrosMasPrestadosAsync(int n)
        {
            // TODO: agrupa los préstamos por LibroId, cuenta cada grupo,
            //       une con el título del libro, ordena por cantidad desc. y luego por título,
            //       y toma los primeros n.
            throw new NotImplementedException("TODO: implementar ReportesService.LibrosMasPrestadosAsync(int)");
        }

        /// <summary>
        /// Devuelve los n miembros con más préstamos como tuplas (Nombre, Cantidad),
        /// ordenados por cantidad descendente y, en caso de empate, por nombre.
        /// </summary>
        public async Task<List<(string Nombre, int Cantidad)>> MiembrosMasActivosAsync(int n)
        {
            // TODO: análogo a LibrosMasPrestadosAsync pero agrupando por MiembroId y uniendo con el miembro.
            throw new NotImplementedException("TODO: implementar ReportesService.MiembrosMasActivosAsync(int)");
        }

        /// <summary>Préstamos activos cuya fecha de devolución prevista ya pasó.</summary>
        public async Task<List<Prestamo>> PrestamosVencidosAsync()
        {
            // TODO: Where(!Devuelto && FechaDevolucion < DateTime.Today), ordenados por FechaDevolucion.
            throw new NotImplementedException("TODO: implementar ReportesService.PrestamosVencidosAsync()");
        }

        /// <summary>Cantidad de préstamos vencidos.</summary>
        public async Task<int> ContarPrestamosVencidosAsync()
        {
            // TODO: (await PrestamosVencidosAsync()).Count.
            throw new NotImplementedException("TODO: implementar ReportesService.ContarPrestamosVencidosAsync()");
        }

        /// <summary>
        /// Resumen de la biblioteca: total de libros, disponibles, prestados,
        /// miembros activos y préstamos activos.
        /// </summary>
        public async Task<(int TotalLibros, int Disponibles, int Prestados, int MiembrosActivos, int PrestamosActivos)> ResumenAsync()
        {
            // TODO: calcula cada contador con LINQ sobre las colecciones completas.
            throw new NotImplementedException("TODO: implementar ReportesService.ResumenAsync()");
        }

        /// <summary>Número de préstamos por género literario del libro prestado.</summary>
        public async Task<Dictionary<GeneroLibro, int>> PrestamosPorGeneroAsync()
        {
            // TODO: cruza los préstamos con los libros (por LibroId) y agrupa por Genero.
            //       Devuelve un diccionario con todos los géneros, incluidos los sin préstamos (0).
            throw new NotImplementedException("TODO: implementar ReportesService.PrestamosPorGeneroAsync()");
        }

        /// <summary>Promedio de préstamos por miembro (0.0 si no hay miembros).</summary>
        public async Task<double> PromedioPrestamosPorMiembroAsync()
        {
            // TODO: total de préstamos / total de miembros. Divide con double.
            throw new NotImplementedException("TODO: implementar ReportesService.PromedioPrestamosPorMiembroAsync()");
        }
    }
}