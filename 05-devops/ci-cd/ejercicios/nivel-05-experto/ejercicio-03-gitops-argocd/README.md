# Ejercicio 27 — GitOps con ArgoCD

- **Nivel:** 5/5
- **Tema:** GitOps, ArgoCD, `Application`, repo como fuente de verdad
- **Tiempo estimado:** 40 min

## Enunciado

Configura GitOps con ArgoCD. Necesitas:

1. `k8s/argocd-application.yaml` — un recurso `Application` (API `argoproj.io/v1alpha1`) que:
   - Referencie un repo `https://github.com/ejemplo/k8s-manifests` como `source`.
   - Apunte al path `prod/`.
   - El `destination.server` sea `https://kubernetes.default.svc`.
   - El namespace destino sea `prod`.
   - Tenga `syncPolicy.automated` con `prune: true` y `selfHeal: true`.
2. `.github/workflows/gitops.yml` — un workflow que:
   - Se dispara en `push` a `main`.
   - Hace checkout de un repo de manifests (usa `repository: org/k8s-manifests`).
   - Actualiza la imagen en un `deployment.yaml` con `sed`.
   - Hace commit y push al repo de manifests.

> En GitOps, el pipeline no aplica al clúster directamente: actualiza el repo de manifests y ArgoCD sincroniza.

## Requisitos

- [ ] Existe `k8s/argocd-application.yaml` con `kind: Application`.
- [ ] La Application tiene `spec.source.repoURL`.
- [ ] La Application tiene `spec.destination.server` y `spec.destination.namespace`.
- [ ] La Application tiene `syncPolicy.automated` con `selfHeal`.
- [ ] El workflow hace commit y push al repo de manifests.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- ArgoCD vigila el repo y aplica los cambios automáticamente con `syncPolicy.automated`.
- `selfHeal: true` revierte cualquier cambio manual en el clúster (drift).
- `prune: true` elimina recursos que ya no están en el repo.
- El workflow actualiza el manifest y hace push; ArgoCD detecta el cambio.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# k8s/argocd-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: mi-app
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/ejemplo/k8s-manifests
    path: prod
    targetRevision: HEAD
  destination:
    server: https://kubernetes.default.svc
    namespace: prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

```yaml
# .github/workflows/gitops.yml
name: GitOps
on:
  push:
    branches: [main]
jobs:
  update-manifest:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          repository: org/k8s-manifests
          token: ${{ secrets.DEPLOY_TOKEN }}
      - name: Actualizar imagen
        run: |
          sed -i "s|image: .*|image: ghcr.io/org/app:${{ github.sha }}|" deployment.yaml
      - name: Commit y push
        run: |
          git config user.name "ci-bot"
          git config user.email "ci-bot@example.com"
          git commit -am "Update image to ${{ github.sha }}"
          git push
```

</details>
