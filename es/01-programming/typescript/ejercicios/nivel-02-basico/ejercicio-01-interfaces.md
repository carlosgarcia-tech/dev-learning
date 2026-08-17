# Ejercicio 01 — Interfaces

- **Nivel:** 2/5
- **Tema:** `interface`, propiedades opcionales, readonly, métodos
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `interfaces.ts` que:

1. Defina una `interface Producto` con `id: number`, `nombre: string`, `precio: number` y `stock?: number` (opcional).
2. Defina una `interface DetalleProducto extends Producto` que añada `descripcion: string` y una propiedad `readonly fechaCreacion: string`.
3. Declare una función `resumen(p: Producto): string` que devuelva un texto con nombre y precio.
4. Cree un objeto de tipo `DetalleProducto` y otro de tipo `Producto`, e imprima sus resúmenes.
5. Intente (en comentario) reasignar `fechaCreacion` para mostrar el error de `readonly`.

Salida esperada (ejemplo):

```
Teclado - 29.99 USD
Mouse - 9.5 USD
Detalle: Teclado mecanico, creado el 2026-01-15
```

## Requisitos

- [ ] Definir una interfaz base con al menos una propiedad opcional (`?`).
- [ ] Extenderla con `extends` añadiendo una propiedad `readonly`.
- [ ] Tipar el parámetro de una función con una interfaz.
- [ ] Incluir en comentario el intento de reasignar la propiedad `readonly`.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist interfaces.ts` y luego `node dist/interfaces.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Opcional: `stock?: number;`.
- Heredar: `interface DetalleProducto extends Producto { ... }`.
- `readonly` impide la reasignación, pero el objeto puede seguir mutándose por dentro (arrays, etc.).
- Para que el archivo compile, el intento inválido va solo en comentario: `// detalle.fechaCreacion = "otra"; // ERROR: readonly`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist interfaces.ts && node dist/interfaces.js
interface Producto {
  id: number;
  nombre: string;
  precio: number;
  stock?: number;
}

interface DetalleProducto extends Producto {
  descripcion: string;
  readonly fechaCreacion: string;
}

function resumen(p: Producto): string {
  return `${p.nombre} - ${p.precio} USD`;
}

const teclado: Producto = { id: 1, nombre: "Teclado", precio: 29.99 };
const mouse: Producto = { id: 2, nombre: "Mouse", precio: 9.5, stock: 50 };

const detalle: DetalleProducto = {
  id: 3,
  nombre: "Teclado mecanico",
  precio: 59.99,
  descripcion: "Con interruptores rojos",
  fechaCreacion: "2026-01-15",
};

// detalle.fechaCreacion = "2026-02-01"; // ERROR: solo lectura (readonly)

console.log(resumen(teclado));
console.log(resumen(mouse));
console.log(`Detalle: ${detalle.descripcion}, creado el ${detalle.fechaCreacion}`);
````

</details>