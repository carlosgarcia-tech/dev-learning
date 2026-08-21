# Ejercicio 06 — Cache de dependencias

- **Nivel:** 1/5
- **Tema:** `actions/cache`, `hashFiles`, `restore-keys`, `setup-node` con cache
- **Tiempo estimado:** 20 min

## Enunciado

Crea un workflow en `.github/workflows/cache.yml` que:

1. Se dispare en `push`.
2. Tenga un job `install` en `ubuntu-latest`.
3. Use `actions/checkout@v4`.
4. Use `actions/setup-node@v4` con `node-version: 20` y `cache: npm`.
5. Cree un `package.json` mínimo con `npm init -y`.
6. Ejecute `npm install` y luego `npm ls` para listar las dependencias.

> El objetivo es practicar el cache de dependencias: con `cache: npm`, `setup-node` cachea `~/.npm` automáticamente.

## Requisitos

- [ ] El archivo existe en `.github/workflows/cache.yml`.
- [ ] Usa `actions/setup-node@v4` con `cache: npm`.
- [ ] Ejecuta `npm install`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `setup-node@v4` acepta `cache: npm` como atajo: cachea `~/.npm` sin necesidad de `actions/cache`.
- Para un cache manual, se usaría `actions/cache@v4` con `key: ${{ runner.os }}-npm-${{ hashFiles('package-lock.json') }}`.
- `npm init -y` crea un `package.json` vacío en el directorio actual.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# .github/workflows/cache.yml
name: Cache
on: push
jobs:
  install:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm init -y
      - run: npm install
      - run: npm ls
```

</details>
