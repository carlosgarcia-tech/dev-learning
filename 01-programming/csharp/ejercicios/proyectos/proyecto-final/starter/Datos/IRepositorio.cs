using System.Collections.Generic;
using System.Threading.Tasks;

namespace Biblioteca
{
    public interface IRepositorio<T>
    {
        Task<List<T>> ObtenerTodosAsync();
        Task<T> ObtenerPorIdAsync(int id);
        Task<T> AgregarAsync(T entidad);
        Task<T> ActualizarAsync(T entidad);
        Task<bool> EliminarAsync(int id);
        Task<int> SiguienteIdAsync();
    }
}