# Ejercicio 06 — Imagen mínima scratch

- **Nivel:** 5/5
- **Tema:** `FROM scratch`, binario estático, imagen de 0 MB base, multi-stage extremo
- **Tiempo estimado:** 40 min

## Enunciado

Crea un `Dockerfile` que produzca la imagen más pequeña posible usando `FROM scratch` con un binario Go compilado estáticamente.

1. **Stage `builder`**: `FROM golang:1.23-alpine AS builder`, copia el código Go, compila con `CGO_ENABLED=0` y `-ldflags="-s -w"` (binario estático sin símbolos de depuración).
2. **Stage runtime**: `FROM scratch`, copia solo el binario desde el builder, `ENTRYPOINT ["/app"]`.

La imagen final debe pesar unos pocos MB y no tener shell, ni libc, ni nada.

## Requisitos

- [ ] Stage `builder` con `golang:1.23-alpine`
- [ ] `CGO_ENABLED=0` en el build
- [ ] `-ldflags="-s -w"` (strip de símbolos)
- [ ] Stage runtime con `FROM scratch`
- [ ] `COPY --from=builder` del binario
- [ ] `ENTRYPOINT ["/app"]`
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CGO_ENABLED=0` desactiva cgo y produce un binario estático (sin dependencias de libc).
- `-ldflags="-s -w"` quita símbolos de depuración y reduce el tamaño del binario.
- `FROM scratch` empieza desde cero: no hay ni `sh`. Solo funciona con binarios estáticos.
- Sin shell, no puedes hacer `docker exec sh`. Para depurar usa `:debug` o un sidecar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM golang:1.23-alpine AS builder
WORKDIR /src
COPY app/go.mod ./
RUN go mod download
COPY app/ ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app .

FROM scratch
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

</details>
