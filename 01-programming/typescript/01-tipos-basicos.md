# 01 — Tipos Básicos en TypeScript

## Objetivos

- [ ] Entender qué es TypeScript y por qué es útil
- [ ] Instalar y configurar TypeScript
- [ ] Conocer los tipos primitivos: string, number, boolean
- [ ] Usar arrays, tuplas y objetos tipados
- [ ] Entender los tipos any, unknown, void, null, undefined, never
- [ ] Usar type assertions (as)
- [ ] Trabajar con enums
- [ ] Entender union types y literal types
- [ ] Configurar tsconfig.json

## Apuntes

### ¿Qué es TypeScript?

TypeScript es un **superset de JavaScript** que añade **tipado estático** y características avanzadas al lenguaje. Desarrollado por Microsoft, TypeScript se compila a JavaScript y es ampliamente utilizado en aplicaciones grandes y complejas.

#### Características principales:
- **Tipado estático**: Detecta errores en tiempo de compilación
- **Soporte para ES6+**: Usa las últimas características de JavaScript
- **Tooling excelente**: Autocompletado, refactorización, navegación
- **Orientado a objetos**: Clases, interfaces, herencia
- **Compatibilidad total**: Todo JavaScript es TypeScript válido
- **Ecosistema**: Amplio soporte en frameworks (React, Angular, Node.js)

### Instalación y Configuración

#### Instalación global
```bash
npm install -g typescript
tsc --version
```

#### Instalación local en proyecto
```bash
npm install --save-dev typescript @types/node
```

#### Inicializar proyecto TypeScript
```bash
npx tsc --init
```

#### tsconfig.json básico

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "moduleResolution": "node",
    "lib": ["ES2020"],
    "sourceMap": true,
    "strict": true,
    "noImplicitAny": true,
    "noImplicitThis": true,
    "strictNullChecks": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "removeComments": true,
    "declaration": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### Tipos Primitivos

```typescript
// String - Texto
let nombre: string = "Ana";
let saludo: string = `Hola, ${nombre}`;

// Number - Números (enteros y decimales)
let edad: number = 30;
let altura: number = 1.75;
let hexadecimal: number = 0x1A;  // 26
let binario: number = 0b1010;    // 10
let octal: number = 0o755;       // 493

// Boolean - Verdadero o falso
let esEstudiante: boolean = true;
let esMayorDeEdad: boolean = edad >= 18;

// null y undefined
let valorNulo: null = null;
let valorIndefinido: undefined = undefined;

// void - Sin valor (para funciones que no retornan)
let sinValor: void = undefined;

// never - Nunca ocurre (funciones que lanzan error o loops infinitos)
function error(mensaje: string): never {
    throw new Error(mensaje);
}

function loopInfinito(): never {
    while (true) {}
}

// unknown - Tipo desconocido (más seguro que any)
let datoDesconocido: unknown = "Hola";
// datoDesconocido.toUpperCase(); // ERROR: no podemos usar métodos directamente
if (typeof datoDesconocido === "string") {
    datoDesconocido.toUpperCase(); // OK después de verificar el tipo
}

// any - Cualquier tipo (¡EVITAR en lo posible!)
let cualquierCosa: any = "Hola";
cualquierCosa = 42;
cualquierCosa = true;
cualquierCosa.toUpperCase(); // Funciona pero pierde seguridad
```

### Type Annotations (Anotaciones de Tipo)

```typescript
// Declaración con tipo explícito
let nombre: string = "Ana";

// Declaración con inferencia de tipo
let edad = 30; // TypeScript infiere que es number

// Función con tipos en parámetros y retorno
function saludar(nombre: string, edad: number): string {
    return `Hola, ${nombre}. Tienes ${edad} años.`;
}

// Función sin retorno (void)
function imprimirMensaje(mensaje: string): void {
    console.log(mensaje);
}

// Función que puede retornar diferentes tipos
function obtenerValor(esNumero: boolean): number | string {
    return esNumero ? 42 : "Cuarenta y dos";
}
```

### Arrays y Tuplas

