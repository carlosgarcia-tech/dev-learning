# Ejercicio 06 — Mini proyecto: biblioteca tipada

- **Nivel:** 5/5
- **Tema:** módulos, API pública tipada, genéricos, uniones discriminadas, testing
- **Tiempo estimado:** 75 min

## Enunciado

Crea una **mini biblioteca** de colecciones con tipos, en **tres archivos**:

1. `src/biblioteca.ts` que exporte:
   - `interface Resultado<T> = { ok: true; valor: T } | { ok: false; error: string }`.
   - `type Elemento <T> = { id: string; valor: T }`.
   - `class Coleccion<T>` con `agregar(id, valor): Resultado<Elemento<T>>` (error si el id ya existe), `obtener(id): Resultado<Elemento<T>>`, `listar(): Elemento<T>[]` y `tamano(): number`.
2. `src/biblioteca.test.ts` que pruebe la biblioteca con `node:assert/strict`:
   - Agregar dos elementos y comprobar tamaño 2.
   - Obtener un elemento existente (`ok: true`).
   - Obtener uno inexistente (`ok: false`) con el mensaje de error.
   - Agregar un id duplicado y comprobar que falla.
3. `tsconfig.json` con `strict`, `rootDir: "src"`, `outDir: "dist"` y `module/moduleResolution: NodeNext`.

Salida esperada (ejemplo):

```
✓ tamaño es 2
✓ obtener existente devuelve 42
✓ obtener inexistente falla
✓ agregar duplicado falla
4 de 4 pruebas pasaron
```

## Requisitos

- [ ] Exportar la clase y los tipos desde `biblioteca.ts`.
- [ ] Tipar la clase con `<T>` y usar `Resultado<T>` en los retornos.
- [ ] Importar la clase con `import { Coleccion } from "./biblioteca.js";`.
- [ ] Escribir 4 pruebas con `assert.strictEqual` y narrowing sobre `Resultado`.
- [ ] Compilar todo con un único `tsconfig.json`.
- [ ] Ejecutarlo localmente con `npx tsc` y luego `node dist/biblioteca.test.js`, y verificar la salida.
- [ ] Nota: requiere `@types/node` instalado.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Internamente guarda un `Map<string, Elemento<T>>`; `agregar` comprueba `if (this.items.has(id)) return { ok: false, ... }`.
- Para `obtener`, usa `this.items.get(id)`; si es `undefined` devuelve `{ ok: false }`.
- En el test, estrecha con `if (r.ok) { r.valor.valor; }`.
- Los imports relativos llevan `.js` (NodeNext). El test importa solo de `./biblioteca.js`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`tsconfig.json`:

````json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"]
}
````

`src/biblioteca.ts`:

````typescript
export type Resultado<T> =
  | { ok: true; valor: T }
  | { ok: false; error: string };

export interface Elemento<T> {
  id: string;
  valor: T;
}

export class Coleccion<T> {
  private items = new Map<string, Elemento<T>>();

  agregar(id: string, valor: T): Resultado<Elemento<T>> {
    if (this.items.has(id)) {
      return { ok: false, error: `El id ${id} ya existe` };
    }
    const elemento: Elemento<T> = { id, valor };
    this.items.set(id, elemento);
    return { ok: true, valor: elemento };
  }

  obtener(id: string): Resultado<Elemento<T>> {
    const elemento = this.items.get(id);
    if (!elemento) {
      return { ok: false, error: `No existe el id ${id}` };
    }
    return { ok: true, valor: elemento };
  }

  listar(): Elemento<T>[] {
    return [...this.items.values()];
  }

  tamano(): number {
    return this.items.size;
  }
}
````

`src/biblioteca.test.ts`:

````typescript
// ejecutar con: npx tsc && node dist/biblioteca.test.js
import assert from "node:assert/strict";
import { Coleccion } from "./biblioteca.js";
import type { Resultado } from "./biblioteca.js";

const coleccion = new Coleccion<number>();

coleccion.agregar("a", 1);
coleccion.agregar("b", 42);

let pasadas = 0;
const total = 4;

try {
  assert.strictEqual(coleccion.tamano(), 2);
  pasadas++;
  console.log("✓ tamaño es 2");
} catch (e) {
  console.log(`✗ tamaño: ${e instanceof Error ? e.message : String(e)}`);
}

try {
  const r: Resultado<{ id: string; valor: number }> = coleccion.obtener("b");
  assert.ok(r.ok);
  if (r.ok) {
    assert.strictEqual(r.valor.valor, 42);
  }
  pasadas++;
  console.log("✓ obtener existente devuelve 42");
} catch (e) {
  console.log(`✗ obtener existente: ${e instanceof Error ? e.message : String(e)}`);
}

try {
  const r = coleccion.obtener("zz");
  assert.ok(!r.ok);
  if (!r.ok) {
    assert.match(r.error, /No existe/);
  }
  pasadas++;
  console.log("✓ obtener inexistente falla");
} catch (e) {
  console.log(`✗ obtener inexistente: ${e instanceof Error ? e.message : String(e)}`);
}

try {
  const r = coleccion.agregar("a", 999);
  assert.ok(!r.ok);
  pasadas++;
  console.log("✓ agregar duplicado falla");
} catch (e) {
  console.log(`✗ agregar duplicado: ${e instanceof Error ? e.message : String(e)}`);
}

console.log(`${pasadas} de ${total} pruebas pasaron`);
````

</details>