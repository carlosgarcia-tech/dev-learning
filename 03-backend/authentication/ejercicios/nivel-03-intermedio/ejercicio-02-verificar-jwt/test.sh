#!/usr/bin/env bash
# Validación del ejercicio 02 - Verificar JWT.
# 1. Genera tokens reales con generar_tokens.py
# 2. Verifica cada token independientemente
# 3. Comprueba que verificacion.json coincide con la verificación real
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

VER_FILE="verificacion.json"
GEN_FILE="generar_tokens.py"

for f in "$VER_FILE" "$GEN_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# 1. Generar los tokens de prueba
python3 "$GEN_FILE" >/dev/null || { echo "FAIL: no se pudieron generar los tokens"; fail; }

# 2. Verificar verificacion.json contra los tokens reales
python3 - "$VER_FILE" <<'PY'
import base64, json, hmac, hashlib, sys, time

SECRET = b"super-secreto-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

# Cargar tokens generados
with open("tokens.json", encoding="utf-8") as f:
    tokens_data = json.load(f)

tokens = tokens_data["tokens"]

# Cargar respuesta del estudiante
with open(sys.argv[1], encoding="utf-8") as f:
    student = json.load(f)

errors = []

resultados = student.get("resultados", [])
if len(resultados) != 3:
    errors.append(f"Debe haber 3 resultados, hay {len(resultados)}")
else:
    expected = [
        ("token_1_valido", True, True, False),    # (id, valido, firma_valida, expirado)
        ("token_2_firma_invalida", False, False, False),
        ("token_3_expirado", False, True, True),
    ]

    for i, (tid, exp_valido, exp_firma, exp_expirado) in enumerate(expected):
        r = resultados[i]
        token = tokens[tid]

        # Verificación real
        parts = token.split('.')
        header_b64, payload_b64, sig_b64 = parts
        signing_input = f"{header_b64}.{payload_b64}".encode()
        expected_sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
        expected_sig_b64 = b64url_encode(expected_sig)
        firma_valida = hmac.compare_digest(expected_sig_b64, sig_b64)

        payload = json.loads(b64url_decode(payload_b64))
        expirado = payload.get("exp", 0) < time.time()

        # Comprobar respuesta del estudiante
        if r.get("token_id") != tid:
            errors.append(f"Resultado {i}: token_id debe ser '{tid}', es '{r.get('token_id')}'")
        if r.get("valido") is not exp_valido:
            errors.append(f"Resultado {i} ({tid}): valido debe ser {exp_valido}, es {r.get('valido')}")
        if r.get("firma_valida") is not exp_firma:
            errors.append(f"Resultado {i} ({tid}): firma_valida debe ser {exp_firma}, es {r.get('firma_valida')}")
        if r.get("expirado") is not exp_expirado:
            errors.append(f"Resultado {i} ({tid}): expirado debe ser {exp_expirado}, es {r.get('expirado')}")
        if not r.get("motivo"):
            errors.append(f"Resultado {i} ({tid}): motivo no puede estar vacío")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
