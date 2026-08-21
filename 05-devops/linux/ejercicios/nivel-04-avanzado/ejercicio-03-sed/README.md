# Ejercicio 03 — Transformar texto con `sed`

- **Nivel:** 4/5
- **Tema:** `sed`, `s///`, `s///g`, `-i`, rangos, borrado de líneas
- **Tiempo estimado:** 30 min

## Enunciado

`setup.sh` crea un archivo `config.conf`:

```ini
# Configuracion de la app
host = localhost
puerto = 8080
debug = true
nivel = DEBUG
nombre = app-vieja
# Fin
```

Escribe `solucion.sh` que genere **tres** archivos resultantes:

1. `cambiado.txt` — a partir de `config.conf`, sustituye `localhost` por `0.0.0.0` y `true` por `false` (usa dos `sed` encadenados o uno con `-e`).
2. `mayus.txt` — pasa **a mayúsculas** todo el contenido de `config.conf` (`sed 's/.*/\U&/'` o `sed 's/[a-z]/\U&/g'`).
3. `sin_comentarios.txt` — borra las líneas que empiezan por `#` (`sed '/^#/d'`) y guarda el resultado.

No modifiques el archivo original.

## Requisitos

- [ ] `cambiado.txt` contiene `0.0.0.0` (no `localhost`).
- [ ] `cambiado.txt` contiene `false` (no `true`).
- [ ] `mayus.txt` está todo en mayúsculas (sin letras minúsculas `a-z`).
- [ ] `sin_comentarios.txt` no contiene ninguna línea que empiece por `#`.
- [ ] El `config.conf` original queda ** intacto** (sin modificar).
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `sed -e 's/localhost/0.0.0.0/g' -e 's/true/false/g' config.conf > cambiado.txt`.
- Para mayúsculas: `sed 's/[a-z]/\U&/g' config.conf > mayus.txt` (GNU sed).
- Para borrar comentarios: `sed '/^#/d' config.conf > sin_comentarios.txt`.
- Al no usar `-i`, el original no se modifica.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
#!/usr/bin/env bash
sed -e 's/localhost/0.0.0.0/g' -e 's/true/false/g' config.conf > cambiado.txt
sed 's/[a-z]/\U&/g' config.conf > mayus.txt
sed '/^#/d' config.conf > sin_comentarios.txt
```

</details>
