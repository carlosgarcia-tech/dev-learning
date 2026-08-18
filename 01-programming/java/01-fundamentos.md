# 01 — Fundamentos de Java

## Objetivos

- [ ] Entender qué es Java y el concepto de JVM
- [ ] Instalar y configurar el JDK
- [ ] Conocer la estructura de un programa Java
- [ ] Usar variables, constantes y tipos de datos primitivos
- [ ] Entender los tipos de datos por referencia (String, arrays)
- [ ] Usar operadores aritméticos, lógicos y de comparación
- [ ] Implementar estructuras de control (if, switch, bucles)
- [ ] Crear y usar métodos
- [ ] Manejar entrada/salida básica con Scanner
- [ ] Entender el sistema de paquetes y la importación

## Apuntes

### ¿Qué es Java?

Java es un lenguaje de programación de alto nivel, orientado a objetos y multiplataforma creado por Sun Microsystems (ahora Oracle) en 1995. Su filosofía principal es **"Write Once, Run Anywhere"** (WORA), gracias a la **Java Virtual Machine (JVM)**.

#### Características principales:
- **Orientado a objetos**: Todo en Java (excepto tipos primitivos) es un objeto.
- **Multiplataforma**: El bytecode compilado (.class) se ejecuta en cualquier JVM.
- **Seguro**: Gestión automática de memoria (Garbage Collector).
- **Robusto**: Manejo de excepciones y verificación de tipos en tiempo de compilación.
- **Concurrente**: Soporte para múltiples hilos de ejecución.
- **Larga vida**: Uno de los lenguajes más utilizados en el mundo empresarial.

### La JVM (Java Virtual Machine)

La JVM es el motor que ejecuta el bytecode de Java. Funciona así:

1. **Código fuente** (`.java`) → **Compilador** (`javac`) → **Bytecode** (`.class`)
2. El **ClassLoader** carga las clases en la JVM
3. El **Bytecode Verifier** verifica la seguridad del código
4. El **Interpreter/Just-In-Time Compiler (JIT)** ejecuta el bytecode

### Estructura de un programa Java

```java
// 1. Declaración del paquete (opcional, pero recomendado)
package com.miempresa.miProyecto;

// 2. Importaciones (si necesitamos clases de otros paquetes)
import java.util.Scanner;
import java.util.ArrayList;

// 3. Declaración de la clase (nombre del archivo)
public class MiPrograma {

    // 4. Constantes (opcionales)
    public static final double PI = 3.14159;

    // 5. Atributos de instancia (variables de la clase)
    private String nombre;
    private int edad;

    // 6. Constructor (opcional)
    public MiPrograma(String nombre, int edad) {
        this.nombre = nombre;
        this.edad = edad;
    }

    // 7. Métodos (comportamiento)
    public void saludar() {
        System.out.println("¡Hola, " + nombre + "!");
    }

    // 8. Método main (punto de entrada)
    public static void main(String[] args) {
        // El código empieza aquí
        System.out.println("¡Bienvenido a Java!");

        // Crear una instancia de la clase
        MiPrograma programa = new MiPrograma("Ana", 30);
        programa.saludar();
    }
}
```

### Variables y Tipos de Datos

#### Tipos primitivos (8 tipos)

| Tipo | Tamaño | Rango | Ejemplo |
|------|--------|-------|---------|
| `byte` | 8 bits | -128 a 127 | `byte edad = 25;` |
| `short` | 16 bits | -32,768 a 32,767 | `short temperatura = 1000;` |
| `int` | 32 bits | -2³¹ a 2³¹-1 | `int poblacion = 1000000;` |
| `long` | 64 bits | -2⁶³ a 2⁶³-1 | `long distancia = 300000000L;` |
| `float` | 32 bits | ±3.4e-38 a ±3.4e+38 | `float precio = 19.99f;` |
| `double` | 64 bits | ±1.7e-308 a ±1.7e+308 | `double pi = 3.14159;` |
| `char` | 16 bits | 0 a 65,535 (Unicode) | `char inicial = 'A';` |
| `boolean` | 1 bit | true o false | `boolean esEstudiante = true;` |

#### Declaración de variables

```java
// Declaración simple
int edad;
String nombre;

// Declaración e inicialización
int contador = 0;
String mensaje = "Hola Mundo";
double altura = 1.75;

// Declaración de constantes
final int DIAS_SEMANA = 7;
final double IVA = 0.21;

// Múltiples variables del mismo tipo
int x, y, z;
int a = 1, b = 2, c = 3;
```

#### Tipos por referencia (Reference Types)

