# 01 — Fundamentos de Java

## Objetivos

- [ ] Escribir y ejecutar un programa Java desde el método `main`.
- [ ] Declarar variables con tipos primitivos y `String`.
- [ ] Comprender los tipos primitivos: `int`, `double`, `boolean`, `char`, `long`.
- [ ] Aplicar operadores aritméticos, de comparación, lógicos y de asignación.
- [ ] Escribir condicionales `if/else if/else` y `switch`.
- [ ] Usar los bucles `for`, `while` y `do...while`.

## Apuntes

### El método main

Todo programa Java arranca en el método `main`, que **siempre** tiene esta firma:

```java
public static void main(String[] args)
```

- `public` → accesible desde fuera de la clase.
- `static` → se ejecuta sin crear un objeto de la clase.
- `void` → no devuelve valor.
- `String[] args` → argumentos pasados desde la línea de comandos.

El archivo debe llamarse igual que la clase pública y tener extensión `.java`. Para compilar y ejecutar:

```bash
javac Hola.java
java Hola
```

```java
public class Hola {
    public static void main(String[] args) {
        System.out.println("¡Hola, mundo!");
    }
}
```

### Tipos primitivos

| Tipo | Tamaño | Rango / uso | Ejemplo |
|---|---|---|---|
| `int` | 32 bits | enteros de ~±2.1 mil millones | `42` |
| `long` | 64 bits | enteros grandes, sufijo `L` | `3000000000L` |
| `double` | 64 bits | decimales de doble precisión | `3.14159` |
| `float` | 32 bits | decimales, sufijo `F` (menos preciso) | `2.5F` |
| `boolean` | 1 bit | `true` o `false` | `true` |
| `char` | 16 bits | un solo carácter Unicode | `'A'` |
| `byte` | 8 bits | enteros de −128 a 127 | `100` |
| `short` | 16 bits | enteros pequeños | `2000` |

Además está `String`, que **no es un primitivo** sino una clase (un objeto), pero se usa igual que uno en la práctica.

### Variables y constantes

- Una variable se declara con `tipo nombre = valor;`.
- El tipo **nunca cambia**: si declaras `int edad`, solo podrás guardar enteros.
- Para constantes se usa `final`; no se puede reasignar una vez inicializada.
- Convención: variables en `camelCase`, constantes en `MAYÚSCULAS` con guiones bajos.

```java
int edad = 30;
double altura = 1.72;
boolean estudiaJava = true;
char inicial = 'A';
String nombre = "Ana";

final double IVA = 0.21;
// IVA = 0.22; // ERROR: no se puede reasignar una constante
```

### Operadores

- **Aritméticos:** `+ - * / %`. La división entre enteros trunca: `7 / 2` da `3`, no `3.5`.
- **Comparación:** `== != > < >= <=`. Da un `boolean`.
- **Lógicos:** `&&` (y), `||` (o), `!` (negación).
- **Asignación:** `= += -= *= /= ++ --`.

```java
System.out.println(7 / 2);   // 3 (división entera)
System.out.println(7.0 / 2); // 3.5
System.out.println(7 % 3);   // 1 (resto)
System.out.println(5 == 5);  // true
System.out.println(!true);   // false

int contador = 0;
contador++;        // 1
contador += 10;    // 11
```

### Condicionales

`if`, `else if` y `else` evalúan condiciones que devuelven `boolean`. Ojo: `if (x = 5)` es un error de compilación, porque asignar devuelve el valor, no un booleano.

```java
int nota = 85;
if (nota >= 90) {
    System.out.println("Excelente");
} else if (nota >= 70) {
    System.out.println("Aprobado");
} else {
    System.out.println("Reprobado");
}

// Operador ternario (expresión que devuelve un valor)
String resultado = nota >= 60 ? "aprueba" : "reprueba";
System.out.println(resultado);
```

`switch` compara un valor contra varias constantes. Desde Java 14 soporta la sintaxis de flecha, que evita el `break` y devuelve valor:

```java
int dia = 3;
String nombreDia = switch (dia) {
    case 1 -> "Lunes";
    case 2 -> "Martes";
    case 3 -> "Miércoles";
    case 4 -> "Jueves";
    case 5 -> "Viernes";
    case 6, 7 -> "Fin de semana";
    default -> "Día inválido";
};
System.out.println(nombreDia);
```

### Bucles

- `for` — repetición con contador.
- `while` — repite mientras la condición sea verdadera (comprueba antes de ejecutar).
- `do...while` — ejecuta el cuerpo **al menos una vez** (comprueba al final).
- `break` corta el bucle; `continue` salta a la siguiente iteración.
- El bucle `for-each` recorre arrays y colecciones: `for (Tipo elemento : coleccion)`.

```java
for (int i = 0; i < 3; i++) {
    System.out.print(i + " "); // 0 1 2
}
System.out.println();

int n = 0;
while (n < 3) {
    n++;
}

int intento = 0;
do {
    System.out.println("Siempre al menos una vez: " + intento);
    intento++;
} while (intento < 2);
```

## Ejemplos de código

```java
// Tabla de multiplicar
public class Tabla {
    public static void main(String[] args) {
        int numero = 7;
        for (int i = 1; i <= 10; i++) {
            System.out.println(numero + " x " + i + " = " + (numero * i));
        }
    }
}
```

```java
// Clasificador de números
public class Clasificador {
    public static void main(String[] args) {
        for (int n = 1; n <= 5; n++) {
            String paridad = (n % 2 == 0) ? "par" : "impar";
            System.out.println(n + " es " + paridad);
        }
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Nombre del archivo distinto al de la clase** → error `class X is public, should be declared in a file named X.java`.
- **Olvidar el método `main`** → `Error: Main method not found in class`.
- **División entera inesperada** → `5 / 2` da `2`. Usa `5.0 / 2` si necesitas decimal.
- **Comparar `String` con `==`** → compara referencias, no contenido. Usa `.equals()` (lo verás en la guía de POO).
- **No cerrar llaves** → el compilador avisa con `reached end of file while parsing`. Revisa la indentación.
- **Usar `=` en vez de `==` en un `if`** → no compila porque la condición debe ser `boolean`.
- **Usar `==` para comparar objetos** → con strings siempre `equals()`.

## Recursos

- [Documentación oficial de Java (Oracle)](https://docs.oracle.com/en/java/javase/17/docs/api/index.html)
- [The Java Tutorials — Learning the Java Language](https://docs.oracle.com/javase/tutorial/java/)
- [Adoptium (OpenJDK builds)](https://adoptium.net/)
- [SDKMAN — gestor de JDKs](https://sdkman.io/)
- [Java 17 — Novedades del lenguaje](https://openjdk.org/projects/jdk/17/)