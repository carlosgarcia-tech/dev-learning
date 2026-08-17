namespace Biblioteca
{
    /// <summary>
    /// Fábrica de repositorios. Centraliza la creación de repositorios JSON
    /// (patrón Factory) para que las capas superiores no dependan de la implementación.
    /// </summary>
    public static class FabricaRepositorios
    {
        public static IRepositorio<Libro> CrearRepositorioLibros(string rutaArchivo)
        {
            // TODO: devuelve new RepositorioJson<Libro>(rutaArchivo, l => l.Id).
            throw new System.NotImplementedException("TODO: implementar FabricaRepositorios.CrearRepositorioLibros(string)");
        }

        public static IRepositorio<Miembro> CrearRepositorioMiembros(string rutaArchivo)
        {
            // TODO: devuelve new RepositorioJson<Miembro>(rutaArchivo, m => m.Id).
            throw new System.NotImplementedException("TODO: implementar FabricaRepositorios.CrearRepositorioMiembros(string)");
        }

        public static IRepositorio<Prestamo> CrearRepositorioPrestamos(string rutaArchivo)
        {
            // TODO: devuelve new RepositorioJson<Prestamo>(rutaArchivo, p => p.Id).
            throw new System.NotImplementedException("TODO: implementar FabricaRepositorios.CrearRepositorioPrestamos(string)");
        }
    }
}