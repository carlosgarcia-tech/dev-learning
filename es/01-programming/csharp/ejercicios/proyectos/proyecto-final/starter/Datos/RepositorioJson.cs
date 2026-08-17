using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace Biblioteca
{
    /// <summary>
    /// Repositorio genérico respaldado por un archivo JSON.
    /// Persiste una lista de entidades en <see cref="_rutaArchivo"/> de forma asíncrona.
    /// </summary>
    public class RepositorioJson<T> : IRepositorio<T>
    {
        private readonly string _rutaArchivo;
        private readonly Func<T, int> _obtenerId;

        public RepositorioJson(string rutaArchivo, Func<T, int> obtenerId)
        {
            _rutaArchivo = rutaArchivo;
            _obtenerId = obtenerId;
        }

        public async Task<List<T>> ObtenerTodosAsync()
        {
            // TODO: si _rutaArchivo no existe, devuelve una lista vacía.
            //       Lee el JSON con File.ReadAllTextAsync y deserialízalo con JsonSerializer.Deserialize<List<T>>.
            //       Si el contenido es vacío o null, devuelve una lista vacía.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.ObtenerTodosAsync()");
        }

        public async Task<T> ObtenerPorIdAsync(int id)
        {
            // TODO: usa ObtenerTodosAsync() y devuelve el primer elemento con _obtenerId(e) == id
            //       (FirstOrDefault). Devuelve default si no existe.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.ObtenerPorIdAsync(int)");
        }

        public async Task<T> AgregarAsync(T entidad)
        {
            // TODO: carga todos, añade entidad y guarda la lista completa. Devuelve entidad.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.AgregarAsync(T)");
        }

        public async Task<T> ActualizarAsync(T entidad)
        {
            // TODO: carga todos, busca por _obtenerId(entidad) con FindIndex,
            //       reemplaza en esa posición y guarda. Devuelve entidad, o default si no existe.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.ActualizarAsync(T)");
        }

        public async Task<bool> EliminarAsync(int id)
        {
            // TODO: carga todos, usa RemoveAll(x => _obtenerId(x) == id) y guarda.
            //       Devuelve true si se eliminó al menos un elemento.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.EliminarAsync(int)");
        }

        public async Task<int> SiguienteIdAsync()
        {
            // TODO: carga todos y devuelve Max(_obtenerId) + 1, o 1 si la colección está vacía.
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.SiguienteIdAsync()");
        }

        private async Task GuardarAsync(List<T> datos)
        {
            // TODO: serializa datos con JsonSerializerOptions { WriteIndented = true }
            //       y escríbelo con File.WriteAllTextAsync.
            //       (Los tests verifican la persistencia leyendo el archivo de nuevo.)
            throw new NotImplementedException("TODO: implementar RepositorioJson<T>.GuardarAsync(List<T>)");
        }
    }
}