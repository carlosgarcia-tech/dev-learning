# Ejercicios — Docker

Cada ejercicio es una **carpeta** con: `README.md` (enunciado + requisitos + pistas + solución plegables), `Dockerfile` y/o `docker-compose.yml`, `app/` con código de ejemplo (Node.js o Python simple), `.dockerignore`, `solucion/` con la solución y `test.sh` (valida el `Dockerfile` con `hadolint` si está disponible, o con `grep`/`awk`; valida la estructura del `docker-compose.yml`; y opcionalmente construye/ejecuta si Docker está disponible).

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-primer-dockerfile
bash test.sh        # valida el Dockerfile (.dockerignore, estructura) sin necesidad de ejecutar contenedores
```

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | primer Dockerfile `FROM alpine`, copiar y ejecutar script, exponer puerto con app Node, variables de entorno, CMD vs ENTRYPOINT, `.dockerignore` | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | multi-stage build, imagen para app Python, volumen persistente, red entre dos contenedores, Compose básico de 1 servicio, `WORKDIR` y `COPY` | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | Compose con 2 servicios (app+db), `depends_on` y healthcheck, bind mount para desarrollo, red personalizada, multi-stage optimizado, build args y multi-arch | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | imagen distroless, usuario no root, límites de recursos en Compose, logging driver, Compose con nginx y backend, imagen con healthcheck, override de Compose para dev/prod | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | Compose de producción (app+db+cache+proxy), buildx multi-arch, escaneo con Trivy, Docker Swarm service, registry privado, imagen mínima scratch | ⬜ |
| [proyectos](proyectos/) | Proyecto final: microservicios con Docker Compose | ⬜ |
