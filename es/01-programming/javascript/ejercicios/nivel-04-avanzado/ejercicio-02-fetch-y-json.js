const BASE = "https://jsonplaceholder.typicode.com/todos";

async function obtenerTodo(id) {
  // TODO: fetch(`${BASE}/${id}`), comprueba respuesta.ok y devuelve respuesta.json().
  throw new Error("TODO: implementar obtenerTodo(id)");
}

async function obtenerVarios() {
  // TODO: Promise.all de los todos 1, 2 y 3; devuelve el array.
  throw new Error("TODO: implementar obtenerVarios()");
}

if (require.main === module) {
  (async () => {
    try {
      const todo = await obtenerTodo(1);
      console.log(`Todo 1: "${todo.title}" - completado: ${todo.completed}`);
    } catch (error) {
      console.log(`Fallo: ${error.message}`);
    }
    try {
      const todos = await obtenerVarios();
      const completados = todos.filter((t) => t.completed).length;
      console.log(`Completados de los 3 primeros: ${completados}`);
    } catch (error) {
      console.log(`Fallo: ${error.message}`);
    }
  })();
}

module.exports = { obtenerTodo, obtenerVarios };
