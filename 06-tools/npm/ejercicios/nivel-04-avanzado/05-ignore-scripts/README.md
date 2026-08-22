# 05 — ignore-scripts

## Enunciado

Desactiva los scripts de instalación por seguridad.

## Requisitos

1. Crea `solucion/.npmrc`.
2. Añade `ignore-scripts=true`.
3. Explica en `respuesta.txt` por qué esto mejora la seguridad.

## Pistas

- Los `postinstall` de dependencias pueden ejecutar código arbitrario.

## Solución

<details>
<summary>Mostrar solución</summary>

```ini
# .npmrc
ignore-scripts=true
```

`respuesta.txt`:
```
ignore-scripts=true evita que las dependencias ejecuten scripts postinstall, reduciendo el riesgo de supply chain attacks.
```

</details>
