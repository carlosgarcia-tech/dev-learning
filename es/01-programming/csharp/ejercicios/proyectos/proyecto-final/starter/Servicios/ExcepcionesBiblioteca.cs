using System;

namespace Biblioteca
{
    public class LibroInexistenteException : Exception
    {
        public LibroInexistenteException(string mensaje) : base(mensaje) { }
    }

    public class LibroNoDisponibleException : Exception
    {
        public LibroNoDisponibleException(string mensaje) : base(mensaje) { }
    }

    public class MiembroInexistenteException : Exception
    {
        public MiembroInexistenteException(string mensaje) : base(mensaje) { }
    }

    public class MiembroInactivoException : Exception
    {
        public MiembroInactivoException(string mensaje) : base(mensaje) { }
    }

    public class EmailDuplicadoException : Exception
    {
        public EmailDuplicadoException(string mensaje) : base(mensaje) { }
    }

    public class PrestamoInexistenteException : Exception
    {
        public PrestamoInexistenteException(string mensaje) : base(mensaje) { }
    }
}