#### Arrays
```typescript
// Array de números
let numeros: number[] = [1, 2, 3, 4, 5];
let numerosAlt: Array<number> = [1, 2, 3, 4, 5]; // Sintaxis alternativa

// Array de strings
let nombres: string[] = ["Ana", "Juan", "María"];

// Array de cualquier tipo (evitar)
let mixto: any[] = [1, "dos", true];

// Array de arrays (matriz)
let matriz: number[][] = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

// Array con union types
let numerosOStrings: (number | string)[] = [1, "dos", 3, "cuatro"];

// Array readonly
let readonlyArray: readonly number[] = [1, 2, 3];
// readonlyArray[0] = 10; // ERROR: readonly

// Métodos comunes de arrays
const frutas = ["manzana", "banana", "naranja"];
frutas.push("uva"); // Agregar
const ultima = frutas.pop(); // Eliminar y obtener última
const primera = frutas.shift(); // Eliminar y obtener primera
frutas.unshift("pera"); // Agregar al principio

// Métodos funcionales
const numerosLista = [1, 2, 3, 4, 5];
const cuadrados = numerosLista.map(n => n * n);
const pares = numerosLista.filter(n => n % 2 === 0);
const suma = numerosLista.reduce((acc, n) => acc + n, 0);

// Array destructuring
const [primero, segundo, ...resto] = [1, 2, 3, 4, 5];
// primero = 1, segundo = 2, resto = [3, 4, 5]
```

#### Tuplas
Las tuplas son arrays con un número fijo de elementos y tipos específicos:

```typescript
// Tupla básica
let persona: [string, number] = ["Ana", 30];

// Tupla con más elementos
let empleado: [string, number, boolean] = ["Juan", 25, true];

// Acceso a elementos
let nombreEmpleado: string = empleado[0];
let edadEmpleado: number = empleado[1];

// Tupla con labels (mejor legibilidad)
let coordenada: [lat: number, lng: number] = [40.7128, -74.0060];

// Tuplas en arrays (uso común)
const usuarios: [string, number][] = [
    ["Ana", 30],
    ["Juan", 25],
    ["María", 35]
];

// Tupla con elementos opcionales
let optionalTuple: [string, number?] = ["Hola"];
optionalTuple = ["Hola", 42];

// Tupla con rest elements
let restTuple: [string, ...number[]] = ["Hola", 1, 2, 3, 4];

// Destructuring de tuplas
const [nombrePersona, edadPersona] = persona;
console.log(`${nombrePersona} tiene ${edadPersona} años`);
```

### Objetos Tipados

```typescript
// Objeto con tipo inline
let persona2: { nombre: string; edad: number; } = {
    nombre: "Ana",
    edad: 30
};

// Objeto con tipo y propiedades opcionales
let usuario: {
    nombre: string;
    email?: string; // Opcional
    readonly id: number; // Solo lectura
} = {
    id: 1,
    nombre: "Ana"
};
// usuario.id = 2; // ERROR: readonly

// Objeto con propiedades adicionales
let config: {
    url: string;
    [key: string]: any; // Índice para propiedades adicionales
} = {
    url: "https://api.com",
    timeout: 5000,
    retries: 3
};

// Object destructuring con tipos
const { nombre: nombreUsuario, edad: edadUsuario } = persona2;
const { nombre, edad, ...resto2 } = persona2;

// Object destructuring en parámetros de función
function mostrarPersona({ nombre, edad }: { nombre: string; edad: number }): void {
    console.log(`${nombre} tiene ${edad} años`);
}

// Spread operator con objetos
const personaBase = { nombre: "Ana", edad: 30 };
const personaCompleta = {
    ...personaBase,
    ciudad: "Madrid",
    activo: true
};
```

### Type Assertions (Aserciones de Tipo)

```typescript
// Sintaxis "as" (recomendada)
let valor: any = "Esto es un string";
let longitud: number = (valor as string).length;

// Sintaxis angle-bracket (no funciona en JSX)
let longitud2: number = (<string>valor).length;

// Aserción para tipos más específicos
const input = document.getElementById("mi-input") as HTMLInputElement;
input.value = "Hola";

// Aserción a tipos desconocidos
let unknownValue: unknown = "Hola mundo";
let strValue = unknownValue as string;

// Aserción de const (const assertions)
const config2 = {
    url: "https://api.com",
    method: "GET"
} as const;
// config2.method = "POST"; // ERROR: readonly

// Aserción para null
type User = { id: number; name: string };
let user: User | null = null;
// user.id; // ERROR: Object is possibly 'null'
(user as User).id; // OK (pero peligroso)
```

### Enums (Enumeraciones)

