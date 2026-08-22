"""
Configuración base del sistema de autenticación de FiltroPro.
Carga la configuración desde config.json y expone constantes.
"""
import json
import os

CONFIG_PATH = os.path.join(os.path.dirname(__file__), "..", "config.json")

with open(CONFIG_PATH, encoding="utf-8") as f:
    CONFIG = json.load(f)

# JWT
JWT_SECRET = CONFIG["jwt_secret"].encode()
JWT_ALGORITHM = CONFIG["jwt_algorithm"]
ACCESS_TOKEN_TTL = CONFIG["access_token_ttl"]
REFRESH_TOKEN_TTL = CONFIG["refresh_token_ttl"]

# TOTP
TOTP_WINDOW = CONFIG["totp_window"]
TOTP_DIGITS = CONFIG["totp_digits"]

# bcrypt
BCRYPT_COST = CONFIG["bcrypt_cost"]

# Rate limiting
RATE_LIMIT_MAX = CONFIG["rate_limit"]["max_attempts_ip"]
RATE_LIMIT_WINDOW = CONFIG["rate_limit"]["window_seconds"]
RATE_LIMIT_BACKOFF_BASE = CONFIG["rate_limit"]["backoff_base"]

# Password reset
PASSWORD_RESET_TTL = CONFIG["password_reset"]["ttl_seconds"]
PASSWORD_RESET_MAX_ATTEMPTS = CONFIG["password_reset"]["max_attempts"]

# OAuth Google
OAUTH_GOOGLE = CONFIG["oauth_google"]

# Cookie
COOKIE_CONFIG = CONFIG["cookie"]
