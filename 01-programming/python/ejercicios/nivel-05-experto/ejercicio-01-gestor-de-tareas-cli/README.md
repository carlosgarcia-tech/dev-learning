# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** argparse, json, persistencia, CRUD
- **Tiempo estimado:** 45 min

## Enunciado

Completa `main.py` para que implemente un gestor de tareas de consola con persistencia en `tareas.json`. Cada tarea es un diccionario `{"id": int, "descripcion": str, "estado": str}`. Los datos se leen al inicio (si el archivo no existe, empieza con `[]`) y se guardan tras cada mutación con `json.dump`.

Implementa las funciones:

1. `cargar(ruta)` — lee las tareas de `ruta`; si el archivo no existe, devuelve `[]`.
2. `guardar(ruta, tareas)` — escribe las tareas en `ruta` con `json.dump` (`ensure_ascii=False, indent=2`).
3. `agregar(ruta, descripcion)` — añade una tarea con id autoincremental y estado `pendiente`, la persiste y devuelve `"Tarea <id> añadida"`.
4. `listar(ruta)` — devuelve la lista de strings `"[id] estado — descripción"` de todas las tareas.
5. `completar(ruta, tarea_id)` — marca la tarea como `completada`, la persiste y devuelve `"Tarea <id> completada"`; si no existe, devuelve `"Tarea <id> no encontrada"`.
6. `eliminar(ruta, tarea_id)` — elimina la tarea, persiste el cambio y devuelve `"Tarea <id> eliminada"`; si no existe, devuelve `"Tarea <id> no encontrada"`.
7. `main()` — CLI con `argparse` (`add_subparsers`) con los subcomandos `agregar "descripción"`, `listar`, `completar <id>` y `eliminar <id>`, imprimiendo la salida de cada operación.

Ejemplo de uso y salida:

```
$ python3 main.py agregar "Comprar pan"
Tarea 1 añadida
$ python3 main.py agregar "Estudiar Python"
Tarea 2 añadida
$ python3 main.py listar
[1] pendiente — Comprar pan
[2] pendiente — Estudiar Python
$ python3 main.py completar 1
Tarea 1 completada
$ python3 main.py eliminar 2
Tarea 2 eliminada
```

## Requisitos

- [ ] Usar `argparse` con subcomandos (`add_subparsers`) en `main()`.
- [ ] `cargar` maneja el archivo inexistente devolviendo `[]`.
- [ ] `guardar` persiste tras cada mutación.
- [ ] Validar que el id exista al completar/eliminar (si no, mensaje de error).
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `add_subparsers()` crea subcomandos; cada uno con sus argumentos.
- `json.load(open(...))` y `json.dump(tareas, f, ensure_ascii=False, indent=2)`.
- El id nuevo es `max((t["id"] for t in tareas), default=0) + 1`.
- Para eliminar, usa una comprensión que filtre por id.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import argparse
import json
import os

ARCHIVO = "tareas.json"


def cargar(ruta):
    if not os.path.exists(ruta):
        return []
    with open(ruta, "r", encoding="utf-8") as f:
        return json.load(f)


def guardar(ruta, tareas):
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(tareas, f, ensure_ascii=False, indent=2)


def agregar(ruta, descripcion):
    tareas = cargar(ruta)
    nuevo_id = max((t["id"] for t in tareas), default=0) + 1
    tareas.append({"id": nuevo_id, "descripcion": descripcion, "estado": "pendiente"})
    guardar(ruta, tareas)
    return f"Tarea {nuevo_id} añadida"


def listar(ruta):
    tareas = cargar(ruta)
    return [f"[{t['id']}] {t['estado']} — {t['descripcion']}" for t in tareas]


def completar(ruta, tarea_id):
    tareas = cargar(ruta)
    for t in tareas:
        if t["id"] == tarea_id:
            t["estado"] = "completada"
            guardar(ruta, tareas)
            return f"Tarea {tarea_id} completada"
    return f"Tarea {tarea_id} no encontrada"


def eliminar(ruta, tarea_id):
    tareas = cargar(ruta)
    nuevas = [t for t in tareas if t["id"] != tarea_id]
    if len(nuevas) == len(tareas):
        return f"Tarea {tarea_id} no encontrada"
    guardar(ruta, nuevas)
    return f"Tarea {tarea_id} eliminada"


def main():
    parser = argparse.ArgumentParser(description="Gestor de tareas")
    sub = parser.add_subparsers(dest="comando", required=True)

    p_agregar = sub.add_parser("agregar")
    p_agregar.add_argument("descripcion")
    p_agregar.set_defaults(func=lambda a: print(agregar(ARCHIVO, a.descripcion)))

    p_listar = sub.add_parser("listar")
    p_listar.set_defaults(func=lambda a: print("\n".join(listar(ARCHIVO))))

    p_completar = sub.add_parser("completar")
    p_completar.add_argument("id", type=int)
    p_completar.set_defaults(func=lambda a: print(completar(ARCHIVO, a.id)))

    p_eliminar = sub.add_parser("eliminar")
    p_eliminar.add_argument("id", type=int)
    p_eliminar.set_defaults(func=lambda a: print(eliminar(ARCHIVO, a.id)))

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
````

</details>
