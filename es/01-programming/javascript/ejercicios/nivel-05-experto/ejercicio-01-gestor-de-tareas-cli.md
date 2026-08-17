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

function leerTareas() {
  try {
    if (!fs.existsSync(ARCHIVO)) {
      fs.writeFileSync(ARCHIVO, "[]");
    }
    const contenido = fs.readFileSync(ARCHIVO, "utf-8");
    return JSON.parse(contenido);
  } catch (error) {
    console.error("Error al leer tareas:", error.message);
    return [];
  }
}

function guardarTareas(tareas) {
  fs.writeFileSync(ARCHIVO, JSON.stringify(tareas, null, 2));
}

function listar() {
  const tareas = leerTareas();
  if (tareas.length === 0) {
    console.log("No hay tareas.");
    return;
  }
  for (const tarea of tareas) {
    const estado = tarea.completada ? "[x]" : "[ ]";
    console.log(`${tarea.id}. ${estado} ${tarea.texto}`);
  }
}

function agregar(texto) {
  const tareas = leerTareas();
  const id = Math.max(0, ...tareas.map((t) => t.id)) + 1;
  tareas.push({ id, texto, completada: false });
  guardarTareas(tareas);
  console.log(`Tarea añadida con id ${id}: ${texto}`);
}

function completar(id) {
  const tareas = leerTareas();
  const tarea = tareas.find((t) => t.id === id);
  if (!tarea) {
    console.log(`No existe la tarea con id ${id}`);
    return;
  }
  tarea.completada = true;
  guardarTareas(tareas);
  console.log(`Tarea ${id} completada`);
}

function eliminar(id) {
  const tareas = leerTareas();
  const filtradas = tareas.filter((t) => t.id !== id);
  if (filtradas.length === tareas.length) {
    console.log(`No existe la tarea con id ${id}`);
    return;
  }
  guardarTareas(filtradas);
  console.log(`Tarea ${id} eliminada`);
}

const [comando, ...resto] = process.argv.slice(2);

switch (comando) {
  case "listar":
    listar();
    break;
  case "agregar":
    agregar(resto.join(" "));
    break;
  case "completar":
    completar(Number(resto[0]));
    break;
  case "eliminar":
    eliminar(Number(resto[0]));
    break;
  default:
    console.log(
      "Uso: node tareas.js <listar|agregar|completar|eliminar> ..."
    );
}
````

</details>