# 02 — Programación Orientada a Objetos (POO)

## Objetivos

- [ ] Definir clases con atributos y métodos.
- [ ] Crear objetos con el operador `new` y constructores.
- [ ] Aplicar encapsulación con `private` y métodos `getters/setters`.
- [ ] Comprender `this`, `static` y `final` en el contexto de las clases.
- [ ] Escribir métodos con parámetros, retorno y sobrecarga.
- [ ] Trabajar con `String` y sus métodos más comunes.

## Apuntes

### Clases y objetos

Una **clase** es una plantilla que define atributos (datos) y métodos (comportamiento). Un **objeto** es una instancia concreta de esa clase, creada con `new`.

- `new` reserva memoria y llama al constructor.
- Cada objeto tiene su propio estado: cambiar un atributo en uno no afecta a otro.
- El archivo debe llamarse `NombreDeLaClase.java` si la clase es pública.

```java
public class Persona {
    String nombre;
    int edad;
}

public class Main {
    public static void main(String[] args) {
        Persona ana = new Persona();
        ana.nombre = "Ana";
        ana.edad = 30;

        Persona luis = new Persona(); // otro objeto independiente
        System.out.println(ana.nombre); // Ana
    }
}
```

### Constructores

Un **constructor** inicializa el objeto y tiene el mismo nombre que la clase, sin tipo de retorno. Si no defines ninguno, Java crea el constructor por defecto sin argumentos. Puedes tener varios constructores (sobrecarga).

```java
public class Rectangulo {
    double ancho;
    double alto;

    public Rectangulo() {
        this(1.0, 1.0); // llama al otro constructor
    }

    public Rectangulo(double ancho, double alto) {
        this.ancho = ancho;
        this.alto = alto;
    }

    double area() {
        return ancho * alto;
    }
}
```

### Encapsulación

La encapsulación protege los atributos haciéndolos `private` y exponiéndolos mediante métodos públicos (**getters** para leer, **setters** para escribir). Así puedes validar los datos antes de guardarlos.

Convención: `private`, getters `getX()`, setters `setX()`, y `boolean` usa `isX()` para el getter.

```java
public class Cuenta {
    private double saldo;

    public double getSaldo() {
        return saldo;
    }

    public void depositar(double monto) {
        if (monto <= 0) {
            throw new IllegalArgumentException("El monto debe ser positivo");
        }
        saldo += monto;
    }
}
```

### this, static y final

- `this` referencia al objeto actual (desambigua atributos de parámetros, encadena constructores).
- `static` pertenece a la **clase**, no a cada objeto: un único valor compartido (contadores, constantes, métodos de utilidad como `Math.max`).
- `static final` define constantes de clase.
- `final` en un atributo de instancia lo hace inmutable tras la inicialización.

```java
public class Contador {
    public static final int MAX = 100; // constante de clase
    private static int total = 0;      // compartido entre todos los objetos
    private int numero;                // propio de cada objeto

    public Contador() {
        numero = ++total;
    }

    public static int getTotal() {
        return total;
    }
}
```

### Métodos

- Declaración: `modificador tipoRetorno nombre(parámetros) { cuerpo }`.
- `void` indica que no devuelve nada.
- **Sobrecarga (overload):** varios métodos con el mismo nombre pero distintos parámetros. Se resuelve por los tipos de los argumentos.
- Los parámetros se pasan **por valor**: una copia para primitivos, una copia de la referencia para objetos (por eso mutar el objeto sí se ve fuera, reasignarlo no).

```java
public class Util {
    public static int suma(int a, int b) {
        return a + b;
    }

    public static double suma(double a, double b) { // sobrecarga
        return a + b;
    }
}
```

### String

`String` es inmutable: cada operación que "modifica" crea un string nuevo. Compara contenido con `equals()`, nunca con `==`.

```java
String saludo = "Hola";
String nombre = "Ana";
System.out.println(saludo.length());        // 4
System.out.println(saludo.toUpperCase());   // HOLA
System.out.println(saludo + ", " + nombre); // Hola, Ana (concatenación)
System.out.println(saludo.equals("hola"));  // false (distingue mayúsculas)
System.out.println(saludo.startsWith("Ho"));// true
System.out.println("  x  ".trim());         // "x"
```

## Ejemplos de código

```java
// Programa completo con clase, constructor, encapsulación y main
public class Estudiante {
    private String nombre;
    private int nota;

    public Estudiante(String nombre, int nota) {
        this.nombre = nombre;
        this.nota = nota;
    }

    public String getNombre() {
        return nombre;
    }

    public int getNota() {
        return nota;
    }

    public String aprueba() {
        return nota >= 60 ? "aprueba" : "reprueba";
    }

    public static void main(String[] args) {
        Estudiante ana = new Estudiante("Ana", 85);
        Estudiante luis = new Estudiante("Luis", 45);
        System.out.println(ana.getNombre() + " " + ana.aprueba());
        System.out.println(luis.getNombre() + " " + luis.aprueba());
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Comparar `String` con `==`** → compara referencias. Usa `.equals()`.
- **Confundir `static` y no `static`** → un método `main` no puede llamar directamente a un método de instancia sin crear un objeto.
- **Getter/setter llamados como atributos** → `getNombre()` se invoca con `()`, sin paréntesis no compila.
- **Constructor sin tipo de retorno** → si le pones `void`, deja de ser constructor.
- **Olvidar `new`** → `Persona p = Persona();` no compila; hace falta `new`.
- **Confundir sobrecarga con sobrescritura** → sobrecarga: mismo nombre, otros parámetros; sobrescritura (override): misma firma en una subclase (guía 03).

## Recursos

- [Oracle — Classes and Objects](https://docs.oracle.com/javase/tutorial/java/javaOO/index.html)
- [Oracle — Encapsulation](https://docs.oracle.com/javase/tutorial/java/javaOO/accesscontrol.html)
- [Java String API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/String.html)
- [W3Schools — Java OOP](https://www.w3schools.com/java/java_oop.asp)