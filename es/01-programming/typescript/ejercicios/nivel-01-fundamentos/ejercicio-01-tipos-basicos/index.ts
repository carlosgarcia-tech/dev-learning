// Ejercicio 01 - Tipos Básicos
// TODO: Completa el ejercicio siguiendo el enunciado del README.md
// Declara variables de todos los tipos básicos
// Crea funciones con tipos explícitos
// Usa type assertions

// 1. Variables básicas con anotaciones explícitas
let nombre: string;
let edad: number;
let esEstudiante: boolean;
let valorNulo: null;
let valorIndefinido: undefined;
let cualquierValor: any;

// 2. Función que retorna un string con nombre y edad
function crearPresentacion(nombre: string, edad: number): string {
    throw new Error("TODO: implementar crearPresentacion");
}

// 3. Función que identifica el tipo de un valor
function identificarTipo(valor: string | number): string {
    throw new Error("TODO: implementar identificarTipo");
}

// 4. Type assertions: unknown -> string -> number
let valorDesconocido: unknown = "123";
let valorString: string = valorDesconocido as string;
let valorNumero: number = Number(valorString);

// Exporta las variables y funciones para los tests
export {
    nombre,
    edad,
    esEstudiante,
    valorNulo,
    valorIndefinido,
    cualquierValor,
    crearPresentacion,
    identificarTipo,
    valorString,
    valorNumero
};
