# Ejercicio 03 — GitLab CI equivalente
- **Nivel:** 4/5
- **Tema:** GitLab CI: stages, jobs, `rules`, `artifacts`
- **Tiempo estimado:** 50 min

## Enunciado

Has visto pipelines de GitHub Actions y ahora necesitas su **equivalente en GitLab CI** para un proyecto equivalente: build → test → deploy.

Crea un archivo `.gitlab-ci.yml` (raíz de este ejercicio) que:

1. Defina al menos los **stages** `build`, `test` y `deploy`.
2. Tenga un job de `build` que produzca un **artifact** (por ejemplo `build/output.txt`).
3. Use `rules` en al menos un job para condicionar su ejecución (por rama o por tag).
4. Tenga un job de `deploy` que **dependa** (`needs:`) del job de test y se ejecute solo en la rama `main`.

> Objetivo pedagógico: mapear conceptos de GitHub Actions (jobs/needs/if) a su forma GitLab (stages/rules/needs/artifacts).

## Requisitos
- [ ] `.gitlab-ci.yml` existe en la raíz del ejercicio.
- [ ] Define `stages` (al menos build, test, deploy).
- [ ] Al menos un job usa `rules` con `if`.
- [ ] Al menos un job declara `artifacts`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- En GitLab CI, `stages` es una lista de nombres en la raíz del YAML. Cada job declara su `stage:` (si no, va al stage por defecto `.pre`/`test`).
- Los `rules` reemplazan a `only`/`except`. Cada elemento es un `if` (expresión con variables `$CI_COMMIT_BRANCH`, `$CI_COMMIT_TAG`).
- Los **artifacts** se declaran con `artifacts: paths: [...]`. Se pasan automáticamente a jobs de stages posteriores.
- `needs` permite descargar artifacts de un job anterior sin esperar a todo el stage: `needs: [test_job]`.
- Variables de GitLab útiles: `$CI_COMMIT_BRANCH`, `$CI_COMMIT_TAG`, `$CI_PIPELINE_SOURCE`.

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
stages:
  - build
  - test
  - deploy

construir:
  stage: build
  image: alpine:latest
  script:
    - mkdir -p build
    - echo "artefacto compilado el $(date -u +%FT%TZ)" > build/output.txt
  artifacts:
    paths:
      - build/
    expire_in: 1 day

testear:
  stage: test
  image: alpine:latest
  needs: [construir]
  script:
    - test -f build/output.txt
    - echo "Tests OK sobre el artefacto"

desplegar:
  stage: deploy
  image: alpine:latest
  needs: [testear]
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
  script:
    - echo "Desplegando a producción desde main"
```

</details>
