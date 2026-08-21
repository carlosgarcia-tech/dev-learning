# Ejercicio 05 — Clonar y modificar

- **Nivel:** 1/5
- **Tema:** Fundamentos de Git
- **Tiempo estimado:** 20 minutos

## Enunciado

1. `setup.sh` crea un repositorio "origen" en `ORIGIN_DIR` e imprime su ruta.
2. Clona ese repositorio origen en un directorio llamado `clon` dentro del directorio temporal.
3. Dentro del clon, modifica `README.md` añadiendo la línea `## Uso`.
4. Commitea el cambio con el mensaje `docs: añade sección Uso`.
5. El test comprobará que el clon existe, tiene 2 commits y el segundo commit tiene el mensaje correcto.

## Requisitos

- [ ] Existe el directorio `clon/` con un repositorio git
- [ ] El clon tiene 2 commits
- [ ] El segundo commit tiene el mensaje `docs: añade sección Uso`
- [ ] `README.md` del clon contiene la línea `## Uso`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El setup imprime la ruta del origen en `$1` (argumento). Léela con `ORIGIN="$1"`.
- `git clone "$ORIGIN" clon` clona dentro de `clon/`.
- Recuerda hacer `cd clon` antes de operar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
ORIGIN="$1"
cd "$(dirname "$ORIGIN")"
git clone -q "$ORIGIN" clon
cd clon
echo "## Uso" >> README.md
git add README.md
git commit -q -m "docs: añade sección Uso"
```

</details>
