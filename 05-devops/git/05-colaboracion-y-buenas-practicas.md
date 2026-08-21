# 05 — Colaboración y buenas prácticas

## Objetivos

- [ ] Trabajar con Pull Requests y code review de forma efectiva
- [ ] Decidir cuándo rebasear antes de merge y cuándo squash merge
- [ ] Hacer merge con revisión y resolver conflictos grandes
- [ ] Usar Git en equipos grandes y monorepos
- [ ] Proteger ramas y aplicar políticas
- [ ] Gestionar releases y changelogs automáticos
- [ ] Integrar CI con Git
- [ ] Conectar con GitHub y GitLab
- [ ] Diagnosticar y reparar objetos corruptos con `gc`, `prune`, `fsck`
- [ ] Firmar commits con GPG
- [ ] Proteger credenciales y secretos

## Apuntes

### Pull Requests (PR) y Merge Requests (MR)

Un Pull Request (en GitHub) o Merge Request (en GitLab) es una petición para integrar una rama en otra. Es el punto de revisión, CI y discusión.

```bash
# Flujo típico
git switch -c feature/login
# ... commits ...
git push -u origin feature/login
# Luego en GitHub: abre PR de feature/login → main
```

Estructura de un buen PR:

- **Título** claro (Conventional Commit si aplica: `feat(auth): añade login`).
- **Descripción**: qué cambia, por qué, cómo probarlo, capturas, issues cerrados.
- **Checklist**: tests pasan, docs actualizadas, lint OK.
- **Revisores** asignados y etiquetas.

### Code review

Buenas prácticas para el revisor:

- Revisar **código, no personas**; sé constructivo.
- Usar Conventional Comments (`nitpick:`, `suggestion:`, `issue:`).
- Distinguir bloqueante (`issue:`) de opcional (`nitpick:`).
- Probar localmente si el cambio es arriesgado.
- Aprobar solo cuando el código cumple los criterios.

Buenas prácticas para el autor:

- PRs pequeños y enfocados (<400 líneas cuando sea posible).
- Autorevisión antes de pedir review.
- Responder a comentarios con cambios o argumentos, no ignorar.
- Mantener el PR actualizado con `main` (rebase o merge).

### Rebase antes de merge

Antes de fusionar, actualiza la rama feature contra `main` para que el merge sea limpio y lineal. También confirma que tu feature sigue funcionando sobre el código más reciente.

```bash
git switch feature/login
git fetch origin
git rebase origin/main              # o: git rebase main
# resolver conflictos si los hay
git rebase --continue
git push --force-with-lease          # la rama reescrita debe forzarse (es tu rama)
```

### Tipos de merge en GitHub/GitLab

| Estrategia | Qué hace | Cuándo usar |
|---|---|---|
| **Merge commit** (`--no-ff`) | Crea commit de merge con dos padres | Preservar el contexto de la rama feature |
| **Squash merge** | Combina todos los commits de la rama en uno solo | Limpiar historia: un commit por PR |
| **Rebase merge** | Vuelve a aplicar los commits sobre main sin commit de merge | Historia lineal manteniendo commits |
| **Fast-forward** | Solo avanza el puntero | Cuando main no avanzó desde crear la rama |

Squash merge por comandos:

```bash
git switch main
git merge --squash feature/login
git commit -m "feat(auth): añade login (#142)"
```

### Resolver conflictos grandes

Cuando un merge tiene muchos conflictos, la estrategia importa:

1. **Rebasa frecuentemente**: integra `main` en tu rama a menudo para que los conflictos sean pequeños.
2. **Divide y vencerás**: si el PR toca mucho, divídelo en varios PRs más pequeños.
3. **`git checkout --ours/--theirs`** para aceptar toda una versión de un archivo completo.
4. **`rerere`** (reuse recorded resolution): Git recuerda cómo resolviste un conflicto y lo reaplica si se repite.

```bash
git config --global rerere.enabled true
# la primera vez resuelves a mano; la siguiente, Git autoresuelve
```

5. **Herramientas visuales**: `git mergetool`, VS Code (editor de merge a 3 bandas), meld, kdiff3.

```bash
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'
```

### Git en equipos grandes y monorepos

Un **monorepo** contiene múltiples proyectos/apps en un mismo repositorio. Ventajas: visibilidad, refactor atómicos cross-project, tooling unificado. Retos: tamaño, CI, permisos.

Técnicas para escalar:

