# Ejercicio 04 — Release automático con tags
- **Nivel:** 4/5
- **Tema:** Releases automáticas disparadas por tags `v*`
- **Tiempo estimado:** 40 min

## Enunciado

Quieres que, cada vez que creas un tag `v*` (por ejemplo `v1.2.3`), GitHub Actions genere automáticamente una **Release** en GitHub con las notas de versión.

Diseña un workflow en `.github/workflows/release.yml` que:

1. Se dispare **solo** al subir tags que empiecen por `v` (`on.push.tags: ['v*']`).
2. Tenga un job `release` que cree la Release usando `softprops/action-gh-release` (o una action equivalente de release).
3. Genere el nombre y el cuerpo de la release a partir del tag (`{{ github.ref_name }}`).

## Requisitos
- [ ] El trigger usa `on.push.tags` (o `on.push` con `tags`).
- [ ] El workflow referencia `action-gh-release` (o una action de release equivalente).
- [ ] El job de release depende del tag (no se lanza en pushes de rama).
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- El trigger para tags:
  ```yaml
  on:
    push:
      tags:
        - "v*"
  ```
  Con esto el workflow **no** se lanza en pushes de rama, solo al crear un tag `v*`.
- `softprops/action-gh-release` crea o actualiza la release. Usa `tag_name: ${{ github.ref_name }}` y `generate_release_notes: true` para notas automáticas.
- Necesitas el permiso `permissions: contents: write` para que la action pueda crear la release.
- `github.ref_name` contiene el nombre corto del tag (`v1.2.3`), mientras que `github.ref` incluye el prefijo (`refs/tags/v1.2.3`).

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
name: Release automática
on:
  push:
    tags:
      - "v*"

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Crear release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ github.ref_name }}
          name: Release ${{ github.ref_name }}
          generate_release_notes: true
```

</details>
