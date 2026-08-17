# Ejercicio 04 — EventEmitter tipado

- **Nivel:** 5/5
- **Tema:** `node:events`, `EventEmitter<T>`, eventos tipados por nombre
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `event-emitter.ts` que:

1. Defina `interface EventosTarea { creada: [id: number, titulo: string]; completada: [id: number] }` (mapa de eventos → tupla de argumentos).
2. Defina `class ServicioTareas extends EventEmitter<EventosTarea>` con métodos `crear(titulo: string): number` (emite `"creada"`) y `completar(id: number): void` (emite `"completada"`).
3. Registre listeners con `.on("creada", (id, titulo) => ...)` y `.on("completada", (id) => ...)`.
4. Ejecute el flujo: crear dos tareas, completar una, y comprobar que los listeners tipados reciben los argumentos correctos.

Salida esperada (ejemplo):

```
creada: 1 - Comprar pan
creada: 2 - Estudiar TS
completada: 1
```

## Requisitos

- [ ] Importar `EventEmitter` desde `node:events`.
- [ ] Tipar los eventos con una interface `{ nombre: [args] }`.
- [ ] Usar `this.emit` con los argumentos de la tupla.
- [ ] Suscribirse con `.on` donde los parámetros del listener estén tipados.
- [ ] Ejecutarlo localmente con `npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist event-emitter.ts`, luego `node dist/event-emitter.js`, y verificar la salida.
- [ ] Nota: requiere `@types/node` instalado.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El genérico de `EventEmitter<T>` describe cada evento con su tupla de argumentos.
- `crear` asigna un id incremental y llama a `this.emit("creada", id, titulo)`.
- Los listeners reciben los argumentos tipados: `(id, titulo) => ...`.
- Con el mapa de eventos, emitir un evento no declarado (o con argumentos equivocados) es error de compilación.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist event-emitter.ts && node dist/event-emitter.js
import { EventEmitter } from "node:events";

interface EventosTarea {
  creada: [id: number, titulo: string];
  completada: [id: number];
}

class ServicioTareas extends EventEmitter<EventosTarea> {
  private contador = 0;

  crear(titulo: string): number {
    this.contador++;
    this.emit("creada", this.contador, titulo);
    return this.contador;
  }

  completar(id: number): void {
    this.emit("completada", id);
  }
}

const servicio = new ServicioTareas();

servicio.on("creada", (id, titulo) => {
  console.log(`creada: ${id} - ${titulo}`);
});

servicio.on("completada", (id) => {
  console.log(`completada: ${id}`);
});

servicio.crear("Comprar pan");
const segunda = servicio.crear("Estudiar TS");
servicio.completar(segunda);
````

</details>