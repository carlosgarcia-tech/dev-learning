#!/usr/bin/env bash
set -euo pipefail

# Script para crear un nuevo ejercicio de Rust
#
# Uso: ./new-exercise-rust.sh <nivel> <numero> <slug>
# Ejemplo: ./new-exercise-rust.sh nivel-01-fundamentos 1 tipos-basicos

LEVEL=${1:-}
NUM=${2:-}
SLUG=${3:-}

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-rust.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-rust.sh nivel-01-fundamentos 1 tipos-basicos"
    exit 1
fi

# Formatear número con dos dígitos
NUM_PADDED=$(printf "%02d" "$NUM")

# Título legible a partir del slug (reemplaza guiones por espacios y capitaliza)
TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Package name de Cargo: slug con guiones (válido para Cargo) y sin guión bajo
CRATE_NAME=$(echo "$SLUG" | tr '_' '-')

# Directorio base del ejercicio (resuelto desde la ubicación del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/../01-programming/rust/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"

mkdir -p "$DIR/src"

# Crear Cargo.toml
cat > "$DIR/Cargo.toml" << EOF
[package]
name = "ejercicio_${NUM_PADDED}_${CRATE_NAME}"
version = "0.1.0"
edition = "2021"
EOF

# Crear README.md
cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0//')/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

Completa \`src/main.rs\` para que implemente las funciones indicadas.

## Requisitos

- [ ]
- [ ]
- [ ] Los tests pasan: \`cargo test\`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> \`\`\`bash
> cargo test
> \`\`\`
>
> Cargo compila el binario y ejecuta el módulo de tests embebido en
> \`src/main.rs\`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`rust
// Código de la solución
\`\`\`

</details>
EOF

# Crear src/main.rs (STUB con tests embebidos)
cat > "$DIR/src/main.rs" << 'EOF'
// TODO: Completa el ejercicio siguiendo el enunciado de README.md.
// Sustituye cada todo!() por la implementación correcta.

fn resolver() -> i32 {
    // TODO: implementa la lógica del ejercicio
    todo!("implementar resolver()")
}

fn main() {
    println!("{}", resolver());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn resolver_funciona() {
        assert_eq!(resolver(), 0);
    }
}
EOF

echo "✅ Ejercicio creado en: $DIR"
echo "   Implementa src/main.rs y verifica con 'cargo test'."