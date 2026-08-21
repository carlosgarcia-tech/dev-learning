# Proyecto Final — Pipeline completo de CI/CD

- **Nivel:** Integrador (todos los niveles)
- **Tema:** CI + CD, Docker, GitHub Actions, GitLab CI, multi-entorno, health check, rollback
- **Tiempo estimado:** 3-5 horas

## Contexto

Eres DevOps de una startup que tiene una API Node.js. Tu misión es construir **dos pipelines completos** que lleven el código desde el commit hasta producción de forma automática y segura:

1. **Pipeline de CI** — lint, test, build, escaneo de seguridad y publicación de imagen Docker.
2. **Pipeline de CD** — despliegue automático a staging, aprobación manual a producción, health check y rollback automático.

El proyecto incluye implementaciones en **GitHub Actions** y su **equivalente en GitLab CI**.

## Objetivos

- Integrar todos los conceptos de CI/CD en un proyecto real.
- Practicar pipelines completos: desde el commit hasta el despliegue a producción.
- Combinar Docker, K8s, secrets, environments, health checks y rollback.
- Aprender a traducir un pipeline entre GitHub Actions y GitLab CI.

## Estructura

```
pipeline-completo/
├── README.md                          # este archivo
├── app/                               # aplicación Node.js de ejemplo
│   ├── package.json
│   ├── server.js
│   └── test/
│       └── health.test.js
├── Dockerfile                          # imagen de la app
├── .github/
│   └── workflows/
│       ├── ci.yml                      # pipeline de CI (GitHub Actions)
│       └── cd.yml                      # pipeline de CD (GitHub Actions)
├── .gitlab-ci.yml                     # pipeline equivalente en GitLab CI
├── k8s/
│   ├── deployment.yaml                # Deployment de la app
│   └── service.yaml                    # Service de la app
├── scripts/
│   ├── health-check.sh                 # health check tras despliegue
│   └── rollback.sh                     # rollback automático
└── test.sh                             # validador del proyecto
```

## Fases del proyecto

### Fase 1 — Pipeline de CI (GitHub Actions)

Crea `.github/workflows/ci.yml` con:

1. **Trigger**: `push` a `main` y `pull_request`.
2. **Job `lint`**: checkout, setup Node 20, `npm ci`, `npm run lint`.
3. **Job `test`**: checkout, setup Node 20, `npm ci`, `npm test`. Sube el artifact `coverage/`.
4. **Job `build`**: necesita `lint` y `test`, construye la imagen Docker con `docker/build-push-action@v6` (push: false, tag: `app:${{ github.sha }}`).
5. **Job `scan`**: necesita `build`, escanea la imagen con `aquasecurity/trivy-action@master` (severity: `CRITICAL,HIGH`).
6. **Job `publish`**: necesita `scan`, hace login a GHCR con `${{ secrets.GITHUB_TOKEN }}` y publica la imagen como `ghcr.io/<org>/app:${{ github.sha }}`.

### Fase 2 — Pipeline de CD (GitHub Actions)

Crea `.github/workflows/cd.yml` con:

1. **Trigger**: `workflow_run` sobre `ci.yml` (se ejecuta tras CI exitoso) o `workflow_dispatch`.
2. **Job `deploy_staging`**: `environment: staging`, aplica `k8s/`, hace `kubectl rollout status`, ejecuta `scripts/health-check.sh`.
3. **Job `deploy_prod`**: `needs: deploy_staging`, `environment: production` (con required reviewers), aplica `k8s/` con la imagen publicada, hace `rollout status`, ejecuta `health-check.sh`.
4. **Job `rollback`**: `needs: deploy_prod`, `if: failure()`, ejecuta `scripts/rollback.sh`.

### Fase 3 — Equivalente en GitLab CI

Crea `.gitlab-ci.yml` con los mismos stages:

1. **Stage `test`**: jobs `lint` y `test` con `image: node:20-alpine`, cache de `node_modules`.
2. **Stage `build`**: job `docker_build` que construye la imagen.
3. **Stage `scan`**: job `security_scan` con Trivy.
4. **Stage `deploy`**: jobs `deploy_staging` (automático) y `deploy_prod` (`when: manual` + `environment: production`).

## Criterios de aceptación

- [ ] El pipeline de CI ejecuta lint, test, build Docker, scan de seguridad y publish.
- [ ] El pipeline de CD despliega a staging automáticamente.
- [ ] El pipeline de CD requiere aprobación para producción (`environment: production`).
- [ ] Hay health check tras cada despliegue.
- [ ] Hay rollback automático si el health check falla.
- [ ] `.gitlab-ci.yml` replica el mismo flujo con stages y `when: manual` para prod.
- [ ] La app Node.js tiene un endpoint `/health` que devuelve `{"status":"ok"}`.
- [ ] El `Dockerfile` construye la imagen correctamente.
- [ ] Los tests pasan: `bash test.sh`

## Cómo ejecutar

```bash
# Validar el proyecto
bash test.sh

# Probar la app localmente
cd app && npm install && node server.js
# curl http://localhost:3000/health → {"status":"ok"}

# Construir la imagen Docker
docker build -t app:latest .
# docker run -p 3000:3000 app:latest
```

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para CI en GitHub Actions, encadena los jobs con `needs`: lint → test → build → scan → publish.
- Para CD, usa `workflow_run` como trigger o `workflow_dispatch` para ejecutar manualmente.
- `environment: production` con *required reviewers* crea el gate de aprobación.
- En GitLab CI, `when: manual` es el equivalente al approval gate.
- Trivy puede escanear imágenes locales con `trivy image app:latest`.
- El health check debe usar `curl -fsS` para fallar si el HTTP no es 2xx.

</details>
