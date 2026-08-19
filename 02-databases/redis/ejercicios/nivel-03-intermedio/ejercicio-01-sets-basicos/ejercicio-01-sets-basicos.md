# Ejercicio 01 — Sets básicos

- **Nivel:** 3/5
- **Tema:** `SADD`, `SCARD`, `SISMEMBER`, `SREM`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SADD deportes futbol
SADD deportes baloncesto
SADD deportes futbol
```

Nota: el tercer comando añade `futbol` de nuevo, pero como los sets no admiten duplicados, el conjunto solo contiene `futbol` y `baloncesto`.

Responde las siguientes consultas con `redis-cli`:

1. Cuenta cuántos elementos tiene el set `deportes`.
2. Comprueba si `futbol` es miembro de `deportes`.
3. Comprueba si `tenis` es miembro de `deportes` (no está).
4. Elimina `futbol` de `deportes`.
5. Vuelve a contar los elementos de `deportes`.
6. Comprueba de nuevo si `futbol` es miembro de `deportes`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-01-sets-basicos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `SADD <set> <miembro>` añade uno o más miembros a un set.
- Pista 2: `SCARD <set>` devuelve la cardinalidad (número de miembros).
- Pista 3: `SISMEMBER <set> <miembro>` devuelve `1` si es miembro y `0` si no.
- Pista 4: `SREM <set> <miembro>` elimina un miembro y devuelve el número de elementos eliminados.
- Pista 5: Cuidado con `SMEMBERS` (o `SINTER`/`SUNION`): en Redis NO garantizan orden en la salida, por eso este ejercicio usa comandos deterministas como `SCARD` y `SISMEMBER`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
SCARD deportes
SISMEMBER deportes futbol
SISMEMBER deportes tenis
SREM deportes futbol
SCARD deportes
SISMEMBER deportes futbol
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-sets-basicos-test.sh   # requiere podman (levanta redis efímero)
```