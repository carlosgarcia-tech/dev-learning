#!/usr/bin/env bash
set -euo pipefail

# new-exercise-ruby.sh — Crea un nuevo ejercicio de Ruby.
#
# Genera ejercicio-NN-slug/ con:
#   README.md      (enunciado, requisitos, pistas y solución)
#   main.rb        (stub con TODO)
#   test_main.rb   (runner con minitest)
#
# Uso:
#   scripts/new-exercise-ruby.sh <nivel> <numero> <slug>
#   scripts/new-exercise-ruby.sh nivel-01-fundamentos 01 hola-mundo

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-ruby.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-ruby.sh nivel-01-fundamentos 01 hola-mundo"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NUM_PADDED=$(printf "%02d" "$NUM")
DIR="$SCRIPT_DIR/../01-programming/ruby/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"
mkdir -p "$DIR"

TITLE=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
LEVEL_NUM=$(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0*//')

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITLE

- **Nivel:** ${LEVEL_NUM}/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`main.rb\` para que implemente las funciones indicadas.

## Requisitos

- [ ] El programa se ejecuta sin errores
- [ ] Los tests pasan: \`ruby test_main.rb\`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> \`\`\`bash
> ruby test_main.rb
> \`\`\`
>
> El runner usa \`minitest/autorun\` y devuelve el código de salida de Ruby.

## Pistas

<details>
<summary>Mostrar pistas</summary>

-

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`ruby
# Código de la solución
\`\`\`

</details>
EOF

# Crear main.rb (STUB)
cat > "$DIR/main.rb" << 'EOF'
# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise por la implementación correcta.


def resolver
  # TODO: implementa la lógica del ejercicio
  raise NotImplementedError, "TODO: implementar resolver"
end

if __FILE__ == $PROGRAM_NAME
  puts resolver
end
EOF

# Crear test_main.rb
cat > "$DIR/test_main.rb" << 'EOF'
require "minitest/autorun"
require_relative "main"

class TestEjercicio < Minitest::Test
  def test_funcionalidad
    # TODO: Implementar tests
    refute_nil resolver
  end
end
EOF

echo "✅ Ejercicio creado en: $DIR"
