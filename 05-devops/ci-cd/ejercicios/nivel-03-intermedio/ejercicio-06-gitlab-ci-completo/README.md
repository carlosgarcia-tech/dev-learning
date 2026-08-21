# Ejercicio 18 — Pipeline GitLab CI completo

- **Nivel:** 3/5
- **Tema:** `.gitlab-ci.yml`, `stages`, `rules`, `artifacts`, `cache`, `image`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un pipeline completo de GitLab CI en `.gitlab-ci.yml` que:

1. Use la imagen `node:20-alpine` por defecto.
2. Defina tres `stages`: `build`, `test`, `deploy`.
3. Job `build` (stage build): ejecuta `npm ci && npm run build`, guarda `dist/` como artifact.
4. Job `test` (stage test): ejecuta `npm test`, usa cache de `node_modules` con `key.files: [package-lock.json]`.
5. Job `deploy` (stage deploy): ejecuta `echo "Desplegando"`, solo en rama `main` con `rules`, y es manual (`when: manual`).
6. Define `variables` globales con `NODE_ENV: production`.

## Requisitos

- [ ] El archivo existe en `.gitlab-ci.yml`.
- [ ] Usa `image: node:20-alpine`.
- [ ] Define `stages: [build, test, deploy]`.
- [ ] El job `build` tiene `artifacts: paths: [dist/]`.
- [ ] El job `test` usa `cache` con `key.files`.
- [ ] El job `deploy` usa `rules` con `$CI_COMMIT_BRANCH == "main"` y `when: manual`.
- [ ] Hay `variables` globales con `NODE_ENV`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En GitLab CI los jobs son claves de raíz del YAML, no van bajo `jobs:`.
- `stages:` define el orden; cada job se asigna con `stage:`.
- `rules` con `if:` decide cuándo se ejecuta el job; `when: manual` lo hace requerir un clic.
- `cache.key.files` invalida el cache cuando cambia el `package-lock.json`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .gitlab-ci.yml
image: node:20-alpine

stages:
  - build
  - test
  - deploy

variables:
  NODE_ENV: production

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

test:
  stage: test
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/
  script:
    - npm ci
    - npm test

deploy:
  stage: deploy
  script:
    - echo "Desplegando"
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
```

</details>
