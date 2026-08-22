# 03 — Claves SSH

## Enunciado

Genera y configura claves SSH.

## Requisitos

1. Explica en `respuesta.txt` cómo generar un par de claves ed25519.
2. Cómo copiar la clave pública a un servidor.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Generar: ssh-keygen -t ed25519 -C "tu@email.com"
Copiar al servidor: ssh-copy-id usuario@servidor
```

</details>