```typescript
// Enum numérico (por defecto empieza en 0)
enum Color {
    Rojo,
    Verde,
    Azul
}
let miColor: Color = Color.Rojo;
console.log(miColor); // 0
console.log(Color[0]); // "Rojo"

// Enum con valores específicos
enum Estado {
    Activo = 1,
    Inactivo = 0,
    Pendiente = -1
}

// Enum con strings (más común)
enum Rol {
    Admin = "ADMIN",
    User = "USER",
    Guest = "GUEST"
}
let rol: Rol = Rol.Admin;
console.log(rol); // "ADMIN"

// Enum híbrido (strings + números)
enum Resultado {
    Exito = "EXITO",
    Error = "ERROR",
    Desconocido = -1
}

// Const enum (optimizado, eliminado en compilación)
const enum Direccion {
    Norte = "N",
    Sur = "S",
    Este = "E",
    Oeste = "O"
}

// Uso de enums en objetos
type Configuracion = {
    estado: Estado;
    rol: Rol;
};

// Comparación de enums
function esAdmin(rol: Rol): boolean {
    return rol === Rol.Admin;
}
```

### Union Types y Literal Types

```typescript
// Union Types (tipos que pueden ser uno de varios)
type ID = string | number;
function procesarID(id: ID): void {
    if (typeof id === "string") {
        console.log(`ID String: ${id.toUpperCase()}`);
    } else {
        console.log(`ID Number: ${id}`);
    }
}

// Union con tipos más complejos
type Resultado2 = { status: "success"; data: any } | { status: "error"; error: string };

function manejarResultado(result: Resultado2): void {
    if (result.status === "success") {
        console.log("Datos:", result.data);
    } else {
        console.log("Error:", result.error);
    }
}

// Literal Types (valores específicos)
type EstadoCivil = "Soltero" | "Casado" | "Divorciado" | "Viudo";
let estado: EstadoCivil = "Soltero";

// Literal types numéricos
type Dado = 1 | 2 | 3 | 4 | 5 | 6;

// NOTA: en el borrador original esta función estaba mal declarada
// ("let lanzarDado()...") y la aserción "as Dado" tenía precedencia
// incorrecta. Versión corregida:
function lanzarDado(): Dado {
    return (Math.floor(Math.random() * 6) + 1) as Dado;
}

// Discriminated Unions (unions con discriminante)
interface Circulo {
    kind: "circulo";
    radio: number;
}
interface Rectangulo {
    kind: "rectangulo";
    base: number;
    altura: number;
}
interface Triangulo {
    kind: "triangulo";
    base: number;
    altura: number;
}
type Forma = Circulo | Rectangulo | Triangulo;

function area(forma: Forma): number {
    switch (forma.kind) {
        case "circulo":
            return Math.PI * forma.radio ** 2;
        case "rectangulo":
            return forma.base * forma.altura;
        case "triangulo":
            return (forma.base * forma.altura) / 2;
        default:
            return 0;
    }
}
```

### Type Narrowing (Reducción de Tipos)

```typescript
// typeof (para tipos primitivos)
function procesarValor(valor: string | number | boolean): void {
    if (typeof valor === "string") {
        console.log(`String: ${valor.toUpperCase()}`);
    } else if (typeof valor === "number") {
        console.log(`Number: ${valor.toFixed(2)}`);
    } else {
        console.log(`Boolean: ${valor}`);
    }
}

// instanceof (para clases)
class Animal {
    constructor(public nombre: string) {}
}
class Perro extends Animal {
    ladrar(): void {
        console.log("¡Guau!");
    }
}
function hacerSonar(animal: Animal): void {
    if (animal instanceof Perro) {
        animal.ladrar();
    } else {
        console.log(`${animal.nombre} hace un sonido`);
    }
}

// in (para verificar propiedad en objeto)
interface Pajaro {
    volar: () => void;
}
interface Pez {
    nadar: () => void;
}
function mover(animal: Pajaro | Pez): void {
    if ("volar" in animal) {
        animal.volar();
    } else {
        animal.nadar();
    }
}

// Type predicates (predicados de tipo)
function isString(valor: any): valor is string {
    return typeof valor === "string";
}
function isNumber(valor: any): valor is number {
    return typeof valor === "number";
}
function procesarValor2(valor: string | number): void {
    if (isString(valor)) {
        console.log(`String: ${valor}`);
    } else if (isNumber(valor)) {
        console.log(`Number: ${valor}`);
    }
}

// Verificar array vacío
function procesarArray<T>(items: T[]): void {
    if (items.length === 0) {
        console.log("Array vacío");
        return;
    }
    items.forEach(item => console.log(item));
}
```

### Null y Undefined (con strictNullChecks)

