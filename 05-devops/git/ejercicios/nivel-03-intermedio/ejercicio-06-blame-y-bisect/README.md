# Ejercicio 06 — Blame y bisect

- **Nivel:** 3/5
- **Tema:** Depuración de historial
- **Tiempo estimado:** 30 minutos

## Enunciado

1. El repo tiene una serie de commits que van añadiendo líneas a `bug.txt`. En uno de ellos se introdujo la línea `BUG`.
2. Usando `git bisect`, encuentra el commit culpable (el que introdujo `BUG` en `bug.txt`).
3. El test comprobará que el commit identificado es el correcto.

Como no podemos automatizar bisect interactivo, el ejercicio pide usar **bisect en modo automático** con un script que comprueba si `BUG` está presente en `bug.txt`:

```bash
git bisect start
git bisect bad HEAD          # el commit actual tiene el bug
git bisect good HEAD~5       # 5 commits atrás no estaba
git bisect run <comando que devuelve 0 si BUG NO está>
git bisect reset
```

Para que el test pueda verificar, guarda el hash del commit culpable en el archivo `.bisect-result` dentro del repo.

## Requisitos

- [ ] Se usó `git bisect` para encontrar el commit
- [ ] El archivo `.bisect-result` contiene el hash del commit culpable
- [ ] El commit identificado es el que introdujo `BUG` en `bug.txt`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Crea un script `check.sh` que devuelva 0 si `BUG` NO está en `bug.txt` (commit bueno) y 1 si está (commit malo):
  ```bash
  if grep -q "^BUG$" bug.txt; then exit 1; else exit 0; fi
  ```
- `git bisect run ./check.sh` ejecutará la búsqueda binaria.
- Tras terminar, `git bisect log` o `git rev-parse HEAD` no sirve porque reset vuelve atrás.
- Para capturar el culpable: la salida de `git bisect run` termina con `first bad commit: <hash>`. Puedes parsearla o, antes del reset, guardar `git rev-parse HEAD` si está en el culpable. Más fiable: tras el run (sin reset), si HEAD es el culpable, `echo $(git rev-parse HEAD) > .bisect-result`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"

# Script de comprobación: 0 = bueno (sin BUG), 1 = malo (con BUG)
cat > check.sh <<'EOF'
#!/bin/bash
if grep -q "^BUG$" bug.txt; then exit 1; else exit 0; fi
EOF
chmod +x check.sh

git bisect start >/dev/null
git bisect bad HEAD >/dev/null
git bisect good HEAD~5 >/dev/null
git bisect run ./check.sh >/dev/null 2>&1 || true

# En este punto HEAD está en el commit culpable (bisect deja ahí antes de reset)
echo "$(git rev-parse HEAD)" > .bisect-result

git bisect reset >/dev/null
```

</details>
