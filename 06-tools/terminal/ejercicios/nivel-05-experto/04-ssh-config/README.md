# 04 — ssh config

## Enunciado

Crea un archivo de configuración SSH.

## Requisitos

1. Crea `solucion/ssh-config` con un Host `mi-servidor` que defina HostName, User y Port.

## Solución

<details>
<summary>Mostrar solución</summary>

```
Host mi-servidor
  HostName 192.168.1.50
  User ada
  Port 2222
  IdentityFile ~/.ssh/id_ed25519
```

</details>