- **String**: Cadena de caracteres (inmutable)
- **Arrays**: Colecciones de elementos del mismo tipo
- **Clases**: Definidas por el programador
- **Interfaces**: Definiciones de comportamiento

### Entrada y Salida con Scanner

El paquete `java.util.Scanner` permite leer entrada del usuario:

```java
import java.util.Scanner;

public class EjemploScanner {
    public static void main(String[] args) {
        // Crear el Scanner
        Scanner scanner = new Scanner(System.in);

        // Leer diferentes tipos de datos
        System.out.print("Ingresa tu nombre: ");
        String nombre = scanner.nextLine();  // Lee texto completo

        System.out.print("Ingresa tu edad: ");
        int edad = scanner.nextInt();        // Lee un número entero

        System.out.print("Ingresa tu altura: ");
        double altura = scanner.nextDouble(); // Lee un número decimal

        System.out.print("¿Eres estudiante? (true/false): ");
        boolean estudiante = scanner.nextBoolean();

        System.out.println("\n--- Datos ---");
        System.out.println("Nombre: " + nombre);
        System.out.println("Edad: " + edad);
        System.out.println("Altura: " + altura);
        System.out.println("Estudiante: " + estudiante);

        scanner.close(); // ¡Es importante cerrar el Scanner!
    }
}
```

#### Escenarios especiales con Scanner

```java
// Leer un número y luego texto (problema con nextLine)
Scanner sc = new Scanner(System.in);
System.out.print("Edad: ");
int edad = sc.nextInt();
sc.nextLine(); // Consumir el salto de línea
System.out.print("Nombre: ");
String nombre = sc.nextLine(); // Ahora funciona correctamente

// Leer hasta un delimitador
sc.useDelimiter(",");
String dato1 = sc.next(); // Lee hasta la coma
String dato2 = sc.next(); // Lee hasta la siguiente coma
```

### Operadores en Java

#### Operadores Aritméticos

```java
int a = 10, b = 3;
int suma = a + b;          // 13
int resta = a - b;         // 7
int producto = a * b;      // 30
int division = a / b;      // 3 (división entera)
int modulo = a % b;        // 1 (resto)
double divisionReal = (double) a / b; // 3.333... (con casting)
```

#### Operadores de Incremento/Decremento

```java
int x = 5;
int y = ++x; // Pre-incremento: x = 6, y = 6
int z = x++; // Post-incremento: z = 6, x = 7

int a = 5;
int b = --a; // Pre-decremento: a = 4, b = 4
int c = a--; // Post-decremento: c = 4, a = 3
```

#### Operadores de Comparación (retornan boolean)

```java
int a = 10, b = 20;
boolean igual = a == b;        // false
boolean diferente = a != b;    // true
boolean mayor = a > b;         // false
boolean menor = a < b;         // true
boolean mayorIgual = a >= b;   // false
boolean menorIgual = a <= b;   // true
```

#### Operadores Lógicos

```java
boolean a = true, b = false;
boolean and = a && b;    // false (AND)
boolean or = a || b;     // true (OR)
boolean not = !a;        // false (NOT)

// Comparación de objetos (String)
String s1 = "Hola";
String s2 = "Hola";
String s3 = new String("Hola");
System.out.println(s1 == s2);        // true (misma referencia)
System.out.println(s1 == s3);        // false (diferentes referencias)
System.out.println(s1.equals(s3));   // true (mismo contenido)
```

### Estructuras de Control

#### if, else if, else

```java
// Condicional simple
int edad = 25;
if (edad >= 18) {
    System.out.println("Eres mayor de edad");
}

// if-else
if (edad >= 18) {
    System.out.println("Eres mayor de edad");
} else {
    System.out.println("Eres menor de edad");
}

// if-else if-else
if (edad < 0) {
    System.out.println("Edad inválida");
} else if (edad < 12) {
    System.out.println("Niño");
} else if (edad < 18) {
    System.out.println("Adolescente");
} else if (edad < 65) {
    System.out.println("Adulto");
} else {
    System.out.println("Jubilado");
}
```

> **Nota:** la sintaxis `if (int resultado = calcular(); resultado > 0)` **no existe en Java**
> (a diferencia de otros lenguajes como Go o C++17). En Java las variables se declaran
> antes del `if`:
> ```java
> int resultado = calcular();
> if (resultado > 0) {
>     System.out.println("Positivo: " + resultado);
> } else {
>     System.out.println("No positivo: " + resultado);
> }
> ```

#### Operador Ternario

