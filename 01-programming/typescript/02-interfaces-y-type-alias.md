# 02 — Interfaces y Type Aliases

> Nota: el material original solo indicaba que esta guía "continuaría con la misma
> profundidad" que la guía 1. Aquí se incluye una versión funcional y completa
> para que el curso quede consistente.

## Objetivos

- [ ] Definir y usar `interface`
- [ ] Definir y usar `type` (type alias)
- [ ] Entender las diferencias entre `interface` y `type`
- [ ] Extender interfaces (`extends`) e intersecar types (`&`)
- [ ] Usar tipos indexados y `keyof`
- [ ] Crear mapped types simples

## Apuntes

### Interfaces

```typescript
interface Persona {
    nombre: string;
    edad: number;
    email?: string; // opcional
    readonly id: number; // solo lectura
}

const persona: Persona = { id: 1, nombre: "Ana", edad: 30 };
```

### Herencia de interfaces

```typescript
interface Empleado extends Persona {
    salario: number;
    puesto: string;
}
```

Una interfaz puede extender varias a la vez:

```typescript
interface Auditable {
    creadoEn: Date;
}
interface EmpleadoAuditado extends Empleado, Auditable {}
```

### Type Aliases

```typescript
type ID = string | number;
type Punto = { x: number; y: number };
type Callback = (error: Error | null, resultado?: string) => void;
```

### Intersección de tipos

```typescript
type ConNombre = { nombre: string };
type ConEdad = { edad: number };
type PersonaCompleta = ConNombre & ConEdad;
```

### `interface` vs `type`: ¿cuándo usar cada uno?

| Característica | `interface` | `type` |
|---|---|---|
| Extender | `extends` | `&` (intersección) |
| Declaration merging | Sí | No |
| Union types | No | Sí |
| Primitivos, tuplas, funciones | No | Sí |

Recomendación general: usa `interface` para formas de objetos públicas (APIs,
props de componentes) y `type` para uniones, intersecciones y tipos utilitarios.

### `keyof` y tipos indexados

```typescript
interface Producto {
    id: number;
    nombre: string;
    precio: number;
}

type ClavesProducto = keyof Producto; // "id" | "nombre" | "precio"

function obtenerValor<T, K extends keyof T>(obj: T, clave: K): T[K] {
    return obj[clave];
}
```

### Mapped types básicos

```typescript
type SoloLectura<T> = { readonly [K in keyof T]: T[K] };
type Opcional<T> = { [K in keyof T]?: T[K] };

type ProductoSoloLectura = SoloLectura<Producto>;
```

## Ejercicios Relacionados

- [Ejercicio 01: Interfaces](./ejercicios/nivel-02-basico/ejercicio-01-interfaces/)
- [Ejercicio 02: Type Alias](./ejercicios/nivel-02-basico/ejercicio-02-type-alias/)

## Recursos

- [TypeScript Handbook — Interfaces](https://www.typescriptlang.org/docs/handbook/2/objects.html)
- [TypeScript Handbook — Type Aliases](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html)
