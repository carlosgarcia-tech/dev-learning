#!/bin/bash
set -euo pipefail

# Script para crear un nuevo ejercicio de C#
#
# Uso: ./new-exercise-csharp.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-csharp.sh nivel-01-fundamentos 01 hola-mundo
#
# Crea un directorio ejercicio-NN-slug/ con:
#   README.md      (enunciado, requisitos, pistas y solución)
#   Program.cs     (stub con TODO)
#   ProgramTest.cs (runner de tests)
#   <slug>.csproj  (configuración del proyecto net8.0)

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-csharp.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-csharp.sh nivel-01-fundamentos 01 hola-mundo"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Clase del stub: EjercicioNN
EJERCICIO_CLASS="Ejercicio$NUM_PADDED"

# Título legible: reemplaza guiones por espacios y capitaliza cada palabra
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Nivel legible (numero extraído de nivel-XX-nombre)
NIVEL_NUM=$(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0*//')

# Directorio destino, relativo a este script (se asume ejecución desde scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/csharp/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"
mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** ${NIVEL_NUM:-?}/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

TODO: describe aquí el enunciado del ejercicio.

Completa el archivo \`Program.cs\` para que la clase estática \`$EJERCICIO_CLASS\`
implemente los métodos que espera \`ProgramTest.cs\`. Con el stub actual lanza
\`NotImplementedException\`; cuando lo completes, todos los checks deben pasar.

## Requisitos

- [ ] El código compila sin errores (\`csc Program.cs ProgramTest.cs\`)
- [ ] El programa se ejecuta correctamente (\`mono ProgramTest.exe\`)
- [ ]
- [ ] Los tests pasan: \`dotnet run\` (con el .NET SDK instalado)
- [ ] Los tests pasan: \`csc Program.cs ProgramTest.cs && mono ProgramTest.exe\` (con Mono/csc)

## Pistas

<details>
<summary>Mostrar pistas</summary>

1.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`csharp
using System;

public static class $EJERCICIO_CLASS
{
    // TODO: Código de la solución
}
\`\`\`

</details>
EOF

# Crear Program.cs (STUB)
cat > "$DIR/Program.cs" << EOF
using System;

public static class $EJERCICIO_CLASS
{
    // TODO: define aquí los métodos estáticos que espera ProgramTest.cs.

    // Ejemplo de método con TODO:
    // public static string Saludar(string nombre)
    // {
    //     throw new NotImplementedException("TODO: implementar Saludar(string)");
    // }
}
EOF

# Crear ProgramTest.cs
cat > "$DIR/ProgramTest.cs" << EOF
using System;

public static class Programa
{
    private static int _fallos;

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

    public static int Main()
    {
        // TODO: añade los checks que verifican $EJERCICIO_CLASS.
        // Ejemplo:
        // Check("Saludar(\"Ana\") devuelve 'Hola, Ana!'",
        //     () => $EJERCICIO_CLASS.Saludar("Ana") == "Hola, Ana!");

        Console.WriteLine();
        if (_fallos == 0)
        {
            Console.WriteLine("Todos los tests pasaron.");
            return 0;
        }
        Console.WriteLine(_fallos + " test(s) fallaron.");
        return 1;
    }
}
EOF

# Crear <slug>.csproj
cat > "$DIR/ejercicio-$NUM_PADDED-$SLUG.csproj" << EOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>disable</ImplicitUsings>
    <Nullable>disable</Nullable>
    <RootNamespace>Ejercicio</RootNamespace>
    <AssemblyName>ejercicio-$NUM_PADDED-$SLUG</AssemblyName>
    <LangVersion>10</LangVersion>
  </PropertyGroup>
</Project>
EOF

echo "✅ Ejercicio creado en: $DIR"