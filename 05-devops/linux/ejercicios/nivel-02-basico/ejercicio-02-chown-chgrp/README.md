# Ejercicio 02 — Cambiar propietario con `chown` y `chgrp`

- **Nivel:** 2/5
- **Tema:** `chown`, `chgrp`, propietario y grupo, `id`
- **Tiempo estimado:** 20 min

## Enunciado

`setup.sh` crea una carpeta `datos/` con archivos propiedad del usuario actual. Para practicar `chown` y `chgrp`, escribirás `solucion.sh` que opere dentro de `datos/`:

1. Cambia el **grupo** de `compartido.txt` al grupo principal del usuario actual (descúbrelo con `id -gn`).
2. Cambia el propietario **y grupo** de `local.txt` al usuario y grupo actuales (`chown $(id -un):$(id -gn) local.txt`).
3. Cambia de forma **recursiva** el propietario de `carpeta/` al usuario actual (`chown -R $(id -un) carpeta`).

> Nota: en sistemas donde no se disponga de `sudo`, el cambio "al propio usuario" sigue siendo válido y sirve para practicar la sintaxis. El test verifica que los permisos resultantes son consistentes.

## Requisitos

- [ ] `compartido.txt` tiene como grupo el grupo principal del usuario (`id -gn`).
- [ ] `local.txt` tiene como propietario y grupo los del usuario actual.
- [ ] Todos los archivos dentro de `carpeta/` tienen como propietario el usuario actual (recursivo).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `id -un` da el nombre de tu usuario; `id -gn` da tu grupo principal.
- `chgrp $(id -gn) compartido.txt` cambia el grupo.
- `chown usuario:grupo archivo` cambia propietario y grupo a la vez.
- `chown -R usuario carpeta` aplica recursivamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
cd datos
GRUPO=$(id -gn)
USUARIO=$(id -un)
chgrp "$GRUPO" compartido.txt
chown "$USUARIO:$GRUPO" local.txt
chown -R "$USUARIO" carpeta
```

</details>
