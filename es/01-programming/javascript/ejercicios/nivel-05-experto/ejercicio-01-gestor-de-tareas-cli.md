# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** Mini app CLI con archivo JSON
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `tareas.js` que sea una app CLI para gestionar tareas persistidas en un archivo JSON (`tareas.json`). Comandos:

- `node tareas.js listar` — muestra todas las tareas con su estado `[x]` o `[ ]`.
- `node tareas.js agregar "<texto>"` — añade una tarea nueva (no completada) y guarda en el archivo.
- `node tareas.js completar <id>` — marca la tarea con ese id como completada.
- `node tareas.js eliminar <id>` — elimina la tarea con ese id.
- Sin comandos → imprime las instrucciones de uso.

Características:
- Los datos se guardan como un array de objetos `{ id, texto, completada }` en `tareas.json`.
- El `id` se asigna incrementalmente (máximo id existente + 1).
- Usa los módulos `node:fs` y `node:path`.
- Si el archivo no existe, el programa debe crearlo con `[]` la primera vez.

Salida esperada (ejemplo):

```
$ node tareas.js agregar "Estudiar JavaScript"
Tarea añadida con id 1: Estudiar JavaScript
$ node tareas.js agregar "Hacer ejercicios"
Tarea añadida con id 2: Hacer ejercicios
$ node tareas.js listar
1. [ ] Estudiar JavaScript
2. [ ] Hacer ejercicios
$ node tareas.js completar 1
Tarea 1 completada
$ node tareas.js listar
1. [x] Estudiar JavaScript
2. [ ] Hacer ejercicios
$ node tareas.js eliminar 2
Tarea 2 eliminada
$ node tareas.js listar
1. [x] Estudiar JavaScript
```

## Requisitos

- [ ] Leer y escribir `tareas.json` con `node:fs`.
- [ ] Implementar los 4 comandos (listar, agregar, completar, eliminar).
- [ ] Crear el archivo con `[]` si no existe.
- [ ] Manejar errores de lectura/escritura con try/catch.
- [ ] Ejecutarlo localmente con `node tareas.js` y verificar los comandos.
- [ ] Los tests pasan: `node --test ejercicio-01-gestor-de-tareas-cli.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `require("node:fs")` y `require("node:path")`.
- Lee con `fs.existsSync` + `fs.readFileSync`, escribe con `fs.writeFileSync`.
- `JSON.parse` para leer y `JSON.stringify(data, null, 2)` para escribir formateado.
- `process.argv.slice(2)` para los comandos.
- Para el id: `Math.max(0, ...tareas.map((t) => t.id)) + 1`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const fs = require("node:fs");
const path = require("node:path");

const ARCHIVO = path.join(__dirname, "tareas.json");

function leerTareas(archivo) {
  if (!fs.existsSync(archivo)) {
    fs.writeFileSync(archivo, "[]");
  }
  const contenido = fs.readFileSync(archivo, "utf-8");
  return JSON.parse(contenido);
}

function guardarTareas(archivo, tareas) {
  fs.writeFileSync(archivo, JSON.stringify(tareas, null, 2));
}

function siguienteId(tareas) {
  return Math.max(0, ...tareas.map((t) => t.id)) + 1;
}

function agregarTarea(tareas, texto) {
  const tarea = { id: siguienteId(tareas), texto, completada: false };
  return { tareas: [...tareas, tarea], tarea };
}

function completarTarea(tareas, id) {
  const tarea = tareas.find((t) => t.id === id);
  if (!tarea) {
    return { tareas, encontrada: false };
  }
  const modificadas = tareas.map((t) => (t.id === id ? { ...t, completada: true } : t));
  return { tareas: modificadas, encontrada: true };
}

function eliminarTarea(tareas, id) {
  const filtradas = tareas.filter((t) => t.id !== id);
  return { tareas: filtradas, eliminada: filtradas.length !== tareas.length };
}

function formatear(tareas) {
  return tareas.map((t) => `${t.id}. ${t.completada ? "[x]" : "[ ]"} ${t.texto}`);
}

if (require.main === module) {
  const [comando, ...resto] = process.argv.slice(2);
  let tareas = leerTareas(ARCHIVO);

  switch (comando) {
    case "listar": {
      if (tareas.length === 0) {
        console.log("No hay tareas.");
        break;
      }
      for (const linea of formatear(tareas)) console.log(linea);
      break;
    }
    case "agregar": {
      const resultado = agregarTarea(tareas, resto.join(" "));
      guardarTareas(ARCHIVO, resultado.tareas);
      console.log(`Tarea añadida con id ${resultado.tarea.id}: ${resultado.tarea.texto}`);
      break;
    }
    case "completar": {
      const resultado = completarTarea(tareas, Number(resto[0]));
      if (!resultado.encontrada) {
        console.log(`No existe la tarea con id ${resto[0]}`);
        break;
      }
      guardarTareas(ARCHIVO, resultado.tareas);
      console.log(`Tarea ${resto[0]} completada`);
      break;
    }
    case "eliminar": {
      const resultado = eliminarTarea(tareas, Number(resto[0]));
      if (!resultado.eliminada) {
        console.log(`No existe la tarea con id ${resto[0]}`);
        break;
      }
      guardarTareas(ARCHIVO, resultado.tareas);
      console.log(`Tarea ${resto[0]} eliminada`);
      break;
    }
    default:
      console.log("Uso: node tareas.js <listar|agregar|completar|eliminar> ...");
  }
}

module.exports = {
  ARCHIVO,
  leerTareas,
  guardarTareas,
  siguienteId,
  agregarTarea,
  completarTarea,
  eliminarTarea,
  formatear,
};
````

</details>