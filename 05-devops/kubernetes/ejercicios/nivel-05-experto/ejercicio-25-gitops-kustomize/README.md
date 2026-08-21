# Ejercicio 25 - GitOps con Kustomize

- **Nivel:** 5/5
- **Tema:** Gestión de manifiestos con Kustomize (base + overlay)
- **Tiempo estimado:** 35 min

## Enunciado

Kustomize permite gestionar manifiestos de Kubernetes sin plantillas: defines una
**base** con los recursos comunes y luego aplicas **overlays** que añaden o modifican
campos (labels, réplicas, nombres) sin tocar los archivos originales.

Crea una estructura con:

```
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── overlay/
    └── kustomization.yaml
```

La **base** debe contener un Deployment y un Service, y un `kustomization.yaml` que los
liste como `resources` y añada `commonLabels`.

El **overlay** debe referenciar la base (`resources: - ../base`) y sobrescribir:
- `commonLabels` con un label de entorno (ej. `env: production`).
- `replicas` para escalar el Deployment a 5 réplicas.

> Kustomize viene integrado en `kubectl`: `kubectl apply -k overlay/`.

## Requisitos

- [ ] Existe `base/kustomization.yaml` con `kind: Kustomization`, `resources` y `commonLabels`.
- [ ] Existe `overlay/kustomization.yaml` con `resources`, `commonLabels` y `replicas`.
- [ ] La base contiene un Deployment y un Service válidos.
- [ ] El overlay referencia la base (`../base`).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El `apiVersion` de los `kustomization.yaml` es `kustomize.config.k8s.io/v1beta1`.
- En `base/kustomization.yaml`, `resources` lista los archivos YAML del directorio base.
- En `overlay/kustomization.yaml`, `resources` referencia el directorio base con `- ../base`.
- `commonLabels` añade labels a todos los recursos sin modificar los archivos originales.
- El campo `replicas` en el overlay usa el formato:
  ```yaml
  replicas:
    - name: <nombre-del-deployment>
      count: 5
  ```
- Puedes renderizar el resultado con `kubectl kustomize overlay/` sin aplicar nada.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`base/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
commonLabels:
  app: api
resources:
  - deployment.yaml
  - service.yaml
```

`base/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - containerPort: 80
```

`base/service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 80
```

`overlay/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../base
commonLabels:
  env: production
replicas:
  - name: api
    count: 5
```

</details>
