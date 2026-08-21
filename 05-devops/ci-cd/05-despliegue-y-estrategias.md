# 05 — Despliegue y estrategias

## Objetivos

- [ ] Distinguir las estrategias de despliegue: *rolling*, *blue-green*, *canary* y su relación con el downtime.
- [ ] Implementar *rolling updates* con Docker Compose y Kubernetes.
- [ ] Configurar un *blue-green deployment* y conmutar tráfico sin downtime.
- [ ] Desplegar un *canary* y medir métricas para decidir promover o revertir.
- [ ] Entender *Infrastructure as Code* (IaC) y dónde encaja Terraform en el pipeline.
- [ ] Aplicar *GitOps* con ArgoCD: el repo como fuente de verdad del estado deseado.
- [ ] Automatizar *releases* con tags y *release notes* generadas.
- [ ] Diseñar *rollbacks* automáticos ante fallos de health check.
- [ ] Gestionar despliegues multi-entorno (dev → staging → prod) con gates.
- [ ] Integrar escaneo de imágenes y verificación previa al despliegue.

## Apuntes

### Estrategias de despliegue

La estrategia decide **cómo** se reemplaza la versión vieja por la nueva. Define el downtime, el riesgo y la velocidad.

| Estrategia | Downtime | Retroceso | Riesgo | Complejidad |
|---|---|---|---|---|
| Recreate | sí (parada total) | re-desplegar vieja | alto | baja |
| Rolling | no | gradual | medio | media |
| Blue-Green | no | instantáneo (swap) | bajo | media (2× recursos) |
| Canary | no | reducir tráfico | bajo | alta (métricas) |
| A/B Testing | no | redirigir tráfico | bajo | alta (routing) |
| Shadow | no | nulo (no recibe tráfico real) | muy bajo | muy alta |

#### Recreate

Paras todo y arrancas la nueva versión. Sencillo pero con downtime.

```yaml
# k8s: strategy recreate
spec:
  strategy:
    type: Recreate
```

#### Rolling

Reemplaza los pods viejos por nuevos poco a poco. Sin downtime si hay suficientes réplicas.

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1          # pods extra durante el rollout
      maxUnavailable: 0    # ningún pod abajo (downtime 0)
```

- `maxUnavailable: 0` + `maxSurge: 1` = siempre hay capacidad mientras sube la nueva.
- Apropiado para servicios *stateless*. Con estado requiere cuidado.

### Blue-Green

Dos entornos idénticos: *blue* (actual, recibe tráfico) y *green* (nueva versión, calentando). Cuando green está listo, conmutas el tráfico. El rollback es volver a blue.

```
            ┌─── blue (v1)  ◄── tráfico
router ─────┤
            └─── green (v2) ◄── calentando
                  ↑ al validar, el router apunta aquí
```

Kubernetes con Services y labels:

```yaml
# Service apunta a pods con label version: blue
apiVersion: v1
kind: Service
metadata: { name: app-svc }
spec:
  selector: { app: mi-app, version: blue }   # cambia a green para conmutar
  ports: [...]
```

En el pipeline:

```yaml
# GitHub Actions: blue-green con kubectl
deploy_green:
  runs-on: ubuntu-latest
  environment: production
  steps:
    - uses: actions/checkout@v4
    - run: |
        kubectl apply -f k8s/green-deployment.yaml
        kubectl rollout status deploy/mi-app-green
    - run: kubectl patch svc app-svc -p '{"spec":{"selector":{"version":"green"}}}'
    - run: |
        # health check a la nueva versión
        curl -f http://app.example.com/health || kubectl patch svc app-svc -p '{"spec":{"selector":{"version":"blue"}}}'
```

### Canary

Despliega la nueva versión a un porcentaje pequeño del tráfico (1-10%), mide métricas y sube gradualmente. Si algo falla, retira el canary.

```
       ┌── stable (v1)  ◄── 90% tráfico
LB ────┤
       └── canary (v2)  ◄── 10% tráfico  →  métricas →  promover o revertir
```

Herramientas: Argo Rollouts, Flagger, Istio, NGINX Ingress con ponderación.

```yaml
# Argo Rollouts: Canary
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata: { name: mi-app }
spec:
  replicas: 10
  strategy:
    canary:
      steps:
        - setWeight: 10          # 10% al canary
        - pause: { duration: 2m }
        - setWeight: 30
        - pause: { duration: 2m }
        - setWeight: 100
```

Gate de métricas (Flagger):

```yaml
analysis:
  interval: 1m
  threshold: 5
  metrics:
    - name: error-rate
      threshold: 1             # si supera 1%, revierte
      query: |
        sum(rate(http_requests_total{status=~"5xx"}[1m]))
        / sum(rate(http_requests_total[1m]))
