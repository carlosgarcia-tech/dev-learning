# 02 — npm audit fix

## Enunciado

Repara vulnerabilidades automáticamente.

## Requisitos

1. En `solucion/`, ejecuta `npm audit fix`.
2. Explica en `respuesta.txt` qué hace `--force` y por qué es peligroso.

## Pistas

- `--force` puede subir a versiones major y romper la API.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm audit fix
```

`respuesta.txt`:
```
npm audit fix intenta actualizar las dependencias vulnerables a versiones seguras.
--force puede subir a versiones major, rompiendo la API. Es peligroso.
```

</details>
