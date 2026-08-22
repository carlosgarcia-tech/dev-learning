#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de JavaScript
#
# Uso: ./new-exercise-javascript.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-javascript.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-javascript.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-javascript.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Directorio base del ejercicio (resuelto desde la ubicación del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/javascript/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`index.js\` para que implemente las funciones indicadas.

## Requisitos

- [ ]
- [ ]
- [ ] Los tests pasan: \`node --test index.test.js\`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> \`\`\`bash
> node --test index.test.js
> \`\`\`
>
> El runner imprime \`# pass N\` y devuelve el código de salida de Node.

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`javascript
// Código de la solución
\`\`\`

</details>
EOF

# Crear index.js (STUB)
cat > "$DIR/index.js" << 'EOF'
// TODO: Completa el ejercicio siguiendo el enunciado de README.md.
// Sustituye cada throw new Error por la implementación correcta.


function resolver() {
  // TODO: implementa la lógica del ejercicio
  throw new Error("TODO: implementar resolver()");
}

if (require.main === module) {
  console.log(resolver());
}

module.exports = { resolver };
EOF

# Crear index.test.js
cat > "$DIR/index.test.js" << EOF
const { test } = require("node:test");
const assert = require("node:assert/strict");
const { resolver } = require("./index");

test("ejercicio", () => {
  // TODO: implementar tests
  assert.notEqual(resolver(), undefined);
});
EOF

echo "✅ Ejercicio creado en: $DIR"