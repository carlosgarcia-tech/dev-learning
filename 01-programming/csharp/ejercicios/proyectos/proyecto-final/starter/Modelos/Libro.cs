using System;

namespace Biblioteca
{
    public class Libro
    {
        public int Id { get; set; }
        public string Titulo { get; set; } = "";
        public string Autor { get; set; } = "";
        public string Isbn { get; set; } = "";
        public int AnioPublicacion { get; set; }
        public GeneroLibro Genero { get; set; }
        public bool Disponible { get; set; } = true;

        public Libro()
        {
        }

        public Libro(int id, string titulo, string autor, string isbn, int anioPublicacion, GeneroLibro genero)
        {
            Id = id;
            Titulo = titulo;
            Autor = autor;
            Isbn = isbn;
            AnioPublicacion = anioPublicacion;
            Genero = genero;
            Disponible = true;
        }
    }
}