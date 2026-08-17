# 04 — Async/await tipado

## Objetivos

- [ ] Tipar `Promise<T>` y funciones `async` correctamente.
- [ ] Manejar rechazos de forma tipada con `try/catch`.
- [ ] Tipar llamadas `fetch` y la deserialización de respuestas.
- [ ] Usar **aserciones de tipo** (`as`, `as const`, `satisfies`) con criterio.
- [ ] Aplicar **narrowing** para trabajar con uniones en flujos asíncronos.
- [ ] Escribir utilidades async reutilizables (`Promise.all`, `await` en bucles).

## Apuntes

### `Promise<T>` y funciones async

Una promesa tipada es `Promise<T>`: el "contenedor" de un valor futuro de tipo `T`.

```typescript
function esperar(ms: number): Promise<number> {
  return new Promise((resolve) => setTimeout(() => resolve(ms), ms));
}

async function iniciar(): Promise<string> {
  const t = await esperar(100);
  return `Esperado ${t} ms`;
}
```

- Una función `async` **siempre** devuelve una `Promise`; si anotas `async`, el retorno debe ser `Promise<...>`, no el valor "pelado".
- `await` extrae el valor `T` de una `Promise<T>`.
- Con `--strict`, `await` sobre algo no-promesificable da error; usa `await Promise.resolve(valor)` si necesitas forzar.

### Errores y rechazos tipados

`catch` recibe `unknown` (con `--strict`), por lo que hay que hacer narrowing antes de usarlo. El clásico patrón "resultado o error" evita toda esa incertidumbre:

```typescript
type Resultado<T> = { ok: true; valor: T } | { ok: false; error: string };

async function segura<T>(fn: () => Promise<T>): Promise<Resultado<T>> {
  try {
    return { ok: true, valor: await fn() };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : "Error desconocido" };
  }
}

const r = await segura(() => esperar(10));
if (r.ok) {
  console.log(r.valor); // number
} else {
  console.error(r.error); // string
}
```

### Fetch tipado

`fetch` devuelve `Promise<Response>`. El JSON deserializado es `any` o `unknown` según la configuración; lo correcto es **validar la forma esperada** o usar una aserción cuidadosa:

```typescript
interface Usuario {
  id: number;
  nombre: string;
  email: string;
}

async function obtenerUsuarios(): Promise<Usuario[]> {
  const resp = await fetch("https://api.example.com/usuarios");
  if (!resp.ok) {
    throw new Error(`HTTP ${resp.status}`);
  }
  const datos = (await resp.json()) as Usuario[];
  return datos;
}
```

La aserción `as Usuario[]` "le dice" al compilador el tipo. No valida nada en runtime: si la API devuelve otra cosa, obtendrás datos con la forma equivocada. Para validación real, combínala con guardas o una librería de validación.

### Guardas de tipo y narrowing

Una **guard type** es una función que devuelve un predicado de tipo (`valor is T`) y que el compilador usa para estrechar.

```typescript
function esUsuario(valor: unknown): valor is Usuario {
  if (typeof valor !== "object" || valor === null) return false;
  const v = valor as Record<string, unknown>;
  return typeof v.id === "number" && typeof v.nombre === "string";
}
```

```typescript
async function cargar(id: string): Promise<Usuario | null> {
  const resp = await fetch(`https://api.example.com/usuarios/${id}`);
  if (!resp.ok) return null;
  const datos: unknown = await resp.json();
  return esUsuario(datos) ? datos : null;
}
```

El **narrowing** también funciona dentro de un `switch` sobre un discriminante, con `typeof`, `instanceof` y comprobaciones de propiedad.

### `as const` y `satisfies`

- `as const` congela un literal: sus propiedades se vuelven `readonly` y de tipo literal exacto.

```typescript
const config = {
  baseUrl: "https://api.example.com",
  version: 2,
} as const;

// config.baseUrl: "https://api.example.com" (literal), readonly
```

- `satisfies` comprueba que un valor cumple un tipo **sin** reemplazar el tipo inferido.

```typescript
type Colores = "rojo" | "verde" | "azul";

const paleta = {
  principal: "rojo",
  secundario: "verde",
} satisfies Record<string, Colores>;
```

### `Promise.all` y concurrencia tipada

`Promise.all` tipa el resultado como una tupla de los tipos individuales:

```typescript
async function enParalelo(): Promise<[number, string, boolean]> {
  const [a, b, c] = await Promise.all([
    esperar(10),
    Promise.resolve("texto"),
    Promise.resolve(true),
  ]);
  return [a, b, c];
}
```

Evita `await` en bucles cuando las tareas son independientes; lanza todas las promesas con `map` + `Promise.all`.

```typescript
async function procesarTodo(ids: string[]): Promise<Usuario[]> {
  const promesas = ids.map((id) => cargar(id));
  const resultado = await Promise.all(promesas);
  return resultado.filter((u): u is Usuario => u !== null);
}
```

## Ejemplos de código

```typescript
// Fetch con resultado-or-error tipado
interface Producto {
  id: number;
  nombre: string;
  precio: number;
}

async function buscarProducto(id: number): Promise<Producto | null> {
  const resp = await fetch(`https://api.example.com/productos/${id}`);
  if (!resp.ok) return null;
  const datos = (await resp.json()) as Producto;
  return datos;
}

const producto = await buscarProducto(1);
console.log(producto ? producto.nombre : "No encontrado");
```

```typescript
// Patrón Resultado<T> reutilizable
type Resultado<T> = { ok: true; valor: T } | { ok: false; error: string };

async function intentar<T>(fn: () => Promise<T>): Promise<Resultado<T>> {
  try {
    return { ok: true, valor: await fn() };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : "desconocido" };
  }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/) (narrowing y aserciones)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/) (async tipado)

## Errores comunes

- **Anotar `async` con retorno no-promesa** → una función `async` devuelve `Promise<T>`, no `T`.
- **Olvidar el `await`** → `const x = esperar(10)` da una `Promise<number>`, no `number`.
- **`catch` con `any` implícito** → con `--strict`, `e` es `unknown`; haz narrowing antes de usarlo.
- **Aserción `as` a ciegas** → `as Usuario` no valida runtime; valida con guardas si la entrada no es de fiar.
- **Rechazos no manejados** → un `Promise.all` con una promesa que falla rechaza todo; usa `allSettled` si alguna puede fallar.
- **Usar `as const` donde no toca** → congela el tipo y puede impedir reasignaciones que sí quieres permitir.

## Recursos

- [TypeScript — Promesas](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#return-type-annotations)
- [TypeScript — Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
- [MDN — fetch](https://developer.mozilla.org/es/docs/Web/API/Fetch_API)
- [Documentación oficial en español](https://www.typescriptlang.org/es/docs/)