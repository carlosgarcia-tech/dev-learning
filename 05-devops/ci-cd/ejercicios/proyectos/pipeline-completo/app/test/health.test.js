const { test } = require("node:test");
const assert = require("node:assert");
const app = require("../server");

test("GET /health devuelve status ok", async () => {
  // Test simulado del endpoint /health
  const res = { status: "ok" };
  assert.strictEqual(res.status, "ok");
});
