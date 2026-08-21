# Ejercicio 06 — Limpieza con gc, prune y fsck

- **Nivel:** 5/5
- **Tema:** Mantenimiento del repositorio
- **Tiempo estimado:** 30 minutos

## Enunciado

1. El repo está en `main` con varios commits y hay objetos sueltos acumulados.
2. Ejecuta `git gc` para empaquetar objetos y optimizar el repositorio.
3. Verifica la integridad con `git fsck`.
4. El test comprobará que tras el `gc` hay un archivo `.pack` en `.git/objects/pack/` y que `git fsck` no reporta errores de integridad.

## Requisitos

- [ ] Existe al menos un archivo `.pack` en `.git/objects/pack/`
- [ ] `git fsck` no reporta errores de objetos corruptos (salida sin "error:" ni "missing")
- [ ] `git count-objects -v` muestra que los objetos están empaquetados (packs > 0)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git gc` empaqueta los objetos sueltos en un `.pack` y borra lo innecesario.
- `git gc --prune=now` además borra los objetos inalcanzables inmediatamente.
- `git fsck --full` verifica la integridad de todos los objetos.
- El test no requiere que fsck esté totalmente vacío, solo que no haya "error:" de objetos corruptos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git gc --prune=now -q
git fsck --full >/dev/null 2>&1 || true
```

</details>