- **sparse-checkout**: cada equipo trabaja solo con su parte.
- **Path-based CI**: ejecutar solo los tests del path afectado (con `paths:` en GitHub Actions o cambios detectados).
- **CODEOWNERS**: exigir revisión de los responsables de cada path.

```
# .github/CODEOWNERS
/apps/web/        @equipo-frontend
/apps/api/        @equipo-backend
/infra/           @sre
```

- **Protected branches**: reglas de merge por rama.
- **Refs y tags espaciados**: `release/2024-06` para no colisionar.
- **LFS** para binarios grandes.
- **`git log -- <path>`** para auditar cambios por directorio.

### Protección de ramas

Reglas típicas sobre `main`/`develop`:

- Requerir PR antes de pushear directo.
- Requerir N aprobaciones de code review.
- Superar CI (status checks) antes de merge.
- Ramas siempre actualizadas con `main` antes de merge.
- Firmar commits (GPG / signed commits).
- No permitir force-push.
- No permitir borrado.

En GitHub: **Settings → Branches → Branch protection rules**.
En GitLab: **Settings → Repository → Protected branches**.

### Releases y changelog automático

Un **release** es una versión publicada, normalmente marcada con un tag y acompañada de notas de versión (changelog).

```bash
git tag -a v1.2.0 -m "Release 1.2.0"
git push origin v1.2.0
# GitHub: Releases → Draft a new release → tag v1.2.0
```

**Changelog automático** a partir de Conventional Commits:

- Los commits `feat:` → se agrupan en "Features".
- `fix:` → "Bug Fixes".
- `BREAKING CHANGE` → sección destacada.
- `perf:`, `refactor:` → otras secciones.

Herramientas:

- **semantic-release**: versionado + changelog + publicación automática basada en commits.
- **standard-version** / **release-please**: generan `CHANGELOG.md` y suben la versión.
- **GitHub Release** con auto-generated notes.

```bash
npx semantic-release --dry-run    # simula qué versión y changelog generaría
```

Ejemplo de `CHANGELOG.md` generado:

```markdown
## [1.2.0] - 2024-06-30

### Features
- **auth:** añade login con OAuth2 (a1b2c3d)
- **api:** endpoint de exportación CSV (4e5f6a7)

### Bug Fixes
- **ui:** corrige desbordamiento en móvil (9z8y7x6)

### BREAKING CHANGES
- **api:** renombra /users a /account
```

### CI con Git

La integración continua se dispara por eventos de Git: push, PR, tag.

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0          # para herramientas de análisis de historial
      - run: npm ci
      - run: npm test
      - run: npm run lint
```

Trucos Git en CI:

- `fetch-depth: 0` para tener historial completo (necesario para changelog, cobertura de diffs).
- Detectar archivos cambiados para path-based CI:
  ```bash
  git diff --name-only origin/main...HEAD
  ```
- Firmar commits/tags desde CI con bots.

### Integración con GitHub y GitLab

| Acción | GitHub | GitLab |
|---|---|---|
| Abrir PR/MR | Pull Request | Merge Request |
| Proteger rama | Settings → Branches | Settings → Repository → Protected branches |
| CI | GitHub Actions | GitLab CI/CD (.gitlab-ci.yml) |
| Releases | Releases (tags) | Releases (tags) |
| Fork | Fork button | Fork (menos común; se usa más el modelo de branches) |
| Code review | Reviewers + Comments | Reviewers + Discussions |
| Auto-merge | Enable auto-merge | Merge When Pipeline Succeeds |
| Issue tracking | Issues + Projects | Issues + Boards |

GitHub CLI y GitLab CLI automatizan desde terminal:

```bash
gh pr create --fill
gh pr merge --squash --delete-branch
gh release create v1.2.0 --generate-notes

glab mr create
glab mr merge
```

### Troubleshooting de objetos: `gc`, `prune`, `fsck`

Git guarda los objetos en `.git/objects`. Con el tiempo se acumulan sueltos y el repo se vuelve lento.

```bash
# Verificar integridad de los objetos
git fsck --full                  # detecta corruptos, dangling, perdidos
git fsck --unreachable            # objetos no referenciados

# Recolectar basura: empaquetar objetos sueltos y borrar innecesarios
git gc                            # gc estándar (agresivo=False)
git gc --aggressive               # más agresivo (lento)
git gc --prune=now                # borrar objetos inalcanzables ya

# Podar objetos remotos no referenciados
git remote prune origin           # borra refs remotas que ya no existen
git fetch --prune                 # equivalente combinado

