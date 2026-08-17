# 05 — Errores y utilidades

## Objetivos

- [ ] Dominar los **utility types** de la librería estándar (`Partial`, `Pick`, `Omit`, `Readonly`, etc.).
- [ ] Usar `never` para funciones sin retorno y tipos imposibles.
- [ ] Distinguir `unknown` de `any` y manejarlo con narrowing.
- [ ] Configurar `tsconfig.json` con `--strict` y las opciones más relevantes.
- [ ] Escribir mapped types y tipos condicionales básicos.
- [ ] Compilar con `tsc` y depurar errores de tipo.

## Apuntes

### Utility types esenciales

TypeScript incluye utilidades de tipo que transforman otros tipos:

| Utilidad | Qué hace |
|---|---|
| `Partial<T>` | Todas las propiedades opcionales |
| `Required<T>` | Todas las propiedades obligatorias |
| `Readonly<T>` | Todas las propiedades de solo lectura |
| `Pick<T, K>` | Selecciona solo las claves `K` |
| `Omit<T, K>` | Quita las claves `K` |
| `Record<K, V>` | Objeto con claves `K` y valores `V` |
| `Exclude<T, U>` | Quita `U` de `T` |
| `Extract<T, U>` | Se queda con la intersección `T ∩ U` |
| `NonNullable<T>` | Quita `null` y `undefined` |

```typescript
interface Usuario {
  id: number;
  nombre: string;
  email: string;
}

type UsuarioNuevo = Omit<Usuario, "id">;      // { nombre; email }
type DatosParciales = Partial<Usuario>;        // todo opcional
type SoloNombre = Pick<Usuario, "nombre">;     // { nombre }

type Estado = "activo" | "inactivo" | "ban";
type ActivoOInactivo = Exclude<Estado, "ban">; // "activo" | "inactivo"

const mapa: Record<string, number> = { a: 1, b: 2 };
```

### `never`: el tipo vacío

- `never` representa el tipo de **lo que nunca ocurre**: una función que siempre lanza o termina el proceso.
- Un valor de tipo `never` no puede asignarse a nada, y nada (salvo `never`) se asigna a `never`.
- Es el **mecanismo de exahustividad**: si un `switch` sobre una unión no cubre todos los casos, el caso restante es `never`.

```typescript
function lanzar(mensaje: string): never {
  throw new Error(mensaje);
}

type Resultado = "exito" | "fracaso";

function manejar(r: Resultado): string {
  switch (r) {
    case "exito":
      return "Todo bien";
    case "fracaso":
      return "Algo falló";
  }
}
```

Una función que termina normalmente no puede anotarse `never`; en cambio, la **función sin retorno que no lanza** se anota `void`.

### `unknown` vs `any`

- `any`: desactiva la comprobación. Cualquier operación compila.
- `unknown`: "no sé qué es". **Hay que estrecharlo** antes de usarlo.

```typescript
let dato: unknown = "texto";
// dato.toUpperCase();            // ERROR: unknown no tiene métodos

if (typeof dato === "string") {
  dato.toUpperCase();            // ok: narrowing a string
}
```

Regla práctica: **`unknown` es el `any` seguro**. Cuando parsees JSON, recibe datos en la API o captures errores, usa `unknown` y aplica narrowing o guardas.

### Mapped types

Un **mapped type** itera sobre las claves de otro tipo para construir uno nuevo:

```typescript
type Opciones = {
  [K in keyof Usuario]?: boolean;
};

// equivalente a: { id?: boolean; nombre?: boolean; email?: boolean }
```

Los modificadores `readonly` y `?` pueden añadirse (`+`) o quitarse (`-`):

```typescript
type Desbloquear = {
  -readonly [K in keyof Usuario]: Usuario[K];
};

type TodoObligatorio = {
  [K in keyof Usuario]-?: Usuario[K];
};
```

### Tipos condicionales

Un **conditional type** evalúa un tipo según una condición, como un `if` a nivel de tipos:

```typescript
type EsNumero<T> = T extends number ? "sí" : "no";

type A = EsNumero<42>;   // "sí"
type B = EsNumero<"x">;  // "no"

type SinNull<T> = T extends null | undefined ? never : T;

type C = SinNull<string | null>; // string
```

Los condicionales **distribuyen** sobre uniones: `SinNull<string | null>` procesa cada miembro por separado.

### `tsconfig.json`

El corazón de la configuración de un proyecto TS. Empieza con `npx tsc --init`.

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "outDir": "dist",
    "rootDir": "src",
    "noEmitOnError": true
  },
  "include": ["src"]
}
```

- `strict` activa `strictNullChecks` y otras comprobaciones de seguridad.
- `noUncheckedIndexedAccess` hace que `arr[i]` sea `T | undefined`.
- `exactOptionalPropertyTypes` prohíbe asignar `undefined` explícito a propiedades opcionales.
- `outDir`/`rootDir` controlan dónde se emite el JavaScript compilado.

Comandos útiles:

```bash
npx tsc --noEmit          # solo comprobar tipos
npx tsc --watch           # compilar en modo observador
npx tsc --noEmit --watch  # comprobar tipos continuamente
```

## Ejemplos de código

```typescript
// Mapped type + utility types en un formulario
interface Formulario {
  nombre: string;
  email: string;
  edad: number;
}

type FormularioEstado = Partial<Formulario> & {
  errores?: Partial<Record<keyof Formulario, string>>;
};

const estado: FormularioEstado = {
  nombre: "Ana",
  errores: { email: "Formato inválido" },
};
```

```typescript
// Exhaustividad con never
type Direccion = "norte" | "sur" | "este" | "oeste";

function opuesto(d: Direccion): Direccion {
  switch (d) {
    case "norte":
      return "sur";
    case "sur":
      return "norte";
    case "este":
      return "oeste";
    case "oeste":
      return "este";
  }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/) (utility types)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/) (mapped/conditional types y tsconfig)

## Errores comunes

- **Usar `any` para escapar de `unknown`** → usa narrowing o guardas; `any` reintroduce los bugs.
- **`never` para funciones que terminan normal** → es para funciones que lanzan o loops infinitos; para el resto usa `void`.
- **Olvidar `--strict`** → la mayoría de errores de `null`/`undefined` solo se detectan con él.
- **Mapped types con sintaxis incorrecta** → la clave es `[K in keyof T]`; olvidar `keyof` es el fallo típico.
- **Asumir que `Partial<T>` "rellena" valores** → solo relaja el tipo, no añade datos en runtime.
- **Condicionales sin distribución en mente** → sobre uniones distribuyen; si no quieres eso, envuelve con `[]`.

## Recursos

- [TypeScript — Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)
- [TypeScript — tsconfig options](https://www.typescriptlang.org/tsconfig)
- [TypeScript — Mapped types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [TypeScript — Conditional types](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)
- [Documentación oficial en español](https://www.typescriptlang.org/es/docs/)