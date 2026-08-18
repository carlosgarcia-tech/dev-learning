const { test } = require("node:test");
const assert = require("node:assert/strict");
const { obtenerTodo, obtenerVarios } = require("./index");

test("obtenerTodo procesa el JSON de la respuesta", async () => {
  globalThis.fetch = async (url) => ({
    ok: true,
    status: 200,
    json: async () => ({ id: 1, title: "delectus aut autem", completed: false }),
  });
  const todo = await obtenerTodo(1);
  assert.equal(todo.title, "delectus aut autem");
  assert.equal(todo.completed, false);
});

test("obtenerTodo lanza error si la respuesta no es ok", async () => {
  globalThis.fetch = async () => ({ ok: false, status: 404 });
  await assert.rejects(obtenerTodo(1), /HTTP 404/);
});

test("obtenerVarios usa Promise.all con los 3 primeros", async () => {
  globalThis.fetch = async (url) => {
    const id = Number(url.split("/").pop());
    return {
      ok: true,
      status: 200,
      json: async () => ({ id, title: `todo ${id}`, completed: id === 2 }),
    };
  };
  const todos = await obtenerVarios();
  assert.equal(todos.length, 3);
  assert.equal(todos.filter((t) => t.completed).length, 1);
});
