# Ejercicio 01 — Init y primer commit

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 15 minutos

## Enunciado

1. Inicializa un repositorio Git en el directorio que te proporciona `setup.sh` (ya contiene un `README.md` sin versionar).
2. Añade el `README.md` al staging area.
3. Crea tu primer commit con el mensaje `Commit inicial`.

## Requisitos

- [ ] El repositorio está inicializado (existe `.git/`)
- [ ] `README.md` está commiteado
- [ ] Hay exactamente 1 commit en el historial
- [ ] El mensaje del commit es `Commit inicial`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git init` crea el repositorio dentro del directorio actual.
- Recuerda que el script de solución recibe la ruta del repo como `$1`.
- Necesitas `git add` antes de `git commit`.
- El mensaje del commit va con `-m "Commit inicial"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git init -q
git add README.md
git commit -q -m "Commit inicial"
```

</details>
