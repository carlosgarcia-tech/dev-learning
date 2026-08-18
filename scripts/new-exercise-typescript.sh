#!/bin/bash
set -euo pipefail

# Script para crear un nuevo ejercicio de TypeScript
#
# Uso: ./new-exercise-typescript.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-typescript.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-typescript.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-typescript.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Directorio base del ejercicio (relativo a la raíz del repo)
BASE_DIR="es/01-programming/typescript/ejercicios/$LEVEL"
DIR="$BASE_DIR/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')
- **Tema:**
- **Tiempo estimado:**

## Enunciado

## Requisitos

- [ ] El archivo compila sin errores (\`npx tsc --noEmit index.ts\`)
- [ ]
- [ ]
- [ ] Los tests pasan: \`node --test index.test.ts\`

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`typescript
// Código de la solución
\`\`\`

</details>
EOF

# Crear index.ts (STUB)
cat > "$DIR/index.ts" << 'EOF'
// TODO: Completa el ejercicio siguiendo el enunciado

// Exporta las variables y funciones para los tests
export {};
EOF

# Crear index.test.ts
cat > "$DIR/index.test.ts" << EOF
import { describe, it } from 'node:test';
import assert from 'node:assert';

// Importa aquí las funciones/variables exportadas desde './index'
// import { ... } from './index';

describe('Ejercicio $NUM_PADDED - $TITULO', () => {
    it('debería implementar correctamente el ejercicio', () => {
        // TODO: Implementar tests
        assert.ok(true, 'Tests implementados correctamente');
    });
});
EOF

echo "✅ Ejercicio creado en: $DIR"
