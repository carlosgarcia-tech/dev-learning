# Ejercicio 05 — Bitmaps

- **Nivel:** 4/5
- **Tema:** `SETBIT`, `GETBIT`, `BITCOUNT`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SETBIT online 0 1
SETBIT online 3 1
SETBIT online 7 1
```

Responde las siguientes consultas con `redis-cli`:

1. Consulta el bit en la posición `0` de la clave `online` con `GETBIT` (devuelve 1 o 0).
2. Consulta el bit en la posición `1` de `online` (está en 0).
3. Cuenta los bits en 1 de toda la clave `online` con `BITCOUNT`.
4. Cuenta los bits en 1 solo del primer byte (rango `0 1 BYTE`) de `online`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-05-bitmaps-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `GETBIT <clave> <posicion>` devuelve `1` o `0` según el valor del bit.
- Pista 2: `BITCOUNT <clave>` cuenta todos los bits en `1`.
- Pista 3: `BITCOUNT <clave> <inicio> <fin> BYTE` limita el conteo a un rango de bytes.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GETBIT online 0
GETBIT online 1
BITCOUNT online
BITCOUNT online 0 1 BYTE
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-bitmaps-test.sh   # requiere podman (levanta redis efímero)
```