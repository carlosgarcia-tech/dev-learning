# Ejercicio 02 — Deploy con environments y approval
- **Nivel:** 4/5
- **Tema:** Environments de GitHub, approval gates y `needs`
- **Tiempo estimado:** 40 min

## Enunciado

Tu equipo despliega a **producción** desde `main`, pero quieres exigir **aprobación manual** antes de cada deploy a prod. En GitHub Actions el mecanismo nativo son los **environments** con *required reviewers*.

Diseña un workflow en `.github/workflows/deploy.yml` que:

1. Tenga un job `build` y un job `test` (en paralelo o secuenciales).
2. Tenga un job `deploy-production` que:
   - dependa de `build` y `test` con `needs: [build, test]`;
   - declare `environment:` (por ejemplo `production`) para activar el gate de aprobación;
   - ejecute `scripts/deploy.sh production` (script de apoyo incluido en el repo).

> Nota: el *approval* real se configura en GitHub: **Settings → Environments → production → Required reviewers**. Aquí solo modelamos el workflow que lo dispara.

## Requisitos
- [ ] El job de deploy usa `needs: [build, test]` (o equivalente).
- [ ] Algún job tiene el campo `environment:` definido.
- [ ] El script `scripts/deploy.sh` existe y es ejecutable en el flujo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas
<details><summary>Mostrar pistas</summary>

- `environment:` puede ser un string (`environment: production`) o un objeto con `name` y `url`:
  ```yaml
  environment:
    name: production
    url: https://app.example.com
  ```
- El gate de aprobación aparece **solo** si configuras reviewers en GitHub; sin eso, el `environment` solo aporta protection rules y secrets propios, pero no detiene el job.
- `needs` con varios jobs se declara como lista: `needs: [build, test]`.
- El script de apoyo `scripts/deploy.sh` recibe el entorno como `$1` e imprime el despliegue; no hace nada real.

</details>

## Solución
<details><summary>Mostrar solución</summary>

```yaml
name: Deploy con approval
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Compilando artefacto"

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Ejecutando tests"

  deploy-production:
    needs: [build, test]
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://app.example.com
    steps:
      - uses: actions/checkout@v4
      - run: chmod +x scripts/deploy.sh && ./scripts/deploy.sh production
```

</details>