```java
// Sintaxis: (condición) ? valorSiTrue : valorSiFalse
int edad = 18;
String mensaje = (edad >= 18) ? "Mayor de edad" : "Menor de edad";
System.out.println(mensaje);

int a = 10, b = 20;
int maximo = (a > b) ? a : b; // maximo = 20
```

#### Switch

```java
// Switch tradicional
int dia = 3;
String nombreDia;
switch (dia) {
    case 1:
        nombreDia = "Lunes";
        break;
    case 2:
        nombreDia = "Martes";
        break;
    case 3:
        nombreDia = "Miércoles";
        break;
    case 4:
        nombreDia = "Jueves";
        break;
    case 5:
        nombreDia = "Viernes";
        break;
    case 6:
        nombreDia = "Sábado";
        break;
    case 7:
        nombreDia = "Domingo";
        break;
    default:
        nombreDia = "Día inválido";
}
System.out.println(nombreDia); // Miércoles

// Switch con arrow (Java 14+)
int mes = 2;
int dias = switch (mes) {
    case 1, 3, 5, 7, 8, 10, 12 -> 31;
    case 4, 6, 9, 11 -> 30;
    case 2 -> 28;
    default -> -1;
};
System.out.println("Días: " + dias);

// Switch con yield (Java 13+)
String estacion = switch (mes) {
    case 12, 1, 2 -> {
        System.out.println("Invierno");
        yield "Invierno";
    }
    case 3, 4, 5 -> "Primavera";
    case 6, 7, 8 -> "Verano";
    case 9, 10, 11 -> "Otoño";
    default -> "Mes inválido";
};
System.out.println(estacion);
```

### Bucles

#### for (bucle contado)

```java
// Bucle clásico
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

// Bucle con múltiples variables
for (int i = 0, j = 10; i < j; i++, j--) {
    System.out.println("i=" + i + ", j=" + j);
}

// Bucle for-each (para arrays y colecciones)
String[] nombres = {"Ana", "Juan", "María"};
for (String nombre : nombres) {
    System.out.println(nombre);
}

// Bucle for con break y continue
for (int i = 0; i < 100; i++) {
    if (i % 2 == 0) {
        continue; // Salta los pares
    }
    if (i > 50) {
        break; // Termina cuando supera 50
    }
    System.out.println(i);
}

// Etiquetar bucles (break/continue a un bucle específico)
outerLoop: for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
        if (i == j) {
            continue outerLoop;
        }
        System.out.println("i=" + i + ", j=" + j);
    }
}
```

#### while (bucle condicional)

```java
// while normal
int contador = 0;
while (contador < 10) {
    System.out.println(contador);
    contador++;
}

// do-while (al menos se ejecuta una vez)
Scanner scanner = new Scanner(System.in);
int numero;
do {
    System.out.print("Ingresa un número positivo: ");
    numero = scanner.nextInt();
} while (numero <= 0);
```

### Métodos

```java
// Método sin parámetros y sin retorno
public void saludar() {
    System.out.println("¡Hola!");
}

// Método con parámetros y retorno
public int sumar(int a, int b) {
    return a + b;
}

// Método con parámetros variables (varargs)
public double calcularPromedio(double... numeros) {
    double suma = 0;
    for (double num : numeros) {
        suma += num;
    }
    return suma / numeros.length;
}

// Sobrecarga de métodos (mismo nombre, diferente firma)
public int sumar(int a, int b, int c) {
    return a + b + c;
}
public double sumar(double a, double b) {
    return a + b;
}

// Método static (pertenece a la clase, no a la instancia)
public static int sumarStatic(int a, int b) {
    return a + b;
}

// Modificadores de acceso
private void metodoPrivado() {
    // Solo accesible dentro de esta clase
}
protected void metodoProtegido() {
    // Accesible en el mismo paquete y en subclases
}
public void metodoPublico() {
    // Accesible desde cualquier parte
}
void metodoDefault() {
    // Accesible solo en el mismo paquete (sin modificador)
}
```

### Arrays

```java
// Declaración e inicialización
int[] numeros = new int[5]; // [0, 0, 0, 0, 0]
int[] numeros2 = {1, 2, 3, 4, 5};
int[] numeros3 = new int[]{1, 2, 3};

// Acceder a elementos
numeros[0] = 10;
int primerElemento = numeros[0];
int ultimoElemento = numeros[numeros.length - 1];

// Recorrer arrays
for (int i = 0; i < numeros.length; i++) {
    System.out.println(numeros[i]);
}

// foreach
for (int num : numeros) {
    System.out.println(num);
}

// Array de objetos
String[] nombres = new String[3];
nombres[0] = "Ana";
nombres[1] = "Juan";
nombres[2] = "María";

// Arrays multidimensionales
int[][] matriz = new int[3][3];
int[][] matriz2 = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

int valor = matriz2[1][2]; // 6
matriz2[0][1] = 10; // Cambiar valor

// Recorrer matriz
for (int i = 0; i < matriz2.length; i++) {
    for (int j = 0; j < matriz2[i].length; j++) {
        System.out.print(matriz2[i][j] + " ");
    }
    System.out.println();
}
```

