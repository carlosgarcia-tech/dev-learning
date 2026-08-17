const fs = require("node:fs");
const path = require("node:path");

const ARCHIVO = path.join(__dirname, "tareas.json");

function leerTareas(archivo) {
  // TODO: si no existe, créalo con "[]"; devuelve el array parseado.
  throw new Error("TODO: implementar leerTareas(archivo)");
}

function guardarTareas(archivo, tareas) {
  // TODO: escribe el array formateado en el archivo.
  throw new Error("TODO: implementar guardarTareas(archivo, tareas)");
}

function siguienteId(tareas) {
  // TODO: devuelve el máximo id existente + 1.
  throw new Error("TODO: implementar siguienteId(tareas)");
}

function agregarTarea(tareas, texto) {
  // TODO: devuelve { tareas, tarea } con la nueva tarea { id, texto, completada: false }.
  throw new Error("TODO: implementar agregarTarea(tareas, texto)");
}

function completarTarea(tareas, id) {
  // TODO: marca como completada la tarea con ese id; devuelve { tareas, encontrada }.
  throw new Error("TODO: implementar completarTarea(tareas, id)");
}

function eliminarTarea(tareas, id) {
  // TODO: filtra la tarea con ese id; devuelve { tareas, eliminada }.
  throw new Error("TODO: implementar eliminarTarea(tareas, id)");
}

function formatear(tareas) {
  // TODO: devuelve ["<id>. [ ] <texto>"] usando "[x]" si completada.
  throw new Error("TODO: implementar formatear(tareas)");
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
