# 06 — tmux + SSH

## Enunciado

Combina tmux y SSH para trabajo remoto persistente.

## Requisitos

1. Explica en `respuesta.txt` el flujo para trabajar en un servidor remoto de forma persistente con tmux.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
1. ssh mi-servidor
2. tmux a -t trabajo 2>/dev/null || tmux new -s trabajo
3. Trabajar (ejecutar procesos largos)
4. Detach: Ctrl+B D (los procesos siguen corriendo)
5. Más tarde: ssh mi-servidor && tmux a -t trabajo
```

</details>
