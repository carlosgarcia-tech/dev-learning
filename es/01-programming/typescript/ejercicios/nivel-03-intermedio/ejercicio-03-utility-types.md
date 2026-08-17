# Ejercicio 03 — Utility types

- **Nivel:** 3/5
- **Tema:** `Partial`, `Pick`, `Omit`, `Readonly`, `Record`, `Exclude`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `utility-types.ts` que:

1. Defina `interface Tarea` con `id`, `titulo`, `completada` y `prioridad` (`"alta" | "media" | "baja"`).
2. Declare un `type TareaNueva = Omit<Tarea, "id" | "completada">`.
3. Declare un `type TareaParcial = Partial<Tarea>`.
4. Declare un `type TareaSoloTitulo = Pick<Tarea, "titulo">`.
5. Declare un `type TareaCongelada = Readonly<Tarea>`.
6. Declare un `type PrioridadSinMedia = Exclude<Tarea["prioridad"], "media">`.
7. Use un `Record<string, Tarea>` para un mapa de tareas por id, y aplique `Partial` para "actualizar" una tarea. Imprima resultados.

Salida esperada (ejemplo):

```
Nueva: { titulo: Comprar pan, prioridad: alta }
Parcial: { titulo: Actualizar }
Solo titulo: { titulo: Leer }
Congelada compila: Leer
Prioridades sin media: alta|baja
Mapa: Comprar pan
```

## Requisitos

- [ ] Usar al menos 5 utility types distintos (`Omit`, `Partial`, `Pick`, `Readonly`, `Exclude`, `Record`).
- [ ] Componer `Omit` con el acceso `Tarea["prioridad"]`.
- [ ] Usar un objeto `Record<string, Tarea>`.
- [ ] Intentar (en comentario) modificar una propiedad de `Readonly`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist utility-types.ts` y luego `node dist/utility-types.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Omit<Tarea, "id" | "completada">` quita dos claves a la vez.
- `Exclude<Tarea["prioridad"], "media">` quita `"media"` de la unión de prioridades.
- `Record<string, Tarea>` requiere un valor completo por clave.
- Para "actualizar" una tarea usa `{ ...tarea, ...cambios }` con `cambios: Partial<Tarea>`.
- `Readonly` no se puede reasignar; pon el intento en comentario: `// congelada.titulo = "otro"; // ERROR`.
- Los `type` (como `PrioridadSinMedia`) se borran al compilar: **no se pueden imprimir** en runtime. Demuestra que funciona asignándolo a una variable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist utility-types.ts && node dist/utility-types.js
interface Tarea {
  id: number;
  titulo: string;
  completada: boolean;
  prioridad: "alta" | "media" | "baja";
}

type TareaNueva = Omit<Tarea, "id" | "completada">;
type TareaParcial = Partial<Tarea>;
type TareaSoloTitulo = Pick<Tarea, "titulo">;
type TareaCongelada = Readonly<Tarea>;
type PrioridadSinMedia = Exclude<Tarea["prioridad"], "media">;

const nueva: TareaNueva = { titulo: "Comprar pan", prioridad: "alta" };
const cambios: TareaParcial = { titulo: "Actualizar" };
const soloTitulo: TareaSoloTitulo = { titulo: "Leer" };

const tareaBase: Tarea = { id: 1, titulo: "Leer", completada: false, prioridad: "media" };
const congelada: TareaCongelada = tareaBase;
// congelada.titulo = "otro"; // ERROR: readonly

const mapa: Record<string, Tarea> = {
  "1": { ...tareaBase, ...cambios },
};

const sinMedia: PrioridadSinMedia = "alta";
// const invalida: PrioridadSinMedia = "media"; // ERROR: "media" fue excluida

console.log(`Nueva: ${JSON.stringify(nueva)}`);
console.log(`Parcial: ${JSON.stringify(cambios)}`);
console.log(`Solo titulo: ${JSON.stringify(soloTitulo)}`);
console.log(`Congelada compila: ${congelada.titulo}`);
console.log(`Prioridades sin media compila con: ${sinMedia}`);
console.log(`Mapa: ${mapa["1"].titulo}`);
````

</details>