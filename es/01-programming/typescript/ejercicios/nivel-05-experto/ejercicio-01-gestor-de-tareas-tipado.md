# Ejercicio 01 — Gestor de tareas tipado

- **Nivel:** 5/5
- **Tema:** modelos de dominio, uniones discriminadas, funciones de servicio tipadas
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `gestor-tareas.ts` que implemente un mini gestor de tareas en memoria:

1. Defina `interface Tarea` con `id: number`, `titulo: string`, `completada: boolean` y `prioridad: "alta" | "media" | "baja"`.
2. Defina `type TareaNueva = Omit<Tarea, "id" | "completada">`.
3. Defina un `type EstadoAccion = { ok: true; tarea: Tarea } | { ok: false; error: string }`.
4. Implemente un `GestorTareas` con métodos tipados:
   - `crear(datos: TareaNueva): Tarea` (asigna id incremental).
   - `listar(): Tarea[]`.
   - `completar(id: number): EstadoAccion` (devuelve `ok:false` si no existe).
   - `porPrioridad(p: Tarea["prioridad"]): Tarea[]`.
5. Ejecute un flujo completo: crear 3 tareas, listar, completar una, intentar completar una inexistente y filtrar por prioridad, imprimiendo resultados.

Salida esperada (ejemplo):

```
Creada: 1 - Comprar pan [pendiente]
Creada: 2 - Estudiar TS [pendiente]
Creada: 3 - Regar plantas [pendiente]
Lista: 3 tareas
Completada: 1
Error: No existe la tarea 99
Alta prioridad: 1 - Comprar pan
```

## Requisitos

- [ ] Modelar el dominio con `interface`, `type` y una unión discriminada para los resultados.
- [ ] Encapsular la lógica en una clase con métodos tipados.
- [ ] Usar `Tarea["prioridad"]` como tipo de parámetro.
- [ ] Manejar el caso de "no encontrado" con el estado `{ ok: false }`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist gestor-tareas.ts` y luego `node dist/gestor-tareas.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El id incremental es una propiedad privada de la clase: `private contador = 0;`.
- `completar` busca con `.find()`, si no lo encuentra devuelve `{ ok: false, error: "No existe la tarea " + id }`.
- `porPrioridad` filtra con `tarea.prioridad === p`.
- Para verificar el resultado de `completar`, usa narrowing `if (r.ok)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist gestor-tareas.ts && node dist/gestor-tareas.js
interface Tarea {
  id: number;
  titulo: string;
  completada: boolean;
  prioridad: "alta" | "media" | "baja";
}

type TareaNueva = Omit<Tarea, "id" | "completada">;

type EstadoAccion = { ok: true; tarea: Tarea } | { ok: false; error: string };

class GestorTareas {
  private tareas: Tarea[] = [];
  private contador = 0;

  crear(datos: TareaNueva): Tarea {
    this.contador++;
    const tarea: Tarea = { id: this.contador, ...datos, completada: false };
    this.tareas.push(tarea);
    return tarea;
  }

  listar(): Tarea[] {
    return [...this.tareas];
  }

  completar(id: number): EstadoAccion {
    const tarea = this.tareas.find((t) => t.id === id);
    if (!tarea) {
      return { ok: false, error: `No existe la tarea ${id}` };
    }
    tarea.completada = true;
    return { ok: true, tarea };
  }

  porPrioridad(p: Tarea["prioridad"]): Tarea[] {
    return this.tareas.filter((t) => t.prioridad === p);
  }
}

const gestor = new GestorTareas();
const t1 = gestor.crear({ titulo: "Comprar pan", prioridad: "alta" });
const t2 = gestor.crear({ titulo: "Estudiar TS", prioridad: "media" });
const t3 = gestor.crear({ titulo: "Regar plantas", prioridad: "baja" });

console.log(`Creada: ${t1.id} - ${t1.titulo} [${t1.completada ? "hecha" : "pendiente"}]`);
console.log(`Creada: ${t2.id} - ${t2.titulo} [${t2.completada ? "hecha" : "pendiente"}]`);
console.log(`Creada: ${t3.id} - ${t3.titulo} [${t3.completada ? "hecha" : "pendiente"}]`);

console.log(`Lista: ${gestor.listar().length} tareas`);

const r1 = gestor.completar(1);
if (r1.ok) {
  console.log(`Completada: ${r1.tarea.id}`);
}

const r2 = gestor.completar(99);
if (!r2.ok) {
  console.log(`Error: ${r2.error}`);
}

console.log(`Alta prioridad: ${gestor.porPrioridad("alta")[0].id} - ${gestor.porPrioridad("alta")[0].titulo}`);
````

</details>