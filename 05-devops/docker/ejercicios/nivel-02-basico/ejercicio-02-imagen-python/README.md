# Ejercicio 02 — Imagen para app Python

- **Nivel:** 2/5
- **Tema:** `python:3.12-slim`, `pip install`, `COPY`, `CMD`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `Dockerfile` para una app Python (Flask-like usando solo stdlib) que sirve HTTP.

1. Base `python:3.12-slim`.
2. `WORKDIR /app`.
3. Copia `app/requirements.txt` e instala con `pip install --no-cache-dir -r requirements.txt`.
4. Copia `app/` al contenedor.
5. `EXPOSE 5000`.
6. `CMD ["python", "app.py"]`.

## Requisitos

- [ ] `FROM python:3.12-slim`
- [ ] `WORKDIR /app`
- [ ] `COPY` de `requirements.txt` **antes** que el resto del código (cache)
- [ ] `RUN pip install --no-cache-dir -r requirements.txt`
- [ ] `COPY app/ ./` (o equivalente)
- [ ] `EXPOSE 5000`
- [ ] `CMD ["python", "app.py"]` (forma exec)
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `python:3.12-slim` es más pequeña que `python:3.12` (sin compiladores) y suficiente para apps que solo usan wheels puros.
- `--no-cache-dir` evita que pip guarde cache y hinche la capa.
- Copia `requirements.txt` antes que el código para que `pip install` se cachee.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ ./
EXPOSE 5000
CMD ["python", "app.py"]
```

</details>
