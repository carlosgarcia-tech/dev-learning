# Ejercicios de CI/CD — Índice

30 ejercicios progresivos (6 por nivel) + proyecto final. Cada ejercicio contiene:

- `README.md` — enunciado, requisitos, pistas y solución (plegable)
- Archivos de pipeline — `.github/workflows/*.yml`, `.gitlab-ci.yml`, `Dockerfile`, scripts según el ejercicio
- `test.sh` — validador bash con `set -euo pipefail` que comprueba la sintaxis y los campos de los YAML con `python3` + `yaml.safe_load`

## Cómo ejecutar los tests

Desde la carpeta del ejercicio:

```bash
bash test.sh
```

> Los tests requieren **`python3`** con **`pyyaml`** instalado:
>
> ```bash
> pip install pyyaml
> ```
>
> El runner valida los YAML de los pipelines con `yaml.safe_load` y comprueba los
> campos requeridos según el ejercicio. Si tienes [act](https://github.com/nektos/act)
> instalado, algunos tests pueden ejecutar el workflow localmente (opcional).
> El resultado final imprime `✅ Tests pasaron` o `❌ Tests fallaron`.

## Nivel 01 — Fundamentos (1/5)

Workflows básicos: un job, un step, trigger push, checkout, actions públicas, artifacts y cache.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Workflow básico (1 job, 1 step) | [`nivel-01-fundamentos/ejercicio-01-workflow-basico`](./nivel-01-fundamentos/ejercicio-01-workflow-basico/) |
| 02 | Trigger on push | [`nivel-01-fundamentos/ejercicio-02-trigger-push`](./nivel-01-fundamentos/ejercicio-02-trigger-push/) |
| 03 | Checkout + run echo | [`nivel-01-fundamentos/ejercicio-03-checkout-echo`](./nivel-01-fundamentos/ejercicio-03-checkout-echo/) |
| 04 | Usar una action pública | [`nivel-01-fundamentos/ejercicio-04-action-publica`](./nivel-01-fundamentos/ejercicio-04-action-publica/) |
| 05 | Artifacts | [`nivel-01-fundamentos/ejercicio-05-artifacts`](./nivel-01-fundamentos/ejercicio-05-artifacts/) |
| 06 | Cache de dependencias | [`nivel-01-fundamentos/ejercicio-06-cache`](./nivel-01-fundamentos/ejercicio-06-cache/) |

## Nivel 02 — Básico (2/5)

Matrix, paralelismo, jobs condicionales, jobs secuenciales, secrets y variables.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 07 | Matrix build | [`nivel-02-basico/ejercicio-01-matrix-build`](./nivel-02-basico/ejercicio-01-matrix-build/) |
| 08 | Jobs en paralelo | [`nivel-02-basico/ejercicio-02-jobs-paralelo`](./nivel-02-basico/ejercicio-02-jobs-paralelo/) |
| 09 | Job condicional (if) | [`nivel-02-basico/ejercicio-03-job-condicional`](./nivel-02-basico/ejercicio-03-job-condicional/) |
| 10 | Job secuencial (needs) | [`nivel-02-basico/ejercicio-04-job-secuencial`](./nivel-02-basico/ejercicio-04-job-secuencial/) |
| 11 | Secrets | [`nivel-02-basico/ejercicio-05-secrets`](./nivel-02-basico/ejercicio-05-secrets/) |
| 12 | Variables | [`nivel-02-basico/ejercicio-06-variables`](./nivel-02-basico/ejercicio-06-variables/) |

## Nivel 03 — Intermedio (3/5)

Pipelines completos: build+test+lint, Docker, deploy con script, reusable workflows, artifacts entre jobs.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 13 | Build + test + lint | [`nivel-03-intermedio/ejercicio-01-build-test-lint`](./nivel-03-intermedio/ejercicio-01-build-test-lint/) |
| 14 | Build de Docker image | [`nivel-03-intermedio/ejercicio-02-docker-build`](./nivel-03-intermedio/ejercicio-02-docker-build/) |
| 15 | Deploy con script | [`nivel-03-intermedio/ejercicio-03-deploy-script`](./nivel-03-intermedio/ejercicio-03-deploy-script/) |
| 16 | Reusable workflow | [`nivel-03-intermedio/ejercicio-04-reusable-workflow`](./nivel-03-intermedio/ejercicio-04-reusable-workflow/) |
| 17 | Artifacts entre jobs | [`nivel-03-intermedio/ejercicio-05-artifacts-entre-jobs`](./nivel-03-intermedio/ejercicio-05-artifacts-entre-jobs/) |
| 18 | Pipeline GitLab CI completo | [`nivel-03-intermedio/ejercicio-06-gitlab-ci-completo`](./nivel-03-intermedio/ejercicio-06-gitlab-ci-completo/) |

## Nivel 04 — Avanzado (4/5)

Monorepo, environments con approval, GitLab CI equivalente, releases con tags, pipelines dinámicos.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 19 | Monorepo con path filters | [`nivel-04-avanzado/ejercicio-01-monorepo-paths`](./nivel-04-avanzado/ejercicio-01-monorepo-paths/) |
| 20 | Deploy con environments y approval | [`nivel-04-avanzado/ejercicio-02-environments-approval`](./nivel-04-avanzado/ejercicio-02-environments-approval/) |
| 21 | GitLab CI equivalente | [`nivel-04-avanzado/ejercicio-03-gitlab-ci-equivalente`](./nivel-04-avanzado/ejercicio-03-gitlab-ci-equivalente/) |
| 22 | Release automático con tags | [`nivel-04-avanzado/ejercicio-04-release-tags`](./nivel-04-avanzado/ejercicio-04-release-tags/) |
| 23 | Pipeline dinámico con matrices | [`nivel-04-avanzado/ejercicio-05-pipeline-dinamico`](./nivel-04-avanzado/ejercicio-05-pipeline-dinamico/) |
| 24 | Jobs condicionales avanzados | [`nivel-04-avanzado/ejercicio-06-jobs-condicionales`](./nivel-04-avanzado/ejercicio-06-jobs-condicionales/) |

## Nivel 05 — Experto (5/5)

Estrategias de despliegue reales: blue-green K8s, canary, GitOps ArgoCD, multi-entorno, rollback, IaC Terraform.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 25 | Blue-green deploy con K8s | [`nivel-05-experto/ejercicio-01-blue-green-k8s`](./nivel-05-experto/ejercicio-01-blue-green-k8s/) |
| 26 | Canary deployment | [`nivel-05-experto/ejercicio-02-canary`](./nivel-05-experto/ejercicio-02-canary/) |
| 27 | GitOps con ArgoCD | [`nivel-05-experto/ejercicio-03-gitops-argocd`](./nivel-05-experto/ejercicio-03-gitops-argocd/) |
| 28 | Pipeline multi-entorno con gates | [`nivel-05-experto/ejercicio-04-multi-entorno-gates`](./nivel-05-experto/ejercicio-04-multi-entorno-gates/) |
| 29 | Rollback automático | [`nivel-05-experto/ejercicio-05-rollback-automatico`](./nivel-05-experto/ejercicio-05-rollback-automatico/) |
| 30 | IaC con Terraform en pipeline | [`nivel-05-experto/ejercicio-06-iac-terraform`](./nivel-05-experto/ejercicio-06-iac-terraform/) |

## Proyecto final

[**Pipeline completo de CI/CD**](proyectos/README.md) — proyecto integrador con app Node.js real: pipeline de CI
(lint+test+build+scan+publish imagen Docker) y pipeline de CD (deploy a staging automático, approval a prod,
health check y rollback). Incluye equivalente en GitLab CI y archivos *starter*.
