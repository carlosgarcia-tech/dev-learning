# Nivel 2 — Básico

Operadores de consulta de MongoDB: comparación, lógica, expresiones regulares y existencia, arrays, documentos embebidos y agregados básicos. Todos los ejercicios usan datos de ejemplo deterministas y verifican su salida con un contenedor efímero de MongoDB.

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Comparación](ejercicio-01-comparacion/) | `$gt`, `$gte`, `$lte`, `$in`, `$nin` |
| 02 | [Lógicos](ejercicio-02-logicos/) | `$and`, `$or`, `$not`, `$nor` |
| 03 | [Regex y Existe](ejercicio-03-regex-y-existe/) | `$regex`, `$options`, `$exists`, `$type` |
| 04 | [Arrays](ejercicio-04-arrays/) | Coincidencia exacta, `$all`, `$size`, `$elemMatch` |
| 05 | [Campos Embebidos](ejercicio-05-campos-embebidos/) | Dot notation, documentos embebidos, proyección de subcampos |
| 06 | [Agregados Básicos](ejercicio-06-agregados-basicos/) | `countDocuments`, `distinct` |

## Cómo ejecutar un ejercicio

```bash
cd <carpeta-del-ejercicio>
bash ejercicio-0N-slug-test.sh   # requiere podman (levanta un contenedor efímero de mongo:7)
```

## Estructura de cada ejercicio

Cada carpeta `ejercicio-0N-slug/` contiene los ficheros con el prefijo del slug del ejercicio:

- `ejercicio-0N-slug.md` — enunciado, pistas y solución.
- `ejercicio-0N-slug-setup.js` — carga los datos de ejemplo (borra la colección e inserta datos deterministas).
- `ejercicio-0N-slug-solucion.js` — la solución de referencia.
- `ejercicio-0N-slug-expected.txt` — salida esperada, generada ejecutando la solución real.
- `ejercicio-0N-slug-test.sh` — aplica el setup, ejecuta la solución y compara la salida con `expected.txt`.

## Verificación

```bash
cd nivel-02-basico/ejercicio-01-comparacion
bash ejercicio-01-comparacion-test.sh   # imprime "OK" si la salida coincide
```