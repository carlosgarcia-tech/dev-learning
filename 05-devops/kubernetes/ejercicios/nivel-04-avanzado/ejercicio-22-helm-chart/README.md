# Ejercicio 22 - Helm chart básico

- **Nivel:** 4/5
- **Tema:** Creación de un chart de Helm con plantillas
- **Tiempo estimado:** 35 min

## Enunciado

Crea un **chart de Helm** básico llamado `miapp` que despliegue una web con `nginx`.
El chart debe tener la estructura estándar de Helm:

```
miapp/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    └── service.yaml
```

Requisitos del chart:
- `Chart.yaml` define el chart (`apiVersion: v2`, `name`, `version`, `appVersion`).
- `values.yaml` define valores por defecto: `replicaCount`, `image.repository`,
  `image.tag`, `service.port`.
- `templates/deployment.yaml` usa las plantillas de Helm (`{{ .Values ... }}`,
  `{{ .Release.Name }}`) para el Deployment.
- `templates/service.yaml` usa las plantillas de Helm para el Service.

> El objetivo es entender la **estructura de un chart** y las **plantillas con valores**.
> Los tests validan que `Chart.yaml`, `values.yaml` y los templates sean YAML válidos
> (renderizando las plantillas de forma simple o validando su sintaxis).

## Requisitos

- [ ] Estructura de carpetas `miapp/` con `Chart.yaml`, `values.yaml` y `templates/`.
- [ ] `Chart.yaml` con `apiVersion: v2`, `name`, `version` y `appVersion`.
- [ ] `values.yaml` con `replicaCount`, `image.repository`, `image.tag`, `service.port`.
- [ ] `templates/deployment.yaml` y `templates/service.yaml` con plantillas de Helm.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Chart.yaml` usa `apiVersion: v2` para charts modernos (Helm 3).
- En `values.yaml` defines valores por defecto que luego lees en las plantillas.
- Las plantillas acceden a los valores con `{{ .Values.replicaCount }}`,
  `{{ .Values.image.repository }}`, etc.
- El nombre de los recursos puede combinarse con el nombre del release:
  `{{ .Release.Name }}`.
- Las plantillas de Helm son Go templates; el `{{ }}` se procesa al instalar el chart.
- Los tests validan la sintaxis YAML de `Chart.yaml` y `values.yaml`, y de los templates
  eliminando las directivas `{{ }}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`miapp/Chart.yaml`:

```yaml
apiVersion: v2
name: miapp
description: Chart basico de ejemplo para el ejercicio 22
type: application
version: 0.1.0
appVersion: "1.25"
```

`miapp/values.yaml`:

```yaml
replicaCount: 2

image:
  repository: nginx
  tag: "1.25"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
```

`miapp/templates/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-miapp
  labels:
    app: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: miapp
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: {{ .Values.service.port }}
```

`miapp/templates/service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-miapp
  labels:
    app: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app: {{ .Release.Name }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
```

</details>
