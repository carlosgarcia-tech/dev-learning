#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de Go
#
# Uso: ./new-exercise-go.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-go.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-go.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-go.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Directorio base del ejercicio (resuelto desde la ubicación del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/go/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR"

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`main.go\` para que implemente lo indicado.

## Requisitos

- [ ]
- [ ]
- [ ] El programa compila sin errores
- [ ] Los tests pasan: \`go test -v ./...\`

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`go
// Código de la solución
\`\`\`

</details>
EOF

# Crear go.mod
MODULE="ejercicio-$NUM_PADDED-$SLUG"
cat > "$DIR/go.mod" << EOF
module $MODULE

go 1.26
EOF

# Crear main.go (STUB)
cat > "$DIR/main.go" << 'EOF'
package main

func main() {
	// TODO: Completa el ejercicio siguiendo el enunciado
	// Recuerda declarar las variables, asignarles valores y mostrarlas
}
EOF

# Crear main_test.go
cat > "$DIR/main_test.go" << 'EOF'
package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"strings"
	"testing"
)

func TestMainFunction(t *testing.T) {
	originalStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	main()

	w.Close()
	os.Stdout = originalStdout

	var buf bytes.Buffer
	io.Copy(&buf, r)
	output := buf.String()

	// TODO: ajusta las comprobaciones a la salida esperada del ejercicio
	expectedData := []string{
		"TODO:",
	}

	for _, expected := range expectedData {
		if !strings.Contains(output, expected) {
			t.Errorf("La salida no contiene '%s'.\nSalida obtenida:\n%s", expected, output)
		}
	}

	fmt.Println("✅ ¡Todos los tests pasaron!")
}
EOF

echo "✅ Ejercicio creado en: $DIR"