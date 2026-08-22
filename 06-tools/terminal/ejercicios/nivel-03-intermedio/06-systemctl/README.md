# 06 — systemctl

## Enunciado

Gestiona servicios con systemd.

## Requisitos

1. Explica en `respuesta.txt` cómo ver el estado de un servicio con `systemctl`.
2. Menciona cómo reiniciarlo.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Ver estado: systemctl status nginx
Reiniciar: systemctl restart nginx
Ver logs: journalctl -u nginx -f
```

</details>
