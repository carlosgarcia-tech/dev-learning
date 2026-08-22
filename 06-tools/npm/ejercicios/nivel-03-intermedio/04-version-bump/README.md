# 04 — Version bump

## Enunciado

Usa `npm version` para subir la versión del paquete.

## Requisitos

1. En `solucion/package.json`, la versión inicial es `1.0.0`.
2. Ejecuta `npm version patch` y verifica que la versión pasa a `1.0.1`.
3. Explica en `respuesta.txt` la diferencia entre patch, minor y major.

## Pistas

- `npm version patch` sube el tercer número.
- `npm version minor` sube el segundo y resetea el tercero.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm version patch
# 1.0.0 -> 1.0.1
```

`respuesta.txt`:
```
patch: 1.0.0 -> 1.0.1 (bugfix)
minor: 1.0.0 -> 1.1.0 (nueva feature compatible)
major: 1.0.0 -> 2.0.0 (cambio incompatible)
```

</details>
