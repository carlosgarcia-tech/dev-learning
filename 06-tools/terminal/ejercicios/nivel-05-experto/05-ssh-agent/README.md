# 05 — ssh-agent

## Enunciado

Configura ssh-agent para no repetir passphrase.

## Requisitos

1. Explica en `respuesta.txt` cómo arrancar ssh-agent y añadir una clave.
2. Menciona qué hace ForwardAgent.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Arrancar: eval "$(ssh-agent -s)"
Añadir clave: ssh-add ~/.ssh/id_ed25519
ForwardAgent yes: permite usar tus claves locales desde una sesión SSH remota (ej: para git en el servidor).
```

</details>