```typescript
// Con strictNullChecks: true
let nombre2: string = "Ana";
// nombre2 = null; // ERROR: Type 'null' is not assignable to type 'string'

// Tipos con null y undefined
let nombreOpcional: string | null = null;
let email: string | undefined = undefined;
let telefono: string | null | undefined = null;

// Optional chaining (encadenamiento opcional)
interface Usuario {
    nombre: string;
    direccion?: {
        calle: string;
        ciudad: string;
    };
}
const usuario1: Usuario = { nombre: "Ana" };
const ciudad = usuario1.direccion?.ciudad; // undefined (no error)

// Nullish coalescing (operador de coalescencia nula)
const valorNulo2: string | null = null;
const valorDefault = valorNulo2 ?? "Valor por defecto"; // "Valor por defecto"

// Non-null assertion operator (!)
const elemento = document.getElementById("mi-elemento");
// elemento.innerHTML = "Hola"; // ERROR: Object is possibly 'null'
elemento!.innerHTML = "Hola"; // OK (asumimos que no es null)
```

### Configuración de tsconfig.json (detallada)

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "moduleResolution": "node",
    "lib": ["ES2020", "DOM"],
    "sourceMap": true,
    "strict": true,
    "noImplicitAny": true,
    "noImplicitThis": true,
    "strictNullChecks": true,
    "noImplicitReturns": true,
    "noUnusedParameters": true,
    "noUnusedLocals": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "removeComments": true,
    "declaration": true,
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### Errores Comunes en TypeScript

| Error | Causa | Solución |
|-------|-------|----------|
| `Cannot find module 'x'` | Módulo no instalado o falta @types | `npm install @types/x` |
| `Property 'x' does not exist on type 'Y'` | Propiedad no definida en el tipo | Añadir propiedad a la interfaz/type |
| `Type 'x' is not assignable to type 'y'` | Tipo incorrecto | Asegurar que los tipos coincidan |
| `Object is possibly 'null' or 'undefined'` | Valor puede ser null/undefined | Usar optional chaining o verificación |
| `Argument of type 'x' is not assignable to parameter of type 'y'` | Argumento de tipo incorrecto | Usar type assertion o corregir el tipo |
| `Cannot use 'x' as a type` | Confundir valor y tipo | Usar typeof o corregir sintaxis |
| `Duplicate identifier 'x'` | Declaración duplicada | Renombrar o eliminar duplicado |
| `Module 'x' has no exported member 'y'` | Exportación incorrecta | Exportar correctamente o importar correctamente |

## Ejemplos de Código

### Ejemplo 1: Sistema de Usuarios con Tipos

```typescript
type UserId = string | number;
type UserRole = "admin" | "user" | "guest";

interface UserFull {
    id: UserId;
    name: string;
    email: string;
    age: number;
    role: UserRole;
    isActive: boolean;
    createdAt: Date;
}

interface UserWithPermissions extends UserFull {
    permissions: string[];
}

class UserManager {
    private users: Map<UserId, UserFull> = new Map();

    addUser(user: UserFull): void {
        if (this.users.has(user.id)) {
            throw new Error(`User with id ${user.id} already exists`);
        }
        this.users.set(user.id, user);
    }

    getUser(id: UserId): UserFull | undefined {
        return this.users.get(id);
    }

    getUserOrThrow(id: UserId): UserFull {
        const user = this.users.get(id);
        if (!user) {
            throw new Error(`User with id ${id} not found`);
        }
        return user;
    }

    getUsersByRole(role: UserRole): UserFull[] {
        return Array.from(this.users.values())
            .filter(user => user.role === role);
    }

    getActiveUsers(): UserFull[] {
        return Array.from(this.users.values())
            .filter(user => user.isActive);
    }

    deleteUser(id: UserId): boolean {
        return this.users.delete(id);
    }
}

function demonstrateUserManager(): void {
    const manager = new UserManager();

    const user: UserFull = {
        id: 1,
        name: "Ana Martínez",
        email: "ana@email.com",
        age: 30,
        role: "admin",
        isActive: true,
        createdAt: new Date()
    };

    manager.addUser(user);

    const foundUser = manager.getUser(1);
    if (foundUser) {
        console.log(`Usuario encontrado: ${foundUser.name}`);
    }

    const userWithPermissions: UserWithPermissions = {
        ...user,
        permissions: ["read", "write", "delete"]
    };
    console.log(`Permisos: ${userWithPermissions.permissions.join(", ")}`);
}
```

### Ejemplo 2: API Client con Fetch Tipado

