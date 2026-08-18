# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** argparse, json, persistencia, CRUD
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `gestor_tareas.py` que implemente un gestor de tareas de consola con persistencia en `tareas.json`. Comandos con `argparse`:

- `agregar "descripción"` → añade una tarea con id autoincremental y estado `pendiente`.
- `listar` → muestra todas las tareas como `[id] estado — descripción`.
- `completar <id>` → marca la tarea como `completada`.
- `eliminar <id>` → elimina la tarea.

Cada tarea es un diccionario `{"id": int, "descripcion": str, "estado": str}`. Los datos se leen al inicio (si el archivo no existe, empieza con `[]`) y se guardan tras cada mutación con `json.dump`.

Ejemplo de uso y salida:

```
$ python3 gestor_tareas.py agregar "Comprar pan"
Tarea 1 añadida
$ python3 gestor_tareas.py agregar "Estudiar Python"
Tarea 2 añadida
$ python3 gestor_tareas.py listar
[1] pendiente — Comprar pan
[2] pendiente — Estudiar Python
$ python3 gestor_tareas.py completar 1
Tarea 1 completada
$ python3 gestor_tareas.py eliminar 2
Tarea 2 eliminada
```

## Requisitos

- [ ] Usar `argparse` con subcomandos (`add_subparsers`).
- [ ] Leer `tareas.json` al inicio con manejo de archivo inexistente.
- [ ] Guardar en `tareas.json` tras cada mutación.
- [ ] Validar que el id exista al completar/eliminar (si no, imprimir un error).
- [ ] Ejecutar la secuencia de comandos de ejemplo y verificar la salida.

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


def cargar():
    if not os.path.exists(ARCHIVO):
        return []
    with open(ARCHIVO, "r", encoding="utf-8") as f:
        return json.load(f)


def guardar(tareas):
    with open(ARCHIVO, "w", encoding="utf-8") as f:
        json.dump(tareas, f, ensure_ascii=False, indent=2)


def agregar(descripcion):
    tareas = cargar()
    nuevo_id = max((t["id"] for t in tareas), default=0) + 1
    tareas.append({"id": nuevo_id, "descripcion": descripcion, "estado": "pendiente"})
    guardar(tareas)
    print(f"Tarea {nuevo_id} añadida")


def listar():
    tareas = cargar()
    for t in tareas:
        print(f"[{t['id']}] {t['estado']} — {t['descripcion']}")


def completar(tarea_id):
    tareas = cargar()
    for t in tareas:
        if t["id"] == tarea_id:
            t["estado"] = "completada"
            guardar(tareas)
            print(f"Tarea {tarea_id} completada")
            return
    print(f"Tarea {tarea_id} no encontrada")


def eliminar(tarea_id):
    tareas = cargar()
    nuevas = [t for t in tareas if t["id"] != tarea_id]
    if len(nuevas) == len(tareas):
        print(f"Tarea {tarea_id} no encontrada")
        return
    guardar(nuevas)
    print(f"Tarea {tarea_id} eliminada")


parser = argparse.ArgumentParser(description="Gestor de tareas")
sub = parser.add_subparsers(dest="comando", required=True)

p_agregar = sub.add_parser("agregar")
p_agregar.add_argument("descripcion")
p_agregar.set_defaults(func=lambda a: agregar(a.descripcion))

p_listar = sub.add_parser("listar")
p_listar.set_defaults(func=lambda a: listar())

p_completar = sub.add_parser("completar")
p_completar.add_argument("id", type=int)
p_completar.set_defaults(func=lambda a: completar(a.id))

p_eliminar = sub.add_parser("eliminar")
p_eliminar.add_argument("id", type=int)
p_eliminar.set_defaults(func=lambda a: eliminar(a.id))

args = parser.parse_args()
args.func(args)
````

</details>