```

### Rolling con Docker

En Docker Swarm:

```yaml
# docker-compose.yml (Swarm)
deploy:
  replicas: 4
  update_config:
    parallelism: 2            # actualiza 2 a la vez
    order: start-first        # arranca nuevas antes de parar viejas
    failure_action: rollback
  rollback_config:
    parallelism: 2
```

`docker service update --image mi-app:v2 app` lanza el rolling; `docker service rollback app` revierte.

### Infrastructure as Code (IaC)

IaC define la infraestructura (redes, BD, clusters) como código versionado. Terraform es la herramienta más usada. Encaja en el pipeline como un stage más.

```yaml
# GitHub Actions: Terraform plan/apply
jobs:
  terraform:
    runs-on: ubuntu-latest
    environment: production
    permissions: { contents: read, id-token: write }   # OIDC
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init
      - run: terraform fmt -check
      - run: terraform validate
      - run: terraform plan -input=false
      - run: terraform apply -auto-approve -input=false
        if: github.ref == 'refs/heads/main'
```

```yaml
# GitLab CI: Terraform
terraform_plan:
  image: hashicorp/terraform:1.7
  script:
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths: [tfplan]
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

terraform_apply:
  needs: [terraform_plan]
  image: hashicorp/terraform:1.7
  environment: production
  script:
    - terraform apply -auto-approve tfplan
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

Principios IaC:

- **Idempotente**: aplicar el mismo código dos veces deja el mismo estado.
- **Declarativo**: describes el estado deseado, no los pasos.
- **Versionado**: cada cambio pasa por PR; el historial es auditoría.
- **State remoto y bloqueo**: el `tfstate` va en un backend remoto (S3, GCS) con lock para evitar carreras.

### GitOps

GitOps pone el **repo como única fuente de verdad** del estado deseado del clúster. Un operador (ArgoCD, Flux) vigila el repo y *sincroniza* el clúster con lo que el repo dice.

```
   developer  ──push──►  repo (manifests)  ◄──watch──  ArgoCD  ──apply──►  Kubernetes
                                              │
                                              └── si drift, re-sincroniza
```

El pipeline de CI publica la imagen; el pipeline de CD **actualiza el manifiesto** en el repo de despliegue; ArgoCD detecta el cambio y aplica.

```yaml
# Pipeline: tras build+push de imagen, actualiza el manifest
update_manifest:
  needs: publish
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
      with:
        repository: org/k8s-manifests         # repo separado de despliegue
        token: ${{ secrets.DEPLOY_TOKEN }}
    - run: |
        sed -i "s|image: .*|image: ghcr.io/org/app:${{ github.sha }}|" deployment.yaml
    - run: |
        git config user.name "ci-bot"
        git commit -am "Update image to ${{ github.sha }}"
        git push
```

ArgoCD Application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: { name: mi-app }
spec:
  source:
    repoURL: https://github.com/org/k8s-manifests
    path: prod
    targetRevision: HEAD
  destination:
    server: https://kubernetes.default.svc
    namespace: prod
  syncPolicy:
    automated: { prune: true, selfHeal: true }
```

### Releases automáticos

Automatiza la creación de releases a partir de tags, con notas generadas.

```yaml
# GitHub Actions: release con tag
name: Release
on:
  push:
    tags: ["v*"]
