# Ejercicio 04 — Listas y diccionarios

- **Nivel:** 2/5
- **Tema:** `List<T>`, `Dictionary<K,V>`, `ContainsKey`, `TryGetValue`, LINQ
- **Tiempo estimado:** 25 min

## Enunciado

Completa `ejercicio-04-listas-y-diccionarios.cs` para que `Ejercicio04` implemente:

1. `List<int> Ordenar(List<int> numeros)` — nueva lista ordenada de menor a mayor.
2. `Dictionary<string,int> ContarPalabras(string texto)` — cuenta cada palabra (sin distinguir mayúsculas). Ej.: `"hola Hola mundo"` → `{ "hola": 2, "mundo": 1 }`.
3. `bool ExisteClave(Dictionary<string,int> diccionario, string clave)` — usa `ContainsKey`.
4. `List<string> ClavesOrdenadas(Dictionary<string,int> diccionario)` — las claves en orden alfabético.
5. `int ObtenerValorODefecto(Dictionary<string,int> diccionario, string clave, int defecto)` — usa `TryGetValue`.

Salida esperada de ejemplo:

```
[OK]   Ordenar([3,1,2]) devuelve [1,2,3]
[OK]   ContarPalabras("hola hola mundo") cuenta hola 2 veces
[OK]   ObtenerValorODefecto devuelve el valor o el defecto
```

## Requisitos

- [ ] `Ordenar` no modifica la lista original.
- [ ] `ContarPalabras` normaliza mayúsculas/minúsculas.
- [ ] `ExisteClave` usa `ContainsKey`.
- [ ] `ObtenerValorODefecto` usa `TryGetValue`.
- [ ] Los tests pasan: `csc ejercicio-04-listas-y-diccionarios.cs ejercicio-04-listas-y-diccionarios_test.cs && mono ejercicio-04-listas-y-diccionarios_test.exe` (si tienes Mono/csc).
- [ ] Los tests pasan: `dotnet run` (al instalar el .NET SDK).

> **Nota:** el .NET SDK **no está instalado** en esta máquina. Con el SDK instalado:
> ```bash
> dotnet new console -o . --force
> rm Program.cs
> dotnet run
> ```
> Con Mono/csc: `csc ejercicio-04-listas-y-diccionarios.cs ejercicio-04-listas-y-diccionarios_test.cs` y `mono ejercicio-04-listas-y-diccionarios_test.exe`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `numeros.OrderBy(n => n).ToList()` (necesitas `using System.Linq;`).
- Para contar: recorre las palabras, usa `diccionario.ContainsKey` e incrementa.
- `diccionario.TryGetValue(clave, out int valor)` devuelve `bool`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class Ejercicio04
{
    public static List<int> Ordenar(List<int> numeros)
        => numeros.OrderBy(n => n).ToList();

    public static Dictionary<string, int> ContarPalabras(string texto)
    {
        var resultado = new Dictionary<string, int>();
        string[] palabras = texto.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        foreach (string palabra in palabras)
        {
            string clave = palabra.ToLower();
            if (resultado.ContainsKey(clave))
            {
                resultado[clave]++;
            }
            else
            {
                resultado[clave] = 1;
            }
        }
        return resultado;
    }

    public static bool ExisteClave(Dictionary<string, int> diccionario, string clave)
        => diccionario.ContainsKey(clave);

    public static List<string> ClavesOrdenadas(Dictionary<string, int> diccionario)
        => diccionario.Keys.OrderBy(k => k).ToList();

    public static int ObtenerValorODefecto(Dictionary<string, int> diccionario, string clave, int defecto)
        => diccionario.TryGetValue(clave, out int valor) ? valor : defecto;
}
````

</details>