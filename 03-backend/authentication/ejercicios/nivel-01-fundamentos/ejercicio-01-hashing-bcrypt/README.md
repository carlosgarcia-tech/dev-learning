# Ejercicio 01 — Hashing con bcrypt

- **Nivel:** 1/5
- **Tema:** Hashing de contraseñas con bcrypt
- **Tiempo estimado:** 20 min

## Enunciado

Tu primera tarea de seguridad: entender el formato de un hash bcrypt. Se te da una contraseña y un hash bcrypt real. Debes analizar el hash y completar `hash.json` con cada una de sus partes (algoritmo, versión, coste, salt y hash completo), de modo que `test.sh` valide tu análisis.

Pasos:

1. Examina el hash bcrypt en `hash.json` (campo `password_hash`).
2. Descompón el hash en sus partes: prefijo de algoritmo, versión, cost factor, salt y hash.
3. Completa los campos `algorithm`, `version`, `cost_factor` y `salt`.
4. Ejecuta `bash test.sh`.

El formato de un hash bcrypt es:

```
$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
│  │  │ │                      │
│  │  │ │                      └── Hash (31 chars)
│  │  │ └── Salt (22 chars)
│  │  └── Cost factor (2 dígitos)
│  └── Versión (a, b, y)
└── Prefijo bcrypt
```

## Requisitos

- [ ] `hash.json` es JSON válido
- [ ] `algorithm` es `"bcrypt"`
- [ ] `version` es `"2b"`
- [ ] `cost_factor` es `12`
- [ ] `salt` tiene 22 caracteres
- [ ] `password_hash` coincide con el formato bcrypt completo (`$2b$12$` + salt + hash)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El hash completo es: `$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy`
- Separa por el carácter `$`: el primer elemento está vacío, el segundo es `2b`, el tercero es `12`, y el resto es salt+hash concatenados.
- El salt son los primeros 22 caracteres después del último `$`.
- El hash resultante son los 31 caracteres restantes.
- El cost factor 12 significa 2^12 = 4096 iteraciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`hash.json`:

```json
{
  "algorithm": "bcrypt",
  "version": "2b",
  "cost_factor": 12,
  "salt": "N9qo8uLOickgx2ZMRZoMye",
  "password_hash": "$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy",
  "password_original": "password123"
}
```

Verificar el formato:

```bash
# El hash debe seguir el patrón $2[aby]$NN$<22 chars salt><31 chars hash>
echo '$2b$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' \
  | grep -P '^\$2[aby]\$\d{2}\$[A-Za-z0-9./]{53}$'
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
