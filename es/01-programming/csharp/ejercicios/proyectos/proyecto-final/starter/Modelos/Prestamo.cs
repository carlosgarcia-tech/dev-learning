using System;

namespace Biblioteca
{
    public class Prestamo
    {
        public int Id { get; set; }
        public int LibroId { get; set; }
        public int MiembroId { get; set; }
        public DateTime FechaPrestamo { get; set; }
        public DateTime FechaDevolucion { get; set; }
        public bool Devuelto { get; set; }
        public DateTime? FechaDevolucionReal { get; set; }

        public Prestamo()
        {
        }

        public Prestamo(int id, int libroId, int miembroId, DateTime fechaPrestamo, DateTime fechaDevolucion)
        {
            Id = id;
            LibroId = libroId;
            MiembroId = miembroId;
            FechaPrestamo = fechaPrestamo;
            FechaDevolucion = fechaDevolucion;
            Devuelto = false;
            FechaDevolucionReal = null;
        }
    }
}