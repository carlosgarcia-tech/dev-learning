#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de Python
#
# Uso: ./new-exercise-python.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-python.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-python.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-python.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Directorio base del ejercicio (resuelto desde la ubicación del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/python/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`main.py\` para que implemente las funciones indicadas.

## Requisitos

- [ ]
- [ ]
- [ ] Los tests pasan: \`python3 test_main.py\`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> \`\`\`bash
> python3 test_main.py
> \`\`\`
>
> El runner devuelve \`0\` si todos los tests pasan y \`1\` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`python
# Código de la solución
\`\`\`

</details>
EOF

# Crear main.py (STUB)
cat > "$DIR/main.py" << 'EOF'
# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.


def resolver() -> None:
    # TODO: implementa la lógica del ejercicio
    raise NotImplementedError


if __name__ == "__main__":
    resolver()
EOF

# Crear test_main.py
CLASE_TEST="Test$(echo "$TITULO" | tr -d ' ')"
cat > "$DIR/test_main.py" << EOF
import unittest

from main import resolver


class $CLASE_TEST(unittest.TestCase):

    def test_ejercicio(self):
        # TODO: implementar tests
        self.assertIsNone(resolver())


if __name__ == "__main__":
    unittest.main()
EOF

echo "✅ Ejercicio creado en: $DIR"