```typescript
interface ApiResponse<T> {
    data: T;
    status: number;
    message: string;
}

interface Post {
    id: number;
    title: string;
    body: string;
    userId: number;
}

interface User2 {
    id: number;
    name: string;
    email: string;
}

class ApiClient {
    private baseUrl: string;

    constructor(baseUrl: string) {
        this.baseUrl = baseUrl;
    }

    private async request<T>(
        endpoint: string,
        options: RequestInit = {}
    ): Promise<ApiResponse<T>> {
        try {
            const response = await fetch(`${this.baseUrl}${endpoint}`, options);
            const data = await response.json();

            return {
                data: data as T,
                status: response.status,
                message: response.statusText
            };
        } catch (error) {
            throw new Error(`API request failed: ${error}`);
        }
    }

    async get<T>(endpoint: string): Promise<ApiResponse<T>> {
        return this.request<T>(endpoint, {
            method: "GET",
            headers: {
                "Content-Type": "application/json"
            }
        });
    }

    async post<T, U>(endpoint: string, body: U): Promise<ApiResponse<T>> {
        return this.request<T>(endpoint, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(body)
        });
    }
}

async function fetchPosts(): Promise<void> {
    const client = new ApiClient("https://jsonplaceholder.typicode.com");

    try {
        const response = await client.get<Post[]>("/posts");
        console.log(`Posts obtenidos: ${response.data.length}`);
        console.log(`Status: ${response.status}`);

        if (Array.isArray(response.data)) {
            response.data.slice(0, 3).forEach(post => {
                console.log(`- ${post.title}`);
            });
        }
    } catch (error) {
        console.error("Error al obtener posts:", error);
    }
}
```

### Ejemplo 3: Manejo de Estado con Tipos

```typescript
type LoadingState = "idle" | "loading" | "success" | "error";

interface State<T> {
    status: LoadingState;
    data: T | null;
    error: Error | null;
}

class StateManager<T> {
    private state: State<T> = {
        status: "idle",
        data: null,
        error: null
    };

    private listeners: ((state: State<T>) => void)[] = [];

    private updateState(newState: Partial<State<T>>): void {
        this.state = { ...this.state, ...newState };
        this.notifyListeners();
    }

    private notifyListeners(): void {
        this.listeners.forEach(listener => listener(this.state));
    }

    subscribe(listener: (state: State<T>) => void): () => void {
        this.listeners.push(listener);
        return () => {
            this.listeners = this.listeners.filter(l => l !== listener);
        };
    }

    getState(): State<T> {
        return { ...this.state };
    }

    startLoading(): void {
        this.updateState({ status: "loading", data: null, error: null });
    }

    setData(data: T): void {
        this.updateState({ status: "success", data, error: null });
    }

    setError(error: Error): void {
        this.updateState({ status: "error", data: null, error });
    }

    reset(): void {
        this.updateState({ status: "idle", data: null, error: null });
    }
}

interface UserForState {
    id: number;
    name: string;
    email: string;
}

async function fetchUserWithState(id: number): Promise<void> {
    const stateManager = new StateManager<UserForState>();

    const unsubscribe = stateManager.subscribe((state) => {
        console.log(`Estado: ${state.status}`);
        if (state.data) {
            console.log(`Usuario: ${state.data.name}`);
        }
        if (state.error) {
            console.error(`Error: ${state.error.message}`);
        }
    });

    try {
        stateManager.startLoading();

        const response = await fetch(`https://jsonplaceholder.typicode.com/users/${id}`);
        const user = await response.json() as UserForState;

        stateManager.setData(user);
    } catch (error) {
        stateManager.setError(error as Error);
    } finally {
        unsubscribe();
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 01: Tipos Básicos](./ejercicios/nivel-01-fundamentos/ejercicio-01-tipos-basicos/)
- [Ejercicio 02: Variables y Anotaciones](./ejercicios/nivel-01-fundamentos/ejercicio-02-variables-y-anotaciones/)
- [Ejercicio 03: Funciones Tipadas](./ejercicios/nivel-01-fundamentos/ejercicio-03-funciones-tipadas/)
- [Ejercicio 04: Arrays y Tuplas](./ejercicios/nivel-01-fundamentos/ejercicio-04-arrays-y-tuplas/)
- [Ejercicio 05: Enums](./ejercicios/nivel-01-fundamentos/ejercicio-05-enums/)
- [Ejercicio 06: Union y Literal Types](./ejercicios/nivel-01-fundamentos/ejercicio-06-union-y-literal-types/)

## Recursos

- [Documentación oficial de TypeScript](https://www.typescriptlang.org/docs/)
- [TypeScript Playground](https://www.typescriptlang.org/play/)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Awesome TypeScript](https://github.com/dzharii/awesome-typescript)
- [TypeScript ESLint](https://typescript-eslint.io/)
