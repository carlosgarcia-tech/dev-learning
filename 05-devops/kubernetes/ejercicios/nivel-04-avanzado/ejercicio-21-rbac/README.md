# Ejercicio 21 - RBAC: ServiceAccount, Role y RoleBinding

- **Nivel:** 4/5
- **Tema:** Control de acceso basado en roles (RBAC) en Kubernetes
- **Tiempo estimado:** 30 min

## Enunciado

Crea los tres objetos RBAC necesarios para que una aplicación (ServiceAccount) pueda
**solo leer pods** dentro de un namespace.

Necesitas:
- Un **ServiceAccount** `pod-reader`.
- Un **Role** `pod-reader` que conceda permisos de lectura (`get`, `list`, `watch`)
  sobre el recurso `pods`.
- Un **RoleBinding** `pod-reader` que vincule el Role con el ServiceAccount.

Al aplicar estos manifiestos, cualquier pod que use el ServiceAccount `pod-reader`
podrá listar y obtener pods, pero no podrá crearlos, borrarlos ni modificarlos.

## Requisitos

- [ ] ServiceAccount `pod-reader`.
- [ ] Role `pod-reader` con permisos `get`, `list`, `watch` sobre `pods`.
- [ ] RoleBinding `pod-reader` que vincula Role y ServiceAccount.
- [ ] El RoleBinding referencia correctamente al ServiceAccount.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `apiVersion` de Role y RoleBinding: `rbac.authorization.k8s.io/v1`.
- Un Role concede permisos con `rules[].apiGroups`, `rules[].resources` y
  `rules[].verbs`.
- Los pods están en el apiGroup `` (vacío, el core).
- El RoleBinding enlaza con `roleRef` (el Role) y `subjects` (el ServiceAccount).
- `roleRef.kind` = `Role` y `subjects[].kind` = `ServiceAccount`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`serviceaccount.yaml`:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pod-reader
```

`role.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
```

`rolebinding.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader
subjects:
  - kind: ServiceAccount
    name: pod-reader
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

</details>
