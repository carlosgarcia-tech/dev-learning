# Ejercicio 01 — Async tipado

- **Nivel:** 4/5
- **Tema:** `Promise<T>`, funciones async, `Promise.all`, patrones de error tipados
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `async-tipado.ts` que:

1. Escriba `esperar(ms: number): Promise<number>` que resuelva con los ms transcurridos tras un `setTimeout`.
2. Escriba `obtenerUsuario(id: number): Promise<Usuario>` que espere 50 ms y devuelva un objeto `Usuario` (`{ id, nombre }`) de una tabla fija, o **lance** un error si el id no existe.
3. Escriba `cargarVarios(ids: number[]): Promise<Usuario[]>` usando `Promise.all`.
4. Defina el patrón `type Resultado<T> = { ok: true; valor: T } | { ok: false; error: string }` y un helper `capturar<T>(p: Promise<T>): Promise<Resultado<T>>` que atrape el rechazo.
5. Pruebe un caso que resuelve, uno que rechaza y uno con `Promise.all`, imprimiendo resultados con narrowing sobre `Resultado`.

Salida esperada (ejemplo):

```
Usuario 1: Ana
Resultado ok: Ana
Resultado error: Usuario 3 no encontrado
Varios: [Ana, Luis, Marta]
```

## Requisitos

- [ ] Tipar el retorno de `esperar` como `Promise<number>`.
- [ ] Lanzar un error tipado desde una función async y capturarlo con el patrón `Resultado<T>`.
- [ ] Usar `Promise.all` con retorno tipado `Promise<Usuario[]>`.
- [ ] Hacer narrowing sobre `Resultado<T>` (con `if (r.ok)`).
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist async-tipado.ts` y luego `node dist/async-tipado.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new Promise<number>((resolve) => setTimeout(() => resolve(ms), ms))`.
- En `obtenerUsuario`, si el id no está: `throw new Error("Usuario X no encontrado");`.
- `Promise.all` con `ids.map((id) => obtenerUsuario(id))`.
- `capturar` con try/catch: `catch (e) { return { ok: false, error: e instanceof Error ? e.message : "desconocido" }; }`.
- En Node, `setTimeout` usa `ReturnType<typeof setTimeout>`; aquí no hace falta guardarlo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist async-tipado.ts && node dist/async-tipado.js
interface Usuario {
  id: number;
  nombre: string;
}

const tabla: Record<number, string> = { 1: "Ana", 2: "Luis", 3: "Marta" };

function esperar(ms: number): Promise<number> {
  return new Promise((resolve) => setTimeout(() => resolve(ms), ms));
}

async function obtenerUsuario(id: number): Promise<Usuario> {
  await esperar(50);
  const nombre = tabla[id];
  if (!nombre) {
    throw new Error(`Usuario ${id} no encontrado`);
  }
  return { id, nombre };
}

type Resultado<T> = { ok: true; valor: T } | { ok: false; error: string };

async function capturar<T>(p: Promise<T>): Promise<Resultado<T>> {
  try {
    return { ok: true, valor: await p };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : "desconocido" };
  }
}

async function cargarVarios(ids: number[]): Promise<Usuario[]> {
  const promesas = ids.map((id) => obtenerUsuario(id));
  return Promise.all(promesas);
}

async function main(): Promise<void> {
  const usuario1 = await obtenerUsuario(1);
  console.log(`Usuario 1: ${usuario1.nombre}`);

  const r1 = await capturar(obtenerUsuario(1));
  if (r1.ok) {
    console.log(`Resultado ok: ${r1.valor.nombre}`);
  }

  const r2 = await capturar(obtenerUsuario(99));
  if (!r2.ok) {
    console.log(`Resultado error: ${r2.error}`);
  }

  const varios = await cargarVarios([1, 2, 3]);
  console.log(`Varios: ${varios.map((u) => u.nombre).join(", ")}`);
}

main();
````

</details>