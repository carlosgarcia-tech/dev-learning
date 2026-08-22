#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de PHP
#
# Uso: ./new-exercise-php.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-php.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-php.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-php.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Directorio base del ejercicio (resuelto desde la ubicación del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/php/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`index.php\` para que implemente las funciones indicadas.

## Requisitos

- [ ]
- [ ]
- [ ] Los tests pasan: \`php index_test.php\`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> \`\`\`bash
> php index_test.php
> \`\`\`
>
> El script imprime \`OK: todas las aserciones pasaron.\` y devuelve \`exit(0)\`
> si pasan; imprime los errores y devuelve \`exit(1)\` si no.

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`php
// Código de la solución
\`\`\`

</details>
EOF

# Crear index.php (STUB)
cat > "$DIR/index.php" << 'EOF'
<?php

declare(strict_types=1);

function resolver(): mixed
{
    // TODO: implementa la lógica del ejercicio
    throw new Exception("TODO: implementar resolver()");
}
EOF

# Crear index_test.php
cat > "$DIR/index_test.php" << 'EOF'
<?php

declare(strict_types=1);

require __DIR__ . '/index.php';

$errores = [];

function check(bool $condicion, string $mensaje): void
{
    global $errores;
    if (!$condicion) {
        $errores[] = $mensaje;
    }
}

check(resolver() !== null, 'resolver debe devolver un valor');

if ($errores !== []) {
    fwrite(STDERR, implode(PHP_EOL, $errores) . PHP_EOL);
    exit(1);
}

echo "OK: todas las aserciones pasaron." . PHP_EOL;
exit(0);
EOF

echo "✅ Ejercicio creado en: $DIR"