# Ejercicio 04 — Caché LRU

- **Nivel:** 5/5
- **Tema:** estructura de datos LRU, `LinkedList`, `Dictionary`, eficiencia
- **Tiempo estimado:** 45 min

## Enunciado

Completa `ejercicio-04-cache-lru.cs`. Implementa una **caché LRU** (Least Recently Used) con capacidad fija. La estructura se basa en un `Dictionary<string,string>` (valores) y un `LinkedList<string>` (orden de uso: la **primera** es la menos usada y la **última** la más reciente).

Clase `CacheLru`:

1. `CacheLru(int capacidad)` — lanza `ArgumentException` si `capacidad <= 0`.
2. `void Set(string clave, string valor)`:
   - Si la clave existe, actualiza el valor y la mueve al final.
   - Si no existe y la caché está llena, **elimina la menos usada** (primera del orden) y añade la nueva al final.
3. `string? Get(string clave)` — devuelve el valor, o `null` si no existe; si existe, la mueve al final.
4. `bool Contiene(string clave)` — `true` si está en la caché.
5. `int Count` — cantidad de claves (ya implementado).

Salida esperada de ejemplo:

```
[OK]   Set y Get básicos funcionan
[OK]   Al superar la capacidad se elimina la clave menos usada
[OK]   Acceder a una clave la marca como la más reciente
```

## Requisitos

- [ ] `CacheLru(0)` lanza `ArgumentException`.
- [ ] `Set`/`Get`/`Contiene` básicos funcionan.
- [ ] Con capacidad llena, `Set` de una clave nueva elimina la **menos recientemente usada**.
- [ ] `Get` marca la clave como la más reciente (afecta a qué clave se elimina después).
- [ ] Actualizar una clave existente no incrementa el `Count`.
- [ ] Los tests pasan: `csc ejercicio-04-cache-lru.cs ejercicio-04-cache-lru_test.cs && mono ejercicio-04-cache-lru_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-04-cache-lru.cs ejercicio-04-cache-lru_test.cs` y `mono ejercicio-04-cache-lru_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `_orden.First` es la clave menos usada; `_orden.AddLast(clave)` la marca como reciente.
- `_orden.Find(clave)` devuelve el nodo; si existe, `Remove(nodo)` y `AddLast(clave)` lo mueven.
- `_valores.Remove(menosUsada)` + `_orden.RemoveFirst()` eliminan la LRU.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
#nullable enable
using System;
using System.Collections.Generic;

public class CacheLru
{
    private readonly int _capacidad;
    private readonly Dictionary<string, string> _valores = new Dictionary<string, string>();
    private readonly LinkedList<string> _orden = new LinkedList<string>();

    public CacheLru(int capacidad)
    {
        if (capacidad <= 0)
            throw new ArgumentException("La capacidad debe ser mayor que cero.");
        _capacidad = capacidad;
    }

    public int Count => _valores.Count;

    public void Set(string clave, string valor)
    {
        if (_valores.ContainsKey(clave))
        {
            _valores[clave] = valor;
            MoverAlFinal(clave);
            return;
        }

        if (_valores.Count >= _capacidad)
        {
            LinkedListNode<string>? menosUsada = _orden.First;
            if (menosUsada != null)
            {
                _valores.Remove(menosUsada.Value);
                _orden.RemoveFirst();
            }
        }

        _valores[clave] = valor;
        _orden.AddLast(clave);
    }

    public string? Get(string clave)
    {
        if (!_valores.ContainsKey(clave)) return null;
        MoverAlFinal(clave);
        return _valores[clave];
    }

    public bool Contiene(string clave) => _valores.ContainsKey(clave);

    private void MoverAlFinal(string clave)
    {
        LinkedListNode<string>? nodo = _orden.Find(clave);
        if (nodo != null)
        {
            _orden.Remove(nodo);
            _orden.AddLast(clave);
        }
    }
}

public static class Ejercicio04
{
    public static CacheLru CrearCache(int capacidad) => new CacheLru(capacidad);
}
````

</details>