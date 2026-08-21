FROM golang:1.23-alpine AS builder
WORKDIR /src
COPY app/go.mod ./
RUN go mod download
COPY app/ ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /app .

FROM scratch
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
