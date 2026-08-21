#!/bin/bash
set -e

LEVEL=$1
NUM=$2
SLUG=$3

if [ -z "$LEVEL" ] || [ -z "$NUM" ] || [ -z "$SLUG" ]; then
    echo "Uso: ./new-exercise-postgresql.sh <nivel> <numero> <slug>"
    echo "Ejemplo: ./new-exercise-postgresql.sh nivel-01-fundamentos 01 connect-create-db"
    exit 1
fi

NUM_PADDED=$(printf "%02d" "$NUM")
DIR="es/02-databases/postgresql/ejercicios/$LEVEL/ejercicio-$NUM_PADDED-$SLUG"
mkdir -p "$DIR"

TITULO=$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
NIVEL_NUM=$(echo "$LEVEL" | cut -d'-' -f2)

# NOTA IMPORTANTE respecto a la version original de este script:
# los heredocs de abajo usan comillas simples alrededor del delimitador
# (<< 'EOF') en los archivos que deben contener LITERALMENTE variables de
# shell como $DB_HOST (para que se evaluen cuando test.sh se EJECUTE, no
# cuando este generador corre). El script original usaba `<< EOF` sin
# comillas en todos los casos, lo que expandia esas variables en el momento
# de generar el archivo (casi siempre vacias), produciendo un test.sh roto.
# Para el README, en cambio, SI queremos expandir $TITULO/$NIVEL_NUM ahora
# mismo, asi que ese heredoc va sin comillas a proposito.

cat > "$DIR/README.md" << EOF
# Ejercicio $NUM_PADDED — $TITULO

- **Nivel:** $NIVEL_NUM/5
- **Tema:** PostgreSQL
- **Tiempo estimado:**

## Enunciado

## Requisitos

- [ ] init.sql crea el esquema necesario
- [ ] Los tests pasan: \`bash test.sh\`

## Solución

<details>
<summary>Mostrar solución</summary>

\`\`\`sql
-- Código de la solución
\`\`\`

</details>
EOF

cat > "$DIR/init.sql" << 'EOF'
-- TODO: esquema de partida para este ejercicio
EOF

cat > "$DIR/solucion.sql" << 'EOF'
-- TODO: escribir la solucion
EOF

cat > "$DIR/checks.sql" << 'EOF'
-- TODO: comprobaciones automaticas (ver otros ejercicios como referencia)
SELECT 1;
EOF

cat > "$DIR/expected.txt" << 'EOF'
Este proyecto valida con checks.sql, no con un diff exacto de output
(SERIAL/CURRENT_TIMESTAMP/RANDOM() no son deterministas).
EOF

cat > "$DIR/test.sh" << 'EOF'
#!/bin/bash
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="test_exercise_db"

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" postgres

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f init.sql
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f solucion.sql
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f checks.sql

echo "✅ Tests pasaron"
EOF

chmod +x "$DIR/test.sh"

echo "✅ Ejercicio creado en: $DIR"
