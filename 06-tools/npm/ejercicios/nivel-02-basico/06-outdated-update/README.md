# 06 — npm outdated y update

## Enunciado

Gestiona actualizaciones de dependencias.

## Requisitos

1. Instala `lodash@4.17.0` (una versión vieja).
2. Ejecuta `npm outdated` y guarda su salida en `outdated.txt`.
3. Ejecuta `npm update lodash` para actualizar dentro del rango.
4. Verifica que la versión instalada es mayor que la 4.17.0.

## Pistas

- `npm outdated` muestra versiones actuales, queridas y últimas.
- `npm update` respeta el rango semver.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm install lodash@4.17.0
npm outdated > outdated.txt
npm update lodash
node -p "require('lodash').VERSION"
```

</details>
