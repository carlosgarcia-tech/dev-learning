# Ejercicio 04 — Bisect automatizado

- **Nivel:** 5/5
- **Tema:** Bisect automatizado
- **Tiempo estimado:** 35 minutos

## Enunciado

1. El repo tiene 8 commits en `main`. En uno de ellos se introdujo una línea `BUG` en `app.txt`.
2. Automatiza `git bisect` con `git bisect run` y un script de comprobación para encontrar el commit culpable.
3. Guarda el hash del commit culpable en el archivo `.bisect-result`.
4. El test comprobará que el commit identificado es el correcto y que el anterior no tenía el bug.

## Requisitos

- [ ] Se usó `git bisect run` con un script de comprobación
- [ ] `.bisect-result` contiene el hash del commit culpable
- [ ] El commit identificado es el primero en el que `app.txt` contiene `BUG`
- [ ] El commit padre del culpable NO contiene `BUG`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Crea un script `check.sh` que devuelva `0` si `BUG` NO está en `app.txt` (commit bueno) y `1` si está (commit malo):
  ```bash
  #!/bin/bash
  if grep -q "^BUG$" app.txt; then exit 1; else exit 0; fi
  ```
- `git bisect start`, `git bisect bad HEAD`, `git bisect good <commit-bueno>` (un commit anterior lejano).
- `git bisect run ./check.sh` ejecuta la búsqueda binaria.
- Tras el run, HEAD apunta al culpable. Guárdalo con `git rev-parse HEAD > .bisect-result` antes de `git bisect reset`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"

cat > check.sh <<'EOF'
#!/bin/bash
if grep -q "^BUG$" app.txt; then exit 1; else exit 0; fi
EOF
chmod +x check.sh

git bisect start >/dev/null
git bisect bad HEAD >/dev/null
git bisect good HEAD~7 >/dev/null
git bisect run ./check.sh >/dev/null 2>&1 || true

echo "$(git rev-parse HEAD)" > .bisect-result

git bisect reset >/dev/null
```

</details>
