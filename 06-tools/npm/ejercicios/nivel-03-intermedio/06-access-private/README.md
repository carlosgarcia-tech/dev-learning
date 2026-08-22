# 06 — Access private

## Enunciado

Configura un paquete para publicación privada.

## Requisitos

1. En `solucion/package.json`, añade `publishConfig` con `access: "restricted"`.

## Pistas

- `restricted` hace que el paquete sea privado (requiere cuenta Pro/Org).

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "publishConfig": { "access": "restricted" }
}
```

</details>
