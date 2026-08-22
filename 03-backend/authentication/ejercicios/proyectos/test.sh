#!/usr/bin/env bash
# Validación del Proyecto Final - Sistema completo de autenticación.
# Verifica los 8 módulos en modulos/ con comprobaciones reales.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# Verificar que config.json existe
if [[ ! -f "config.json" ]]; then
  echo "FAIL: falta config.json"
  fail
fi

# Verificar que los 8 módulos existen
MODULOS=(
  "01-registro.json"
  "02-login-jwt.json"
  "03-refresh-rotation.json"
  "04-mfa-totp.json"
  "05-oauth-google.json"
  "06-rate-limiting.json"
  "07-password-reset.json"
  "08-roles-permisos.json"
)

for mod in "${MODULOS[@]}"; do
  if [[ ! -f "modulos/$mod" ]]; then
    echo "FAIL: falta modulos/$mod"
    fail
  fi
done

echo "Validando 8 módulos..."

python3 - <<'PYEOF'
import base64, json, hmac, hashlib, struct, sys, os

SECRET = b"filtropro-secret-key-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

def totp_code(secret_b32, timestamp):
    counter = timestamp // 30
    key = base64.b32decode(secret_b32)
    msg = struct.pack(">Q", counter)
    digest = hmac.new(key, msg, hashlib.sha1).digest()
    offset = digest[-1] & 0x0F
    code = struct.unpack(">I", digest[offset:offset+4])[0] & 0x7FFFFFFF
    return str(code % 1000000).zfill(6)

errors = []

# === Módulo 1: Registro ===
with open("modulos/01-registro.json") as f:
    m1 = json.load(f)
re = m1.get("registro_exitoso", {})
if re.get("status") != "success":
    errors.append("M1: registro_exitoso.status debe ser 'success'")
if re.get("email_valido") is not True:
    errors.append("M1: email_valido debe ser true")
if re.get("password_valida") is not True:
    errors.append("M1: password_valida debe ser true")
if not re.get("password_hash", "").startswith("$2b$"):
    errors.append("M1: password_hash debe tener formato bcrypt")
if re.get("password", "Secr3tP@ss") in re.get("password_hash", ""):
    errors.append("M1: password_hash NO debe contener la password original")
rd = m1.get("registro_duplicado", {})
if rd.get("status") != "error":
    errors.append("M1: registro_duplicado.status debe ser 'error'")
if rd.get("error_code") != 409:
    errors.append("M1: registro_duplicado.error_code debe ser 409")

# === Módulo 2: Login JWT ===
with open("modulos/02-login-jwt.json") as f:
    m2 = json.load(f)
lc = m2.get("login_correcto", {})
if lc.get("status") != "success":
    errors.append("M2: login_correcto.status debe ser 'success'")
if lc.get("access_token_ttl") != 900:
    errors.append("M2: access_token_ttl debe ser 900")
if lc.get("refresh_token_ttl") != 604800:
    errors.append("M2: refresh_token_ttl debe ser 604800")
li = m2.get("login_incorrecto", {})
if li.get("authenticated") is not False:
    errors.append("M2: login_incorrecto.authenticated debe ser false")
ca = m2.get("claims_access_token", {})
if ca.get("type") != "access":
    errors.append("M2: claims_access_token.type debe ser 'access'")
if ca.get("exp") - ca.get("iat") != 900:
    errors.append("M2: access token exp-iat debe ser 900")
cr = m2.get("claims_refresh_token", {})
if cr.get("type") != "refresh":
    errors.append("M2: claims_refresh_token.type debe ser 'refresh'")
if cr.get("exp") - cr.get("iat") != 604800:
    errors.append("M2: refresh token exp-iat debe ser 604800")

# === Módulo 3: Refresh rotation ===
with open("modulos/03-refresh-rotation.json") as f:
    m3 = json.load(f)
rots = m3.get("rotaciones", [])
if len(rots) != 3:
    errors.append(f"M3: debe haber 3 rotaciones, hay {len(rots)}")
else:
    if "refresh_1" not in rots[0].get("refresh_token_emitido", ""):
        errors.append("M3: rotación 1 debe emitir refresh_1")
    if rots[1].get("refresh_1_estado") != "invalidado":
        errors.append("M3: rotación 2: refresh_1 debe estar invalidado")
    if rots[2].get("refresh_2_estado") != "invalidado":
        errors.append("M3: rotación 3: refresh_2 debe estar invalidado")
reuso = m3.get("reuso_detectado", {})
if reuso.get("detectado") is not True:
    errors.append("M3: reuso_detectado.detectado debe ser true")
if reuso.get("familia_invalidada") is not True:
    errors.append("M3: reuso_detectado.familia_invalidada debe ser true")

# === Módulo 4: MFA TOTP ===
with open("modulos/04-mfa-totp.json") as f:
    m4 = json.load(f)
