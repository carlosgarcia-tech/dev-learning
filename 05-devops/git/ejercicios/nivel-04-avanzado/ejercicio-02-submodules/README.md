# Ejercicio 02 — Submodules

- **Nivel:** 4/5
- **Tema:** Submodules
- **Tiempo estimado:** 35 minutos

## Enunciado

1. `setup.sh` crea dos repositorios: `main-repo` (el proyecto principal) y `lib-repo` (una librería). Imprime la ruta de `main-repo`.
2. Dentro de `main-repo`, añade `lib-repo` como submodule en la ruta `vendor/lib`.
3. Commitea el submodule con el mensaje `chore: añade lib como submodule`.

## Requisitos

- [ ] Existe el directorio `vendor/lib` que es un submodule
- [ ] El archivo `.gitmodules` existe y referencia `lib-repo` en la ruta `vendor/lib`
- [ ] `.gitmodules` y el submodule están commiteados con el mensaje `chore: añade lib como submodule`
- [ ] El archivo `lib.txt` de `lib-repo` es accesible en `vendor/lib/lib.txt`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El setup imprime dos rutas en la primera y segunda línea. Lee ambas.
- `git -C <main> submodule add <ruta-lib> vendor/lib`.
- Recuerda que `submodule add` ya crea el `.gitmodules` y hace el `add` del submodule; solo falta commitear.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
MAIN="$1"
LIB="$2"
cd "$MAIN"
git submodule add -q "$LIB" vendor/lib
git commit -q -m "chore: añade lib como submodule"
```

</details>
