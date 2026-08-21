# Ejercicio 03 — Hooks pre-commit

- **Nivel:** 4/5
- **Tema:** Hooks
- **Tiempo estimado:** 30 minutos

## Enunciado

1. El repo está en `main` con 1 commit (`README.md`).
2. Crea un hook `pre-commit` (dentro de `.githooks/`) que **bloquee** cualquier commit si el archivo `secrets.env` está staged. El hook debe imprimir "detectado secrets.env" y salir con código 1.
3. Configura `core.hooksPath` a `.githooks`.
4. Haz el hook ejecutable.
5. Luego intenta commitear `secrets.env`: el commit debe **fallar** (bloqueado por el hook).
6. Finalmente, elimina `secrets.env` del staging y crea un commit normal con `feat: commit permitido` (que sí debe pasar).

## Requisitos

- [ ] Existe `.githooks/pre-commit` y es ejecutable
- [ ] `core.hooksPath` está configurado a `.githooks`
- [ ] El hook bloquea commitear `secrets.env`
- [ ] Existe un commit con mensaje `feat: commit permitido`
- [ ] `secrets.env` NO está commiteado
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El hook puede comprobar el staging con `git diff --cached --name-only | grep -q secrets.env`.
- `git config core.hooksPath .githooks`.
- `chmod +x .githooks/pre-commit`.
- Para que el hook se versione, añádelo al repo con un commit.
- El intento de commitear `secrets.env` debe fallar; captúralo con `|| true`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
mkdir -p .githooks
cat > .githooks/pre-commit <<'EOF'
#!/bin/bash
if git diff --cached --name-only | grep -q "secrets.env"; then
    echo "detectado secrets.env"
    exit 1
fi
exit 0
EOF
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks

# Commit del hook
git add .githooks
git commit -q -m "chore: añade hook pre-commit"

# Intentar commitear secrets.env (debe fallar)
echo "SECRET=123" > secrets.env
git add secrets.env
git commit -m "feat: sube secrets" 2>/dev/null || true   # falla esperado

# Quitar del staging y commitear algo permitido
git restore --staged secrets.env
echo "hola" > app.txt
git add app.txt
git commit -q -m "feat: commit permitido"
```

</details>