secret = m4.get("secret", "")
ts = m4.get("timestamp_verificacion")
if secret != "JBSWY3DPEHPK3PXP":
    errors.append("M4: secret debe ser 'JBSWY3DPEHPK3PXP'")
expected_code = totp_code(secret, ts)
if m4.get("codigo_generado") != expected_code:
    errors.append(f"M4: codigo_generado incorrecto, debe ser {expected_code}")
ver = m4.get("verificacion", {})
if ver.get("coincide") is not True:
    errors.append("M4: verificacion.coincide debe ser true")
uri = m4.get("otpauth_uri", "")
if not uri.startswith("otpauth://totp/"):
    errors.append("M4: otpauth_uri debe empezar por 'otpauth://totp/'")
if secret not in uri:
    errors.append("M4: otpauth_uri debe contener el secret")

# === Módulo 5: OAuth Google ===
with open("modulos/05-oauth-google.json") as f:
    m5 = json.load(f)
prov = m5.get("proveedor", {})
if not prov.get("authorization_endpoint"):
    errors.append("M5: proveedor.authorization_endpoint no puede estar vacío")
cli = m5.get("cliente", {})
if not cli.get("client_id"):
    errors.append("M5: cliente.client_id no puede estar vacío")
pkce = m5.get("pkce", {})
if pkce.get("code_challenge_method") != "S256":
    errors.append("M5: pkce.code_challenge_method debe ser 'S256'")
verifier = pkce.get("code_verifier", "")
if len(verifier) < 43:
    errors.append("M5: code_verifier debe tener mínimo 43 caracteres")
# Verificar code_challenge = base64url(SHA256(code_verifier))
if verifier:
    expected_challenge = b64url_encode(hashlib.sha256(verifier.encode()).digest())
    if pkce.get("code_challenge") != expected_challenge:
        errors.append("M5: code_challenge no coincide con SHA256(code_verifier)")
flujo = m5.get("flujo", {})
if "response_type=code" not in flujo.get("paso_1_authorization_request", ""):
    errors.append("M5: paso 1 debe contener 'response_type=code'")

# === Módulo 6: Rate limiting ===
with open("modulos/06-rate-limiting.json") as f:
    m6 = json.load(f)
if m6.get("max_intentos_ip") != 5:
    errors.append("M6: max_intentos_ip debe ser 5")
intentos = m6.get("intentos", [])
if len(intentos) != 8:
    errors.append(f"M6: debe haber 8 intentos, hay {len(intentos)}")
else:
    for i in range(5):
        if intentos[i].get("permitido") is not True:
            errors.append(f"M6: intento {i+1} debe ser permitido")
    for i in range(5, 8):
        if intentos[i].get("permitido") is not False:
            errors.append(f"M6: intento {i+1} debe ser bloqueado")
        exp_backoff = 2 ** (i + 1 - 5)
        if intentos[i].get("backoff_segundos") != exp_backoff:
            errors.append(f"M6: intento {i+1} backoff debe ser {exp_backoff}")

# === Módulo 7: Password reset ===
with open("modulos/07-password-reset.json") as f:
    m7 = json.load(f)
p2 = m7.get("paso_2_generacion_token", {})
if p2.get("ttl_segundos") != 900:
    errors.append("M7: TTL debe ser 900")
if p2.get("usado") is not False:
    errors.append("M7: token inicialmente no usado")
p4 = m7.get("paso_4_canje_exitoso", {})
if p4.get("status") != "success":
    errors.append("M7: canje debe ser success")
if p4.get("token_invalidado") is not True:
    errors.append("M7: token debe invalidarse tras uso")
p5 = m7.get("paso_5_reuso_denegado", {})
if p5.get("status") != "error":
    errors.append("M7: reuso debe ser error")

# === Módulo 8: Roles y permisos ===
with open("modulos/08-roles-permisos.json") as f:
    m8 = json.load(f)
roles = m8.get("roles", {})
if "user" not in roles or "admin" not in roles:
    errors.append("M8: roles debe tener 'user' y 'admin'")
user_perms = roles.get("user", {}).get("permisos", [])
admin_perms = roles.get("admin", {}).get("permisos", [])
if "users:delete" in user_perms:
    errors.append("M8: user NO debe tener users:delete")
if "users:delete" not in admin_perms:
    errors.append("M8: admin debe tener users:delete")
checks = m8.get("checks_autorizacion", [])
if len(checks) < 3:
    errors.append("M8: debe haber al menos 3 checks")
else:
    # admin → users:delete → true
    if checks[0].get("permitido") is not True:
        errors.append("M8: check 1 (admin, users:delete) debe ser true")
    # user → users:read → false
    if checks[1].get("permitido") is not False:
        errors.append("M8: check 2 (user, users:read) debe ser false")
    # user → photos:write → true
    if checks[2].get("permitido") is not True:
        errors.append("M8: check 3 (user, photos:write) debe ser true")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PYEOF
