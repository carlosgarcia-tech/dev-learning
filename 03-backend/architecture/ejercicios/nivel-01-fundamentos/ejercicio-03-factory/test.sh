#!/usr/bin/env bash
# Validación del ejercicio 03 - Factory Method.
# Comprueba estructura, sintaxis Python y comportamiento del factory.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.py"
STRUCT="estructura.json"
DIAG="diagrama.txt"

# 1. Archivos esperados existen
for f in "$SOL" "$STRUCT" "$DIAG"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

# 2. python3 disponible
if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# 3. estructura.json es JSON válido
if ! python3 -m json.tool "$STRUCT" >/dev/null 2>&1; then
  echo "FAIL: $STRUCT no es JSON válido"
  fail
fi

# 4. solucion.py compila
if ! python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null; then
  echo "FAIL: $SOL no compila con python3"
  fail
fi

# 5. Define las clases requeridas
for cls in "Notificacion" "EmailNotificacion" "SMSNotificacion" "PushNotificacion" "NotificacionFactory"; do
  if ! grep -q "class $cls" "$SOL"; then
    echo "FAIL: $SOL debe definir la clase $cls"
    fail
  fi
done

# 6. Notificacion es abstracta
if ! grep -qE "abstractmethod" "$SOL"; then
  echo "FAIL: Notificacion debe ser abstracta (usar @abstractmethod)"
  fail
fi
if ! grep -qE "def enviar" "$SOL"; then
  echo "FAIL: Notificacion debe tener método enviar"
  fail
fi

# 7. Factory tiene método crear
if ! grep -qE "def crear" "$SOL"; then
  echo "FAIL: NotificacionFactory debe tener método crear"
  fail
fi

# 8. Verificación funcional: tipos correctos y error
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

# email
n = m.NotificacionFactory.crear("email")
if n.enviar("Hola") != "[Email] Hola":
    print("FAIL: email.enviar debe devolver '[Email] Hola'"); sys.exit(1)
# sms
n = m.NotificacionFactory.crear("sms")
if n.enviar("Hola") != "[SMS] Hola":
    print("FAIL: sms.enviar debe devolver '[SMS] Hola'"); sys.exit(1)
# push
n = m.NotificacionFactory.crear("push")
if n.enviar("Hola") != "[Push] Hola":
    print("FAIL: push.enviar debe devolver '[Push] Hola'"); sys.exit(1)
# error
try:
    m.NotificacionFactory.crear("fax")
    print("FAIL: crear con tipo desconocido debe lanzar ValueError"); sys.exit(1)
except ValueError:
    pass  # correcto
PY

echo "OK Tests pasaron"
