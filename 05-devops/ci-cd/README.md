# CI/CD

> Ruta de aprendizaje completa de CI/CD (Integración y Entrega Continua) en español: guías de estudio, ejercicios por niveles, proyecto integrador y proyecto final.

CI/CD es la columna vertebral del DevOps moderno: automatiza la integración del código de todo el equipo (CI), la entrega de artefactos verificables (CD — *Continuous Delivery*) y el despliegue a producción (CD — *Continuous Deployment*). Esta ruta cubre desde el concepto de *pipeline* hasta estrategias de despliegue avanzadas con Docker, Kubernetes y GitOps.

La ruta asume que conoces Git y Docker. Cada guía introduce la teoría con ejemplos reales de YAML (GitHub Actions y GitLab CI) y enlaza a los ejercicios que la refuerzan.

## Estructura

```
ci-cd/
├── 01-fundamentos.md            # Guía 01: qué es CI/CD, pipelines, stages/jobs, triggers, artifacts, cache, runners
├── 02-github-actions.md         # Guía 02: workflows, events, jobs, steps, actions, secrets, environments, matrix
├── 03-gitlab-ci.md              # Guía 03: .gitlab-ci.yml, stages, jobs, rules, artifacts, variables, runners
├── 04-pipelines-avanzados.md     # Guía 04: pipelines dinámicos, matrices, reusables, monorepo, approval gates
├── 05-despliegue-y-estrategias.md # Guía 05: blue-green, canary, rolling, K8s, IaC, GitOps, rollback
├── ejercicios/
│   ├── README.md                # Índice de los 30 ejercicios por nivel
│   ├── nivel-01-fundamentos/    # 6 ejercicios (1-6)
│   ├── nivel-02-basico/         # 6 ejercicios (7-12)
│   nivel-03-intermedio/         # 6 ejercicios (13-18)
│   ├── nivel-04-avanzado/       # 6 ejercicios (19-24)
│   ├── nivel-05-experto/        # 6 ejercicios (25-30)
│   └── proyectos/
│       ├── README.md              # Proyecto final: Pipeline completo de CI/CD
│       └── pipeline-completo/     # App + pipeline CI + pipeline CD + starter
└── README.md                    # este archivo
```

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Qué es CI/CD, pipelines, stages/jobs, triggers, artifacts, cache, runners, CI vs CD vs CD continuo |
| [02 — GitHub Actions](02-github-actions.md) | Workflows, events, jobs, steps, actions, runners, secrets, environments, matrix, cache, artifacts |
| [03 — GitLab CI](03-gitlab-ci.md) | `.gitlab-ci.yml`, stages, jobs, rules, artifacts, variables, runners, imágenes Docker |
| [04 — Pipelines avanzados](04-pipelines-avanzados.md) | Pipelines dinámicos, matrices, paralelismo, jobs condicionales, reusable workflows, monorepo, approval gates |
| [05 — Despliegue y estrategias](05-despliegue-y-estrategias.md) | Blue-green, canary, rolling, Docker/K8s, IaC, GitOps, releases automáticos, rollback |

## Ejercicios por nivel

Cada ejercicio está en una carpeta con `README.md` (enunciado, requisitos, pistas y solución), archivos de pipeline (`.github/workflows/*.yml`, `.gitlab-ci.yml`, `Dockerfile`, scripts) y `test.sh` que valida los YAML con `python3` + `yaml.safe_load`. Ejecuta los tests desde la carpeta del ejercicio con `bash test.sh`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Workflow básico, trigger push, checkout+echo, action pública, artifacts, cache |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Matrix build, jobs en paralelo, job condicional (if), job secuencial (needs), secrets y variables |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Build+test+lint, Docker image, deploy con script, reusable workflow, artifacts entre jobs |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Monorepo con path filters, environments+approval, GitLab CI equivalente, release con tags, pipeline dinámico |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | Blue-green K8s, canary, GitOps con ArgoCD, multi-entorno con gates, rollback automático, IaC con Terraform |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyecto final

[**Pipeline completo de CI/CD**](ejercicios/proyectos/README.md) — proyecto integrador con una app real (Node.js), pipeline de CI (lint+test+build+scan+publish imagen Docker) y pipeline de CD (deploy a staging automático, approval a producción, health check y rollback). Incluye equivalente en GitLab CI y archivos *starter*.

## Cómo ejecutar los tests

- **Tests de los ejercicios**: desde la carpeta de un ejercicio, `bash test.sh`. Requiere `python3` con `pyyaml` instalado (`pip install pyyaml`).
- **Validación de YAML**: los `test.sh` usan `python3 -c "import yaml; yaml.safe_load(...)"` para verificar sintaxis y campos requeridos.
- **Ejecución local con act** (opcional): si tienes [act](https://github.com/nektos/act) instalado, algunos tests lo usan para simular el workflow localmente.

## Requisitos previos

- **Git** — ver la ruta [05-devops/git](../git/)
- **Docker** — ver la ruta [05-devops/docker](../docker/)
- **Python 3** con `pyyaml` — para ejecutar los `test.sh` de los ejercicios
- **Cuenta de GitHub** (recomendada) — para ejecutar workflows reales en GitHub Actions
- **Cuenta de GitLab** (opcional) — para probar pipelines de GitLab CI
