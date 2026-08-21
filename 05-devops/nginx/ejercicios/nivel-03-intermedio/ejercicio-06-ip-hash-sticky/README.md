# Ejercicio 06 — ip_hash para sesiones sticky

- **Nivel:** 3/5
- **Tema:** `ip_hash` para sesiones pegajosas por IP del cliente
- **Tiempo estimado:** 25 min

## Enunciado

Configura Nginx con `ip_hash` para que un mismo cliente siempre vaya al mismo backend (sesión sticky):

- `upstream app_backend { ip_hash; server 127.0.0.1:9001; server 127.0.0.1:9002; }`
- Puerto `8080`, `proxy_pass http://app_backend;`.
- Reenvía `Host` y `X-Forwarded-For`.

`ip_hash` calcula un hash de la IP del cliente y lo asigna siempre al mismo backend, salvo que este caiga.

## Requisitos

- [ ] `upstream` con `ip_hash;` activado
- [ ] 2 backends en el upstream (9001 y 9002)
- [ ] `proxy_pass http://app_backend;`
- [ ] `proxy_set_header Host $host;`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `ip_hash;` va dentro del bloque `upstream`, antes de los `server`.
- Pista 2: Es útil cuando la sesión vive en memoria del backend y no hay store compartido.
- Pista 3: No combina bien con NAT/CDN (muchos clientes comparten IP).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```nginx
events { worker_connections 1024; }
http {
    upstream app_backend {
        ip_hash;
        server 127.0.0.1:9001;
        server 127.0.0.1:9002;
    }
    server {
        listen 8080;
        location / {
            proxy_pass http://app_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
