# Ejercicio 04 — Geospatial

- **Nivel:** 4/5
- **Tema:** `GEOADD`, `GEOPOS`, `GEODIST`, `GEOSEARCH`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
GEOADD ciudades 2.2945 48.8584 paris
GEOADD ciudades -3.7038 40.4168 madrid
GEOADD ciudades 12.4964 41.9028 roma
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén la posición (longitud y latitud) de `paris` con `GEOPOS`.
2. Calcula la distancia entre `madrid` y `roma` en kilómetros con `GEODIST`.
3. Busca las ciudades dentro de un radio de 1500 km desde `madrid`, ordenadas por distancia con `GEOSEARCH FROMMEMBER madrid BYRADIUS 1500 km ASC`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-04-geospatial-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `GEOPOS <clave> <miembro>` devuelve la longitud y latitud del miembro.
- Pista 2: `GEODIST <clave> <miembro1> <miembro2> km` devuelve la distancia en la unidad indicada.
- Pista 3: `GEOSEARCH <clave> FROMMEMBER <miembro> BYRADIUS <r> km ASC` devuelve los miembros dentro del radio ordenados por distancia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GEOPOS ciudades paris
GEODIST ciudades madrid roma km
GEOSEARCH ciudades FROMMEMBER madrid BYRADIUS 1500 km ASC
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-geospatial-test.sh   # requiere podman (levanta redis efímero)
```