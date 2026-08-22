#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de Java
#
# Uso: ./new-exercise-java.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-java.sh nivel-01-fundamentos 01 hola-mundo

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-java.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-java.sh nivel-01-fundamentos 01 hola-mundo"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Nombre de paquete: quita guiones del slug
PACKAGE_SLUG=$(echo "$SLUG" | tr -d '-')

# Título legible: reemplaza guiones por espacios y capitaliza cada palabra
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Nivel legible (numero extraído de nivel-XX-nombre)
NIVEL_NUM=$(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0*//')

# Directorio destino, relativo a este script (se asume ejecución desde scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/java/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"
mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** ${NIVEL_NUM:-?}/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

TODO: describe aquí el enunciado del ejercicio.

## Requisitos

- [ ] El programa compila sin errores (\`javac Main.java\`)
- [ ] El programa se ejecuta correctamente (\`java Main\`)
- [ ]
- [ ] Los tests pasan: \`java MainTest\`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`java
// Código de la solución
\`\`\`

</details>
EOF

# Crear Main.java (STUB)
cat > "$DIR/Main.java" << EOF
package com.ejercicio.$PACKAGE_SLUG;

public class Main {
    public static void main(String[] args) {
        // TODO: Completa el ejercicio
    }
}
EOF

# Crear MainTest.java
cat > "$DIR/MainTest.java" << EOF
package com.ejercicio.$PACKAGE_SLUG;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

public class MainTest {
    public static void main(String[] args) {
        boolean allTestsPassed = true;

        // TODO: Implementar tests

        if (allTestsPassed) {
            System.out.println("\n✅ ¡Todos los tests pasaron!");
            System.exit(0);
        } else {
            System.out.println("\n❌ Algunos tests fallaron.");
            System.exit(1);
        }
    }
}
EOF

echo "✅ Ejercicio creado en: $DIR"
