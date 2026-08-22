# 06 — Plantilla de prompt

## Enunciado

Crea una plantilla de prompt reutilizable.

## Requisitos

1. Crea `solucion/plantilla-prompt.md` con una plantilla para añadir tests a un archivo.

## Solución

<details>
<summary>Mostrar solución</summary>

```markdown
# Plantilla: Añadir tests

Añade tests para el archivo `${ARCHIVO}`:
- Usa el framework de testing del proyecto (revisa package.json).
- Cubre casos normales y casos borde (vacío, null, errores).
- Sigue el patrón AAA (Arrange-Act-Assert).
- Usa nombres descriptivos: should <comportamiento> when <condición>.
```

</details>
