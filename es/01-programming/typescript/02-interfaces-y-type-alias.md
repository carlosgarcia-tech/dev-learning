# 02 — Interfaces y type alias

## Objetivos

- [ ] Definir la forma de un objeto con `interface`.
- [ ] Declarar tipos con `type` y saber cuándo usarlo frente a `interface`.
- [ ] Extender interfaces y combinar tipos con `&`.
- [ ] Usar propiedades opcionales, de solo lectura y métodos en interfaces.
- [ ] Modelar objetos "discriminados" con uniones de interfaces.
- [ ] Decidir de forma consciente entre `interface` y `type` en tu código.

## Apuntes

### Interfaces: la forma de un objeto

Una `interface` describe **la forma (shape)** de un objeto: qué propiedades tiene y de qué tipo.

```typescript
interface Usuario {
  nombre: string;
  edad: number;
  email: string;
}

const ana: Usuario = {
  nombre: "Ana",
  edad: 30,
  email: "ana@correo.com",
};
```

Si un objeto no cumple la forma, el compilador lo rechaza:

```typescript
const mal: Usuario = {
  nombre: "Ana",
  // ERROR: falta edad
};
```

### Propiedades opcionales y de solo lectura

- Con `?` la propiedad es **opcional**: puede no existir.
- Con `readonly` la propiedad **no se puede reasignar** después de crear el objeto.

```typescript
interface Config {
  readonly apiUrl: string;
  timeout?: number;       // opcional
  retries?: number;       // opcional
}

const cfg: Config = { apiUrl: "https://api.example.com" }; // ok
cfg.apiUrl = "otra";   // ERROR: readonly
cfg.timeout = 3000;    // ok: antes era opcional, ahora se asigna
```

### `type` alias: cualquier tipo con nombre

Un `type` alias da nombre a **cualquier tipo**, no solo objetos:

```typescript
type Id = string | number;
type Callback = (err: Error | null, data?: string) => void;
type Coordenadas = [x: number, y: number];

const id: Id = 123;
const cb: Callback = (err, data) => { /* ... */ };
```

### Extender interfaces

Las interfaces se extienden con `extends`, heredando todas sus propiedades.

```typescript
interface Animal {
  nombre: string;
}

interface Perro extends Animal {
  ladra: boolean;
}

const toby: Perro = {
  nombre: "Toby",
  ladra: true,
};
```

Los `type` no se extienden, se **componen** con intersección `&`:

```typescript
type Animal = { nombre: string };
type Perro = Animal & { ladra: boolean };

const toby: Perro = { nombre: "Toby", ladra: true };
```

### Métodos en interfaces

Una interfaz puede declarar métodos con su firma:

```typescript
interface Repositorio {
  guardar(entidad: Usuario): void;
  obtener(id: string): Usuario | null;
}

const repo: Repositorio = {
  guardar(usuario) {
    console.log(`Guardando ${usuario.nombre}`);
  },
  obtener(id) {
    return id === "1" ? { nombre: "Ana", edad: 30, email: "" } : null;
  },
};
```

### Uniones de objetos: discriminación

Combinar `interface` con uniones permite modelar **variantes** de un mismo concepto. Si cada variante tiene una propiedad literal en común (el *discriminante*), TypeScript puede estrechar el tipo automáticamente.

```typescript
interface Circulo {
  tipo: "circulo";
  radio: number;
}

interface Cuadrado {
  tipo: "cuadrado";
  lado: number;
}

type Figura = Circulo | Cuadrado;

function area(figura: Figura): number {
  switch (figura.tipo) {
    case "circulo":
      return Math.PI * figura.radio ** 2;   // figura es Circulo
    case "cuadrado":
      return figura.lado ** 2;              // figura es Cuadrado
  }
}
```

### `interface` vs `type`: criterios prácticos

| Criterio | `interface` | `type` |
|---|---|---|
| Objetos/clases | Preferida | Válida |
| Uniones y tuplas | No | Sí |
| Primitivos con nombre | No | Sí |
| Extensión | `extends` | `&` |
| Merge de declaraciones | Sí (declaration merging) | No |

Regla práctica: **usa `interface` para la forma de objetos y clases; usa `type` para uniones, tuplas y alias**. Ambos son intercambiables en la mayoría de casos.

## Ejemplos de código

```typescript
interface Producto {
  id: number;
  nombre: string;
  precio: number;
  descuento?: number;
}

type ProductoNuevo = Omit<Producto, "id">;

const crearProducto = (datos: ProductoNuevo): Producto => ({
  id: Date.now(),
  ...datos,
});

console.log(crearProducto({ nombre: "Teclado", precio: 29 }));
```

```typescript
// Interfaz con método y herencia
interface Vehiculo {
  marca: string;
  arrancar(): void;
}

interface Coche extends Vehiculo {
  puertas: number;
}

const miCoche: Coche = {
  marca: "Seat",
  puertas: 5,
  arrancar() {
    console.log("Brrrm");
  },
};
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Declarar `type` y usar `extends`** → los alias se combinan con `&`, no con `extends`.
- **Olvidar las propiedades requeridas** → un objeto que no cumple la forma completa no compila.
- **Intentar extender una unión con `extends`** → primero define cada variante por separado.
- **Redefinir una `readonly`** → la propiedad no puede reasignarse, aunque el objeto sea mutable por dentro.
- **Fusionar tipos por error** → dos interfaces con el mismo nombre se **fusionan**; los `type` no.
- **Usar unión de objetos sin discriminante** → sin una propiedad literal común, el narrowing manual se vuelve incómodo.

## Recursos

- [TypeScript — Interfaces](https://www.typescriptlang.org/docs/handbook/2/objects.html)
- [TypeScript — Type aliases](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#type-aliases)
- [TypeScript — Discriminated unions](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions)
- [Documentación oficial en español](https://www.typescriptlang.org/es/docs/)