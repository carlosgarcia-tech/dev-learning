# 03 — Funciones y Generics

## Objetivos

- [ ] Tipar parámetros, valores de retorno, parámetros opcionales y rest
- [ ] Usar overloads de funciones
- [ ] Entender y aplicar generics en funciones, interfaces y clases
- [ ] Aplicar restricciones (`extends`) a generics
- [ ] Usar generics con múltiples parámetros de tipo

## Apuntes

### Funciones tipadas

```typescript
function sumar(a: number, b: number): number {
    return a + b;
}

function saludar(nombre: string, saludo: string = "Hola"): string {
    return `${saludo}, ${nombre}!`;
}

function sumarTodos(...numeros: number[]): number {
    return numeros.reduce((acc, n) => acc + n, 0);
}

const multiplicar = (a: number, b: number): number => a * b;
```

### Function overloads

```typescript
function combinar(a: string, b: string): string;
function combinar(a: number, b: number): number;
function combinar(a: any, b: any): any {
    return a + b;
}
```

### Generics básicos

```typescript
function identidad<T>(valor: T): T {
    return valor;
}

function primero<T>(items: T[]): T | undefined {
    return items[0];
}

interface Caja<T> {
    contenido: T;
}

class Pila<T> {
    private items: T[] = [];
    push(item: T): void { this.items.push(item); }
    pop(): T | undefined { return this.items.pop(); }
}
```

### Restricciones en generics

```typescript
interface ConLongitud {
    length: number;
}

function logLongitud<T extends ConLongitud>(item: T): T {
    console.log(item.length);
    return item;
}

function obtenerPropiedad<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}
```

### Múltiples parámetros de tipo

```typescript
function combinarObjetos<T, U>(a: T, b: U): T & U {
    return { ...a, ...b };
}
```

## Ejercicios Relacionados

- [Ejercicio 01: Generics Básicos](./ejercicios/nivel-03-intermedio/ejercicio-01-generics-basicos/)
- [Ejercicio 02: Generics Avanzados](./ejercicios/nivel-03-intermedio/ejercicio-02-generics-avanzados/)

## Recursos

- [TypeScript Handbook — Generics](https://www.typescriptlang.org/docs/handbook/2/generics.html)
