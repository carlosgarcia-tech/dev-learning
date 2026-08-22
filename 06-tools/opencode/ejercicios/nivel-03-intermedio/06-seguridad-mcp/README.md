# 06 — Seguridad de MCP

## Enunciado

Evalúa los riesgos de los MCP servers.

## Requisitos

1. Crea `solucion/respuesta.txt` con 2 riesgos de usar MCP servers y cómo mitigarlos.

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.txt`:
```
Riesgo 1: un MCP server puede exponer acceso a datos sensibles (BD, GitHub).
Mitigación: revisar qué permisos tiene cada server y limitar los servers a lo necesario.
Riesgo 2: tokens hardcodeados en la config.
Mitigación: usar variables de entorno ${TOKEN} en lugar de hardcodear.
```

</details>
