# Nivel 1 — Fundamentos

Primeros pasos con MongoDB: operaciones CRUD básicas (crear, leer, actualizar y eliminar) usando `mongosh`. Todos los ejercicios usan datos de ejemplo deterministas y verifican su salida con un contenedor efímero de MongoDB.

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [Insert y Find](ejercicio-01-insert-y-find/) | insertOne, insertMany, find, countDocuments |
| 02 | [Find con Filtros](ejercicio-02-find-con-filtros/) | Filtros de igualdad, `$gt`, `$ne`, countDocuments |
| 03 | [Proyección](ejercicio-03-proyeccion/) | Proyección incluyente y excluyente de campos |
| 04 | [Update](ejercicio-04-update/) | updateOne, updateMany, `$inc`, `$mul`, `$unset`, `$set` |
| 05 | [Delete](ejercicio-05-delete/) | deleteOne, deleteMany, countDocuments, drop |
| 06 | [Orden y Límite](ejercicio-06-orden-y-limit/) | sort, limit, skip, findOne |

## Cómo ejecutar un ejercicio

```bash
cd <carpeta-del-ejercicio>
bash test.sh   # requiere podman (levanta un contenedor efímero de mongo:7)
```

Cada carpeta contiene:

- `setup.js` — carga los datos de ejemplo (borra la colección e inserta datos deterministas).
- `solucion.js` — la solución de referencia.
- `expected.txt` — salida esperada, generada ejecutando la solución real.
- `test.sh` — aplica el setup, ejecuta la solución y compara la salida con `expected.txt`.
- `README.md` — enunciado, pistas y solución.