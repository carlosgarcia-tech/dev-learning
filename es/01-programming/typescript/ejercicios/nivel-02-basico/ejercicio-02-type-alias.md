# Ejercicio 02 — Type alias

- **Nivel:** 2/5
- **Tema:** `type`, uniones, tuplas con alias, composición con `&`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `type-alias.ts` que:

1. Defina un `type Id = string | number`.
2. Defina un `type Coordenadas = [x: number, y: number]` (tupla con nombre).
3. Defina un `type Direccion` con las literales `"norte" | "sur" | "este" | "oeste"`.
4. Defina un `type Navegable` que combine un objeto base (`{ id: Id; direccion: Direccion }`) con otro (`{ velocidad: number }`) usando `&`.
5. Escriba `avanzar(n: Navegable): void` que imprima la dirección y la nueva posición, y ejecútela con un objeto de ejemplo.

Salida esperada (ejemplo):

```
Nave 123: hacia norte, velocidad 10
Nueva posicion: (5, 10)
```

## Requisitos

- [ ] Definir al menos 3 `type` alias (unión, tupla, literal).
- [ ] Componer dos tipos de objeto con intersección `&`.
- [ ] Usar el alias `Id` en un parámetro.
- [ ] Imprimir el avance usando la tupla `Coordenadas`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist type-alias.ts` y luego `node dist/type-alias.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Tupla con etiquetas: `type Coordenadas = [x: number, y: number];`.
- Intersección: `type Navegable = { id: Id; direccion: Direccion } & { velocidad: number };`.
- Para mover: `pos[0] += 5; pos[1] += n.velocidad;`.
- Recuerda que los `type` no se extienden con `extends`; se combinan con `&`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist type-alias.ts && node dist/type-alias.js
type Id = string | number;
type Coordenadas = [x: number, y: number];
type Direccion = "norte" | "sur" | "este" | "oeste";

type Navegable = { id: Id; direccion: Direccion } & { velocidad: number };

function avanzar(n: Navegable, pos: Coordenadas): void {
  if (n.direccion === "norte") {
    pos[1] += n.velocidad;
  } else if (n.direccion === "sur") {
    pos[1] -= n.velocidad;
  } else if (n.direccion === "este") {
    pos[0] += n.velocidad;
  } else {
    pos[0] -= n.velocidad;
  }
  console.log(`Nave ${n.id}: hacia ${n.direccion}, velocidad ${n.velocidad}`);
  console.log(`Nueva posicion: (${pos[0]}, ${pos[1]})`);
}

const nave: Navegable = { id: 123, direccion: "norte", velocidad: 10 };
avanzar(nave, [0, 0]);
````

</details>