using System;

namespace Biblioteca
{
    public class Miembro
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = "";
        public string Email { get; set; } = "";
        public string Telefono { get; set; } = "";
        public DateTime FechaRegistro { get; set; }
        public bool Activo { get; set; } = true;

        public Miembro()
        {
        }

        public Miembro(int id, string nombre, string email, string telefono)
        {
            Id = id;
            Nombre = nombre;
            Email = email;
            Telefono = telefono;
            FechaRegistro = DateTime.Today;
            Activo = true;
        }
    }
}