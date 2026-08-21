# TODO: crea tu Dockerfile multi-stage con scratch
# Stage builder: FROM golang:1.23-alpine AS builder, COPY go.mod, go mod download, COPY app/, CGO_ENABLED=0 go build -ldflags="-s -w" -o /app
# Stage runtime: FROM scratch, COPY --from=builder /app /app, ENTRYPOINT ["/app"]