### Strings (Manejo de texto)

```java
// Creación de Strings
String str1 = "Hola";
String str2 = new String("Hola");
String str3 = "Hola " + "Mundo";

// Longitud
int longitud = str1.length(); // 4

// Concatenación
String saludo = "Hola";
String nombre = "Ana";
String resultado = saludo + " " + nombre; // "Hola Ana"
String resultado2 = saludo.concat(" ").concat(nombre);

// Comparación
boolean igual = str1.equals(str2); // true (contenido)
boolean igualIgnoreCase = str1.equalsIgnoreCase("HOLA"); // true
boolean mismaReferencia = str1 == str2; // false (comparación de referencias)

// Caracteres y posiciones
char letra = str1.charAt(0); // 'H'
int posicion = str1.indexOf('o'); // 1

// Substrings
String frase = "Hola Mundo";
String sub = frase.substring(0, 4); // "Hola"
String sub2 = frase.substring(5); // "Mundo"

// Transformaciones
String mayus = frase.toUpperCase(); // "HOLA MUNDO"
String minus = frase.toLowerCase(); // "hola mundo"
String sinEspacios = "  Hola  ".trim(); // "Hola"

// Reemplazo
String reemplazado = frase.replace('o', 'a'); // "Hala Munda"
String reemplazado2 = frase.replace("Mundo", "Amigo"); // "Hola Amigo"

// División
String[] palabras = frase.split(" "); // ["Hola", "Mundo"]

// Verificación
boolean empiezaCon = frase.startsWith("Hol"); // true
boolean terminaCon = frase.endsWith("ndo"); // true
boolean contiene = frase.contains("Mun"); // true
boolean vacio = frase.isEmpty(); // false
boolean vacio2 = "".isEmpty(); // true

// Formateo (similar a printf en C)
String formateado = String.format("Hola %s, tienes %d años", "Ana", 25);
System.out.printf("Valor: %.2f%n", 3.14159);
```

### Paquetes y Organización de Código

```java
// 1. Declaración del paquete
package com.miempresa.miproyecto.modelo;

// 2. Importaciones
import java.util.List;
import java.util.ArrayList;
import static java.lang.Math.PI; // importación estática

// 3. Clase en el paquete
public class Producto {
    private String nombre;
    private double precio;

    public Producto(String nombre, double precio) {
        this.nombre = nombre;
        this.precio = precio;
    }
    // Getters y Setters
}
```

### Tips y Buenas Prácticas

1. **Nombres descriptivos**: Variables en camelCase, clases en PascalCase, constantes en UPPER_SNAKE_CASE.
2. **Comentarios útiles**:
   ```java
   // Comentario de línea
   /* Comentario de bloque */
   /**
    * Documentación Javadoc
    * @param parametro Descripción
    * @return Descripción del retorno
    */
   ```
3. **Indentación consistente**: 4 espacios o tabulador.
4. **No usar variables sin inicializar**: Java no te dejará compilar.
5. **Preferir StringBuilder para concatenaciones pesadas**:
   ```java
   StringBuilder sb = new StringBuilder();
   for (int i = 0; i < 1000; i++) {
       sb.append(i);
   }
   String resultado = sb.toString();
   ```

### Errores Comunes en Java

| Error | Causa | Solución |
|-------|-------|----------|
| `class, interface, or enum expected` | Llaves mal balanceadas o código fuera de la clase | Revisa que todo esté dentro de la clase |
| `cannot find symbol` | Variable o método no declarado | Declara la variable o verifica el nombre |
| `incompatible types` | Error de tipos (ej. asignar double a int) | Usa casting o cambia el tipo de la variable |
| `missing return statement` | Método con retorno sin return | Asegura que todos los caminos retornen algo |
| `variable X might not have been initialized` | Variable usada sin inicializar | Inicializa la variable antes de usarla |
| `ArrayIndexOutOfBoundsException` | Acceder a índice fuera del array | Verifica que el índice esté entre 0 y length-1 |
| `NullPointerException` | Usar null como si fuera objeto | Verifica que el objeto no sea null antes de usarlo |
| `NoSuchElementException` | Scanner sin datos | Verifica que haya datos antes de leer |
| `InputMismatchException` | Leer tipo incorrecto con Scanner | Lee el tipo correcto o usa try-catch |

