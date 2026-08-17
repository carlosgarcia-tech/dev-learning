# Ejercicio 05 — Sistema de tipos complejo

- **Nivel:** 5/5
- **Tema:** mapped types + conditional types + `infer` combinados, `satisfies`
- **Tiempo estimado:** 60 min

## Enunciado

Crea un archivo `tipos-complejos.ts` que construya un sistema de tipos encadenado:

1. Defina `interface Evento { tipo: string; datos: unknown }`.
2. Defina un **mapa de eventos**: `interface MapaEventos { usuario: { id: number }; pago: { importe: number; moneda: string }; log: { mensaje: string } }`.
3. Defina `type EventoDe<K extends keyof MapaEventos> = { tipo: K; datos: MapaEventos[K] }` (usa indexado).
4. Defina `type Eventos = { [K in keyof MapaEventos]: EventoDe<K> }` (mapped type).
5. Defina `type UnEvento = Eventos[keyof MapaEventos]` (unión de todos los eventos tipados).
6. Escriba `type ExtraerEvento<T extends { tipo: string }> = T extends { tipo: infer K } ? (K extends keyof MapaEventos ? EventoDe<K> : never) : never` usando `infer` y condicionales.
7. Escriba `emitir(e: UnEvento): void` que con un `switch` sobre `e.tipo` acceda a los datos específicos de cada evento y los imprima.
8. Compruebe que construir un evento con datos equivocados es error de compilación (en comentario).

Salida esperada (ejemplo):

```
usuario -> id 42
pago -> importe 99.9 moneda EUR
log -> mensaje Hola
```

## Requisitos

- [ ] Usar indexado `MapaEventos[K]` y `Eventos[keyof MapaEventos]`.
- [ ] Usar un mapped type para construir `Eventos`.
- [ ] Usar `infer` en un conditional type anidado.
- [ ] Usar `switch` con narrowing por discriminante sobre la unión tipada.
- [ ] Incluir en comentario un evento mal tipado.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist tipos-complejos.ts`, luego `node dist/tipos-complejos.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Eventos[keyof MapaEventos]` "abre" el mapped type y produce la unión de `EventoDe<K>`.
- En `emitir`, `switch (e.tipo)` estrecha `e` a cada variante y permite acceder a `e.datos.id` o `e.datos.importe`.
- `infer K` captura el literal de `tipo` para re-buscar el evento en el mapa.
- Ejemplo inválido en comentario: `// const mal: EventoDe<"pago"> = { tipo: "pago", datos: { id: 1 } }; // ERROR: datos debe tener importe`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist tipos-complejos.ts && node dist/tipos-complejos.js
interface MapaEventos {
  usuario: { id: number };
  pago: { importe: number; moneda: string };
  log: { mensaje: string };
}

type EventoDe<K extends keyof MapaEventos> = { tipo: K; datos: MapaEventos[K] };

type Eventos = { [K in keyof MapaEventos]: EventoDe<K> };

type UnEvento = Eventos[keyof MapaEventos];

type ExtraerEvento<T extends { tipo: string }> = T extends { tipo: infer K }
  ? K extends keyof MapaEventos
    ? EventoDe<K>
    : never
  : never;

function emitir(e: UnEvento): void {
  switch (e.tipo) {
    case "usuario":
      console.log(`usuario -> id ${e.datos.id}`);
      break;
    case "pago":
      console.log(`pago -> importe ${e.datos.importe} moneda ${e.datos.moneda}`);
      break;
    case "log":
      console.log(`log -> mensaje ${e.datos.mensaje}`);
      break;
  }
}

const eventos: UnEvento[] = [
  { tipo: "usuario", datos: { id: 42 } },
  { tipo: "pago", datos: { importe: 99.9, moneda: "EUR" } },
  { tipo: "log", datos: { mensaje: "Hola" } },
];

// Evento mal tipado (no compila):
// const mal: EventoDe<"pago"> = { tipo: "pago", datos: { id: 1 } };

const extraido: ExtraerEvento<{ tipo: "usuario" }> = { tipo: "usuario", datos: { id: 7 } };
emitir(extraido);

for (const evento of eventos) {
  emitir(evento);
}
````

</details>