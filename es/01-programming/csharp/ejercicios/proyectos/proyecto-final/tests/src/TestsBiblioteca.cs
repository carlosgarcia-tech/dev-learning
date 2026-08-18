using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Biblioteca;

public static class TestsBiblioteca
{
    private static int _fallos;

    private static void Check(string nombre, Func<Task<bool>> prueba)
    {
        try
        {
            if (prueba().GetAwaiter().GetResult())
            {
                Console.WriteLine("[OK]   " + nombre);
            }
            else
            {
                Console.WriteLine("[FALL] " + nombre);
                _fallos++;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("[FALL] " + nombre + " -> " + ex.GetType().Name + ": " + ex.Message);
            _fallos++;
        }
    }

    private static void Check(string nombre, Func<bool> prueba)
    {
        try
        {
            if (prueba())
            {
                Console.WriteLine("[OK]   " + nombre);
            }
            else
            {
                Console.WriteLine("[FALL] " + nombre);
                _fallos++;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("[FALL] " + nombre + " -> " + ex.GetType().Name + ": " + ex.Message);
            _fallos++;
        }
    }

    private static async Task<BibliotecaService> CrearServicio()
    {
        var libros = new RepositorioMemoria<Libro>();
        var miembros = new RepositorioMemoria<Miembro>();
        var prestamos = new RepositorioMemoria<Prestamo>();
        return new BibliotecaService(libros, miembros, prestamos);
    }

    public static async Task<int> Main()
    {
        // --- BibliotecaService ---
        Check("Registrar libro disponible", async () =>
        {
            var s = await CrearServicio();
            var libro = await s.RegistrarLibroAsync("Cien años de soledad", "Gabriel García Márquez", "978-3-16-148410-0", 1967, GeneroLibro.Ficcion);
            return libro.Titulo == "Cien años de soledad" && libro.Disponible;
        });

        Check("Registrar libro con título vacío lanza ArgumentException", async () =>
        {
            var s = await CrearServicio();
            try { await s.RegistrarLibroAsync("", "Autor", "123", 2020, GeneroLibro.Ficcion); return false; }
            catch (ArgumentException) { return true; }
        });

        Check("Registrar miembro", async () =>
        {
            var s = await CrearServicio();
            var m = await s.RegistrarMiembroAsync("Ana", "ana@mail.com", "600000000");
            return m.Email == "ana@mail.com" && m.Activo;
        });

        Check("Email duplicado lanza EmailDuplicadoException", async () =>
        {
            var s = await CrearServicio();
            await s.RegistrarMiembroAsync("Ana", "ana@mail.com", "600000000");
            try { await s.RegistrarMiembroAsync("Otro", "ANA@mail.com", "600000001"); return false; }
            catch (EmailDuplicadoException) { return true; }
        });

        Check("Prestar libro disponible", async () =>
        {
            var s = await CrearServicio();
            var libro = await s.RegistrarLibroAsync("Don Quijote", "Cervantes", "111", 1605, GeneroLibro.Ficcion);
            var miembro = await s.RegistrarMiembroAsync("Luis", "luis@mail.com", "611111111");
            var prestamo = await s.PrestarLibroAsync(libro.Id, miembro.Id);
            var disponibles = await s.LibrosDisponiblesAsync();
            return !libro.Disponible && disponibles.All(l => l.Id != libro.Id);
        });

        Check("Prestar libro no disponible lanza LibroNoDisponibleException", async () =>
        {
            var s = await CrearServicio();
            var libro = await s.RegistrarLibroAsync("Libro", "Autor", "222", 2000, GeneroLibro.Ficcion);
            var m1 = await s.RegistrarMiembroAsync("A", "a@mail.com", "1");
            var m2 = await s.RegistrarMiembroAsync("B", "b@mail.com", "2");
            await s.PrestarLibroAsync(libro.Id, m1.Id);
            try { await s.PrestarLibroAsync(libro.Id, m2.Id); return false; }
            catch (LibroNoDisponibleException) { return true; }
        });

        Check("Devolver libro lo deja disponible", async () =>
        {
            var s = await CrearServicio();
            var libro = await s.RegistrarLibroAsync("Libro", "Autor", "333", 2000, GeneroLibro.Ficcion);
            var miembro = await s.RegistrarMiembroAsync("C", "c@mail.com", "3");
            var prestamo = await s.PrestarLibroAsync(libro.Id, miembro.Id);
            await s.DevolverLibroAsync(prestamo.Id);
            var disponibles = await s.LibrosDisponiblesAsync();
            return disponibles.Any(l => l.Id == libro.Id);
        });

        Check("Buscar libros por texto sin distinguir mayúsculas", async () =>
        {
            var s = await CrearServicio();
            await s.RegistrarLibroAsync("La ciudad y los perros", "Vargas Llosa", "444", 1963, GeneroLibro.Ficcion);
            await s.RegistrarLibroAsync("El túnel", "Sabato", "555", 1948, GeneroLibro.Ficcion);
            var r = await s.BuscarLibrosAsync("CIUDAD");
            return r.Count == 1 && r[0].Titulo.Contains("ciudad", StringComparison.OrdinalIgnoreCase);
        });

        Check("PrestamosActivosAsync solo devuelve no devueltos", async () =>
        {
            var s = await CrearServicio();
            var libro = await s.RegistrarLibroAsync("Libro", "Autor", "666", 2000, GeneroLibro.Ficcion);
            var miembro = await s.RegistrarMiembroAsync("D", "d@mail.com", "4");
            var p1 = await s.PrestarLibroAsync(libro.Id, miembro.Id);
            var libro2 = await s.RegistrarLibroAsync("Libro 2", "Autor", "667", 2001, GeneroLibro.Ficcion);
            await s.PrestarLibroAsync(libro2.Id, miembro.Id);
            await s.DevolverLibroAsync(p1.Id);
            var activos = await s.PrestamosActivosAsync();
            return activos.Count == 1 && activos.All(p => !p.Devuelto);
        });

        // --- ReportesService ---
        Check("ReportesService LibrosMasPrestadosAsync ordena por cantidad", async () =>
        {
            var libros = new RepositorioMemoria<Libro>();
            var miembros = new RepositorioMemoria<Miembro>();
            var prestamos = new RepositorioMemoria<Prestamo>();
            var s = new BibliotecaService(libros, miembros, prestamos);
            var r = new ReportesService(libros, miembros, prestamos);

            var l1 = await s.RegistrarLibroAsync("A", "X", "1", 2000, GeneroLibro.Ficcion);
            var l2 = await s.RegistrarLibroAsync("B", "Y", "2", 2001, GeneroLibro.Ficcion);
            var m = await s.RegistrarMiembroAsync("E", "e@mail.com", "5");

            await s.PrestarLibroAsync(l1.Id, m.Id);
            var p = prestamos.ObtenerTodos().First(x => x.LibroId == l1.Id);
            await s.DevolverLibroAsync(p.Id);
            await s.PrestarLibroAsync(l1.Id, m.Id);
            await s.PrestarLibroAsync(l2.Id, m.Id);

            var top = await r.LibrosMasPrestadosAsync(2);
            return top.Count == 2 && top[0].Titulo == "A" && top[0].Cantidad >= top[1].Cantidad;
        });

        Console.WriteLine();
        if (_fallos == 0)
        {
            Console.WriteLine("Todos los tests pasaron.");
            return 0;
        }
        Console.WriteLine(_fallos + " test(s) fallaron.");
        return 1;
    }

    /// <summary>Repositorio en memoria de apoyo para los tests (evita depender de archivos).</summary>
    private sealed class RepositorioMemoria<T> : IRepositorio<T>
        where T : class
    {
        private readonly List<T> _items = new();
        private int _siguienteId = 1;

        public List<T> ObtenerTodos() => _items;

        public Task<List<T>> ObtenerTodosAsync() => Task.FromResult(new List<T>(_items));

        public Task<T> ObtenerPorIdAsync(int id)
        {
            var item = _items.FirstOrDefault(x => GetId(x) == id);
            return Task.FromResult(item);
        }

        public Task<T> AgregarAsync(T entidad) { _items.Add(entidad); return Task.FromResult(entidad); }

        public Task<T> ActualizarAsync(T entidad)
        {
            var id = GetId(entidad);
            var idx = _items.FindIndex(x => GetId(x) == id);
            if (idx >= 0) _items[idx] = entidad;
            return Task.FromResult(entidad);
        }

        public Task<bool> EliminarAsync(int id)
        {
            return Task.FromResult(_items.RemoveAll(x => GetId(x) == id) > 0);
        }

        public Task<int> SiguienteIdAsync() => Task.FromResult(_siguienteId++);

        private static int GetId(T entidad) =>
            (int)(entidad is Libro l ? l.Id : entidad is Miembro m ? m.Id : entidad is Prestamo p ? p.Id : 0);
    }
}