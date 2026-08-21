# Ejercicio 04 — Remote y push

- **Nivel:** 2/5
- **Tema:** Repositorios remotos
- **Tiempo estimado:** 25 minutos

## Enunciado

1. `setup.sh` crea un repositorio **bare** (el remoto) y un clon de trabajo, e imprime la ruta del clon.
2. Dentro del clon, crea un archivo `feature.js` y commitea con `feat: añade feature.js`.
3. Sube el commit al remoto `origin` con `git push`.

## Requisitos

- [ ] El clon tiene un commit nuevo con `feature.js` y mensaje `feat: añade feature.js`
- [ ] El remoto `origin` contiene ese commit (su rama `main` apunta al mismo commit que el clon)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El setup ya configura el remoto `origin` al clonar.
- Solo necesitas crear el archivo, commitear y `git push`.
- El clon ya tiene upstream configurado (clone lo hace).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$CLON_DIR"
echo "export function feature() {}" > feature.js
git add feature.js
git commit -q -m "feat: añade feature.js"
git push -q origin HEAD
```

</details>
