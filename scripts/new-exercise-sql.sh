#!/bin/bash

LEVEL=$1
NUM=$2
SLUG=$3

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-sql.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-sql.sh nivel-01-fundamentos 01 select-basico"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NUM_PADDED=$(printf "%02d" "$NUM")
DIR="$SCRIPT_DIR/../02-databases/sql/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"
mkdir -p "$DIR"

TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
NIVEL_NUM=$(echo "$LEVEL" | cut -d'-' -f2 | sed 's/^0*//')

cat > "$DIR/README.md" << EOR
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $NIVEL_NUM/5
- **Tema:**
- **Tiempo estimado:**

## Enunciado

## Requisitos

- [ ] Las consultas devuelven los resultados esperados
- [ ] Los tests pasan: \`bash test.sh\`

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`\`sql
-- Código de la solución
\`\`\`\`

</details>
EOR

cat > "$DIR/schema.sql" << EOR
-- TODO: Crear tablas e insertar datos
EOR

cat > "$DIR/solucion.sql" << EOR
-- TODO: Escribir las consultas
EOR

cat > "$DIR/expected.txt" << EOR
-- Resultados esperados
EOR

cat > "$DIR/test.sh" << EOR
#!/bin/bash

sqlite3 test.db < schema.sql
sqlite3 -header -column test.db < solucion.sql > output.txt

if diff output.txt expected.txt; then
    echo "✅ Tests pasaron"
    exit 0
else
    echo "❌ Tests fallaron"
    exit 1
fi
EOR

chmod +x "$DIR/test.sh"

echo "✅ Ejercicio creado en: $DIR"
