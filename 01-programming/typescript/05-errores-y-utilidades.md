# 05 — Errores y Utility Types

## Objetivos

- [ ] Crear clases de error personalizadas
- [ ] Tipar el manejo de errores (`unknown` en catch)
- [ ] Dominar los Utility Types: `Partial`, `Required`, `Readonly`, `Pick`, `Omit`, `Record`, `Exclude`, `Extract`, `ReturnType`, `Parameters`

## Apuntes

### Errores personalizados

```typescript
class AppError extends Error {
    constructor(message: string, public readonly codigo: string) {
        super(message);
        this.name = "AppError";
    }
}

class ValidationError extends AppError {
    constructor(message: string, public readonly campo: string) {
        super(message, "VALIDATION_ERROR");
        this.name = "ValidationError";
    }
}

try {
    throw new ValidationError("Email inválido", "email");
} catch (error) {
    if (error instanceof ValidationError) {
        console.log(`Error en campo ${error.campo}: ${error.message}`);
    } else if (error instanceof Error) {
        console.log(error.message);
    }
}
```

### Utility Types

```typescript
interface Usuario {
    id: number;
    nombre: string;
    email: string;
    edad: number;
}

type UsuarioParcial = Partial<Usuario>;         // todas las props opcionales
type UsuarioRequerido = Required<Usuario>;      // todas las props obligatorias
type UsuarioSoloLectura = Readonly<Usuario>;    // todas las props readonly
type UsuarioBasico = Pick<Usuario, "id" | "nombre">;
type UsuarioSinEmail = Omit<Usuario, "email">;
type MapaUsuarios = Record<number, Usuario>;

type Estado = "activo" | "inactivo" | "pendiente";
type EstadoSinPendiente = Exclude<Estado, "pendiente">;
type SoloPendiente = Extract<Estado, "pendiente">;

function crearUsuario(nombre: string, edad: number): Usuario {
    return { id: 1, nombre, email: "", edad };
}
type ParametrosCrearUsuario = Parameters<typeof crearUsuario>;
type RetornoCrearUsuario = ReturnType<typeof crearUsuario>;
```

## Ejercicios Relacionados

- [Ejercicio 03: Utility Types](./ejercicios/nivel-03-intermedio/ejercicio-03-utility-types/)

## Recursos

- [TypeScript Handbook — Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)