## Ejemplos de Código

### Ejemplo 1: Programa completo con estructura

```java
package com.ejemplo;

import java.util.Scanner;

public class ProgramaPrincipal {

    public static final double IVA = 0.21;

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("=== Calculadora de Precios ===");
        System.out.print("Ingresa el precio base: ");
        double precioBase = scanner.nextDouble();

        System.out.print("Ingresa el descuento (%): ");
        double descuento = scanner.nextDouble();

        double precioConDescuento = aplicarDescuento(precioBase, descuento);
        double precioFinal = precioConDescuento * (1 + IVA);

        System.out.printf("Precio original: %.2f€%n", precioBase);
        System.out.printf("Descuento: %.2f%%%n", descuento);
        System.out.printf("Precio con descuento: %.2f€%n", precioConDescuento);
        System.out.printf("Precio final (con IVA): %.2f€%n", precioFinal);

        scanner.close();
    }

    public static double aplicarDescuento(double precio, double descuento) {
        if (descuento < 0 || descuento > 100) {
            throw new IllegalArgumentException("Descuento inválido");
        }
        return precio * (1 - descuento / 100);
    }
}
```

### Ejemplo 2: Manejo de arrays y colecciones

```java
package com.ejemplo;

import java.util.ArrayList;
import java.util.List;

public class GestorDeEmpleados {

    private List<Empleado> empleados = new ArrayList<>();

    public void agregarEmpleado(Empleado empleado) {
        empleados.add(empleado);
    }

    public void mostrarTodos() {
        for (Empleado emp : empleados) {
            System.out.println(emp);
        }
    }

    public Empleado buscarPorNombre(String nombre) {
        for (Empleado emp : empleados) {
            if (emp.getNombre().equalsIgnoreCase(nombre)) {
                return emp;
            }
        }
        return null;
    }

    public double calcularSalarioPromedio() {
        if (empleados.isEmpty()) {
            return 0;
        }
        double total = 0;
        for (Empleado emp : empleados) {
            total += emp.getSalario();
        }
        return total / empleados.size();
    }
}
```

### Ejemplo 3: Uso de bucles y condicionales avanzados

```java
package com.ejemplo;

import java.util.Arrays;

public class ProcesadorDeDatos {

    public static int[] filtrarPares(int[] numeros) {
        int[] resultado = new int[0];
        for (int num : numeros) {
            if (num % 2 == 0) {
                resultado = Arrays.copyOf(resultado, resultado.length + 1);
                resultado[resultado.length - 1] = num;
            }
        }
        return resultado;
    }

    public static int encontrarMaximo(int[] numeros) {
        if (numeros.length == 0) {
            throw new IllegalArgumentException("Array vacío");
        }
        int maximo = numeros[0];
        for (int i = 1; i < numeros.length; i++) {
            if (numeros[i] > maximo) {
                maximo = numeros[i];
            }
        }
        return maximo;
    }

    public static int sumarTodos(int[] numeros) {
        int suma = 0;
        for (int num : numeros) {
            suma += num;
        }
        return suma;
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 01: Hola Mundo](./ejercicios/nivel-01-fundamentos/ejercicio-01-hola-mundo/)
- [Ejercicio 02: Variables y Tipos](./ejercicios/nivel-01-fundamentos/ejercicio-02-variables-y-tipos/)
- [Ejercicio 03: Operadores y Condicionales](./ejercicios/nivel-01-fundamentos/ejercicio-03-operadores-y-condicionales/)
- [Ejercicio 04: Bucles](./ejercicios/nivel-01-fundamentos/ejercicio-04-bucles/)
- [Ejercicio 05: Arrays](./ejercicios/nivel-01-fundamentos/ejercicio-05-arrays/)
- [Ejercicio 06: Strings](./ejercicios/nivel-01-fundamentos/ejercicio-06-strings/)

## Recursos

- [Documentación oficial de Oracle](https://docs.oracle.com/en/java/)
- [Java Tutorials](https://docs.oracle.com/javase/tutorial/)
- [JDK Downloads](https://www.oracle.com/java/technologies/downloads/)
- [OpenJDK](https://openjdk.org/)
- [Stack Overflow - Java](https://stackoverflow.com/questions/tagged/java)
- [IntelliJ IDEA (IDE recomendado)](https://www.jetbrains.com/idea/)
- [Eclipse (IDE)](https://www.eclipse.org/)