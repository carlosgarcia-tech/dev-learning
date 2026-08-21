# Ejercicio 05 — CMD vs ENTRYPOINT

- **Nivel:** 1/5
- **Tema:** Diferencia entre `CMD` y `ENTRYPOINT`, argumentos sobrescribibles
- **Tiempo estimado:** 25 min

## Enunciado

Crea un `Dockerfile` que se comporte como un "binario" con argumentos por defecto sobrescribibles: usa `ENTRYPOINT` fijo con `echo` y `CMD` con un mensaje por defecto.

1. Base `alpine:3.20`.
2. `ENTRYPOINT ["echo", "Hola"]` (fijo).
3. `CMD ["Docker"]` (argumento por defecto, sobrescribible).

Comportamiento esperado:
- `docker run <imagen>` → imprime `Hola Docker`.
- `docker run <imagen> Mundo` → imprime `Hola Mundo` (el `CMD` se reemplaza por `Mundo`, pero `ENTRYPOINT` permanece).

## Requisitos

- [ ] `FROM alpine:3.20`
- [ ] `ENTRYPOINT ["echo", "Hola"]` en forma exec
- [ ] `CMD ["Docker"]` en forma exec
- [ ] Existe `.dockerignore`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `ENTRYPOINT` fija el ejecutable base; los argumentos de `docker run` se **añaden** al `ENTRYPOINT`.
- `CMD` aporta argumentos por defecto que se **sustituyen** si pasas otros en `docker run`.
- Patrón: `ENTRYPOINT ["echo","Hola"]` + `CMD ["Docker"]` → sin args: `echo Hola Docker`; con `Mundo`: `echo Hola Mundo`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```dockerfile
FROM alpine:3.20
ENTRYPOINT ["echo", "Hola"]
CMD ["Docker"]
```

</details>