# Optimización manual
git repack -a -d --depth=250 --window=250
git prune --expire=now            # borrar objetos sueltos inalcanzables
```

Diagnóstico de repo lento/hinchado:

```bash
git count-objects -v              # tamaño y nº de objetos sueltos
du -sh .git/                     # tamaño del .git
git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail   # objetos más grandes
```

Recuperación de objetos corruptos:

```bash
git fsck --full                   # detecta el objeto corrupto
git cat-file -p <hash> 2>&1       # confirma que está roto
# Recuperar del remoto:
git fetch origin
git cat-file -p <hash>            # si el remoto lo tiene sano
# Último recurso: clonar de nuevo y copiar objetos
```

### Firmar commits con GPG

La firma GPG/SSH prueba que el commit lo creaste tú (no alguien suplantando tu identidad).

```bash
# 1. Crear clave GPG (si no tienes)
gpg --full-generate-key
# Elegir RSA (4096), nombre, email (el mismo que git config)

# 2. Listar claves y obtener el ID
gpg --list-secret-keys --keyid-format=long
# sec   rsa4096/A1B2C3D4E5F6 2024-01-01 [SC]
# copia el ID después de la barra: A1B2C3D4E5F6

# 3. Configurar Git para firmar con esa clave
git config --global user.signingkey A1B2C3D4E5F6
git config --global commit.gpgsign true

# 4. Exportar la clave pública y subirla a GitHub
gpg --armor --export A1B2C3D4E5F6 | pbcopy   # macOS
# GitHub → Settings → SSH and GPG keys → New GPG key

# Firmar commits
git commit -S -m "feat: cambio firmado"
git log --show-signature -1         # verificar firma

# Firmar tags
git tag -s v1.0 -m "Release firmado"
git verify-tag v1.0
```

Alternativa más simple: **firmar commits con SSH** (Git ≥ 2.34 con OpenSSH):

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

### Seguridad de credenciales

- **Nunca commitear secretos** (`.env`, API keys, certificados). Usa `.gitignore` desde el inicio.
- Si un secreto se commitea por error: rota el secreto inmediatamente y límpialo del historial con `git filter-repo` o BFG.
- Usa **Credential Helper** para no meter la contraseña cada vez:
  ```bash
  git config --global credential.helper store     # texto plano (no recomendado)
  git config --global credential.helper osxkeychain # macOS
  git config --global credential.helper manager    # Windows
  git config --global credential.helper cache      # en memoria por 15 min
  ```
- Prefiere **SSH** o **tokens (PAT)** sobre contraseña.
- Configura **2FA** en GitHub/GitLab.
- Revisa permisos del remoto y hooks de terceros antes de clonar.

## Conceptos clave

| Concepto | Definición |
|---|---|
| **Pull Request** | Petición para integrar una rama en otra, con revisión y CI |
| **Squash merge** | Combina los commits de la rama en uno solo |
| **CODEOWNERS** | Responsables obligatorios por path |
| **Branch protection** | Reglas que evitan pushes directos/force-push a ramas clave |
| **Release** | Versión publicada, marcada con tag + changelog |
| **CI** | Integración continua disparada por eventos Git |
| **git gc** | Recolecta basura y empaqueta objetos |
| **git fsck** | Verifica integridad de objetos del repo |
| **git prune** | Borra objetos inalcanzables |
| **GPG signing** | Firma criptográfica de commits/tags |

## Errores comunes

| Error | Causa | Solución |
|---|---|---|
| Secreto commiteado por error | Falta `.gitignore` o descuido | Rotar secreto + `git filter-repo` o BFG para limpiar historial |
| `error: gpg failed to sign the data` | GPG mal configurado o sin passphrase | `gpg --list-secret-keys`, configurar `user.signingkey`, desbloquear agente |
| Repo lento / `.git` enorme | Objetos sueltos acumulados | `git gc --aggressive --prune=now` |
| `fatal: bad object HEAD` | Objeto corrupto o `.git` dañado | `git fsck --full`, recuperar del remoto o re-clonar |
| Force-push a `main` borró commits | Force-push sobre rama protegida | Proteger la rama; recuperar con reflog si es local |
| PR con 1000 conflictos | Feature larga sin integrar `main` | Rebase frecuente + dividir en PRs pequeños |
| CI no corre | Config equivocada o rama no cubierta | Revisar `on.push.branches` / `paths` |
| `! [remote rejected]` al pushear tag | Falta permiso o tag duplicado | Verificar permisos y `git push --force origin <tag>` solo si aplica |
| Changelog vacío | Commits no siguen Conventional Commits | Estandarizar mensajes y configurar la herramienta |