jobs:
  release:
    runs-on: ubuntu-latest
    permissions: { contents: write }
    steps:
      - uses: actions/checkout@v4
      - id: changelog
        uses: mikepenz/release-changelog-builder-action@v5
      - uses: softprops/action-gh-release@v2
        with:
          body: ${{ steps.changelog.outputs.changelog }}
          files: dist/*.tar.gz
```

Flujo con *semantic versioning* automático (p. ej. con `release-please`):

```yaml
on: [push]
jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: google-github-actions/release-please-action@v4
        with:
          release-type: node
```

Conventional Commits (`feat:`, `fix:`, `BREAKING CHANGE:`) determinan *patch/minor/major*.

### Rollback automático

El rollback revierte el último despliegue si los health checks fallan. Puede ser manual o automático.

#### Kubernetes: rollout undo

```bash
kubectl rollout undo deployment/mi-app
kubectl rollout status deployment/mi-app
```

En el pipeline, tras desplegar, verifica y revierte si procede:

```yaml
deploy:
  runs-on: ubuntu-latest
  steps:
    - run: kubectl set image deploy/mi-app app=app:$SHA
    - run: kubectl rollout status deploy/mi-app --timeout=2m
    - name: Health check
      run: |
        for i in $(seq 1 10); do
          curl -fsS http://app/health && exit 0
          sleep 6
        done
        kubectl rollout undo deploy/mi-app
        exit 1
```

#### ArgoCD: auto-heal y rollback

ArgoCD con `selfHeal: true` revierte cualquier *drift* manual. Para rollback automático ante fallos de health, combina ArgoCD con Argo Rollouts (canary) o Flagger.

### Multi-entorno con gates

```
   push/merge a main
        │
        ▼
   CI (lint+test+build)
        │
        ▼
   deploy staging (automático)
        │ health check OK
        ▼
   gate approval (humano) ──► deploy prod
        │
        ▼
   health check prod → rollback si falla
```

```yaml
# GitHub Actions
jobs:
  ci:
    runs-on: ubuntu-latest
    steps: [...]                # lint, test, build, publish imagen

  deploy_staging:
    needs: ci
    environment: staging
    runs-on: ubuntu-latest
    steps: [kubectl apply -f k8s/staging.yaml]

  approve_prod:
    needs: deploy_staging
    environment: production     # required reviewers configurados
    runs-on: ubuntu-latest
    steps: [kubectl apply -f k8s/prod.yaml]
```

```yaml
# GitLab CI equivalente
stages: [test, deploy_staging, deploy_prod]

deploy_staging:
  stage: deploy_staging
  environment: staging
  script: kubectl apply -f k8s/staging.yaml
  rules: [{ if: $CI_COMMIT_BRANCH == "main" }]

deploy_prod:
  stage: deploy_prod
  environment: production
  script: kubectl apply -f k8s/prod.yaml
  needs: [deploy_staging]
  rules: [{ if: $CI_COMMIT_BRANCH == "main" }]
  when: manual
```

## Tablas de referencia

### Estrategias comparadas

| Estrategia | Downtime | Recursos | Rollback | Cuándo |
|---|---|---|---|---|
| Recreate | sí | 1× | lento | entornos sin SLA |
| Rolling | no | 1× + surge | gradual | stateless, cambio seguro |
| Blue-Green | no | 2× | instantáneo | swap con rollback fácil |
| Canary | no | 1× + small | reducir % | cambios riesgosos con métricas |
| Shadow | no | 2× | nulo | probar en producción sin afectar |

### Herramientas por estrategia

| Estrategia | Docker | Kubernetes | Service Mesh |
|---|---|---|---|
| Rolling | Swarm update_config | Deployment RollingUpdate | — |
| Blue-Green | compose + proxy swap | Service selector / Argo Rollouts | Istio virtualservice |
| Canary | — | Argo Rollouts / Flagger | Istio weighted / Linkerd |
| Shadow | — | Istio mirror | Istio mirror policy |

### Dónde encaja cada cosa en el pipeline

| Fase | Herramienta | Salida |
|---|---|---|
| CI: build | Docker / buildx | imagen |
| CI: scan | Trivy, Grype | reporte de CVEs |
| CI: publish | GHCR, registry GitLab | imagen con tag |
| CD: update manifest | yq, sed, kustomize | commit al repo GitOps |
| CD: sync | ArgoCD / Flux | estado del clúster |
| CD: verify | health check + métricas | go/no-go |
| CD: rollback | kubectl undo / Argo Rollouts | versión anterior |

## Conceptos clave

- **Elige estrategia según riesgo y observabilidad**: rolling es el valor por defecto; canary cuando necesitas validación con tráfico real.
- **Blue-Green = 2× recursos pero rollback instantáneo**: el coste es duplicar el entorno temporalmente.
- **GitOps invierte el flujo**: el pipeline no aplica al clúster, actualiza el repo y un operador sincroniza. Más seguro y auditable.
- **IaC (Terraform) va en el pipeline como stage**: plan en MR, apply en main con aprobación.
- **El rollback automático necesita health checks reales**: si no hay métricas, no hay decisión automática segura.
- **Multi-entorno con gates**: staging automático, prod con aprobación. Cada entorno tiene sus secrets y reglas.

## Errores comunes

- **Desplegar sin health check**: crees que fue bien, pero la app no arranca. Siempre verifica tras el rollout.
- **Rollback sin `rollout status`**: el `undo` puede tardar; sin esperar el estado no sabes si terminó.
- **Blue-Green sin recursos para 2 entornos**: si el clúster no tiene capacidad para dos versiones, el swap falla.
- **Canary sin métricas**: sin SLOs no hay forma de decidir promover o revertir. Primero define umbrales.
- **GitOps sin `selfHeal`**: cambios manuales en el clúster persisten (drift) y ArgoCD no los revierte.
- **IaC con `tfstate` local**: pierdes el estado o hay carreras entre pipelines. Usa backend remoto con lock.
- **Aplicar Terraform con `-auto-approve` sin plan**: en CI, aplica siempre el plan generado; revisa el plan antes.
- **Releases manuales inconsistentes**: olvidar tag, no generar notas, versiones desordenadas. Automatiza con Conventional Commits.
- **Secrets del clúster en el repo de manifests**: van en un gestor de secretos (Sealed Secrets, External Secrets, Vault).
- **Desplegar a prod sin gate de staging**: si staging y prod comparten pipeline, un fallo puede llegar a prod. Separa con `environment` y `needs`.
