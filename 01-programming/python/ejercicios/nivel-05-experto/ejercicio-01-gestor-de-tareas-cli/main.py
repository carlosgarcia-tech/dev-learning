# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import argparse
import json
import os

ARCHIVO = "tareas.json"


def cargar(ruta):
    # TODO: devuelve [] si el archivo no existe; si no, json.load(ruta)
    raise NotImplementedError


def guardar(ruta, tareas):
    # TODO: escribe tareas en ruta con json.dump(..., ensure_ascii=False, indent=2)
    raise NotImplementedError


def agregar(ruta, descripcion):
    # TODO: id autoincremental, crea {"id", "descripcion", "estado": "pendiente"}
    # y devuelve f"Tarea {nuevo_id} añadida"
    raise NotImplementedError


def listar(ruta):
    # TODO: devuelve [f"[{t['id']}] {t['estado']} — {t['descripcion']}" for t in ...]
    raise NotImplementedError


def completar(ruta, tarea_id):
    # TODO: marca como completada, persiste y devuelve f"Tarea {tarea_id} completada"
    # o f"Tarea {tarea_id} no encontrada"
    raise NotImplementedError


def eliminar(ruta, tarea_id):
    # TODO: filtra por id, persiste y devuelve f"Tarea {tarea_id} eliminada"
    # o f"Tarea {tarea_id} no encontrada"
    raise NotImplementedError


def main():
    # TODO: CLI con argparse y add_subparsers (agregar, listar, completar, eliminar)
    raise NotImplementedError


if __name__ == "__main__":
    main()