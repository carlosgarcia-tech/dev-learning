# Ejercicio 30 — IaC con Terraform en pipeline

- **Nivel:** 5/5
- **Tema:** Infrastructure as Code, Terraform, `init`/`plan`/`apply`, `environment`
- **Tiempo estimado:** 45 min

## Enunciado

Integra Terraform en el pipeline de CI/CD. Necesitas:

1. `terraform/main.tf` — configura un `provider` (p. ej. `hashicorp/null` o `docker`) y un `resource` básico. Para que sea ejecutable sin credenciales reales, usa el provider `null` con un `null_resource` que ejecute un comando `echo`.
2. `.github/workflows/terraform.yml` — un workflow que:
   - Se dispara en `push` a `main` y en `pull_request`.
   - Instala Terraform con `hashicorp/setup-terraform@v3`.
   - Ejecuta `terraform init`, `terraform fmt -check`, `terraform validate` y `terraform plan`.
   - En push a `main`, ejecuta `terraform apply -auto-approve`.
   - El job de `apply` usa `environment: production`.

## Requisitos

- [ ] Existe `terraform/main.tf` con un `provider` y un `resource`.
- [ ] El workflow usa `hashicorp/setup-terraform@v3`.
- [ ] El workflow ejecuta `terraform init`, `fmt -check`, `validate` y `plan`.
- [ ] El workflow ejecuta `terraform apply` en push a `main`.
- [ ] El job de `apply` tiene `environment: production`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `hashicorp/setup-terraform@v3` instala Terraform en el runner.
- `terraform fmt -check` verifica formato (falla si no está formateado).
- `terraform plan` muestra los cambios planeados sin aplicarlos.
- `terraform apply -auto-approve` aplica sin pedir confirmación (ideal para CI).
- El provider `null` no requiere credenciales y es útil para ejercicios.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```hcl
# terraform/main.tf
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "null" {}

resource "null_resource" "demo" {
  provisioner "local-exec" {
    command = "echo 'Hola desde Terraform'"
  }
}

output "mensaje" {
  value = "Recurso creado"
}
```

```yaml
# .github/workflows/terraform.yml
name: Terraform
on:
  push:
    branches: [main]
  pull_request:
jobs:
  plan:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: terraform
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init
      - run: terraform fmt -check
      - run: terraform validate
      - run: terraform plan

  apply:
    needs: plan
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
    environment: production
    defaults:
      run:
        working-directory: terraform
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init
      - run: terraform apply -auto-approve
```

</details>
