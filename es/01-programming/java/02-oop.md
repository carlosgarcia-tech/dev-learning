# 02 — Programación Orientada a Objetos en Java

## Objetivos

- [ ] Entender los conceptos de OOP: Clases, Objetos, Abstracción, Encapsulamiento
- [ ] Crear clases con atributos y métodos
- [ ] Usar constructores y sobrecarga de constructores
- [ ] Implementar encapsulamiento con modificadores de acceso
- [ ] Usar getters y setters correctamente
- [ ] Entender la herencia y el polimorfismo
- [ ] Usar interfaces y clases abstractas
- [ ] Conocer el concepto de "Composición sobre herencia"
- [ ] Implementar el patrón de diseño Builder

## Apuntes

### ¿Qué es la Programación Orientada a Objetos?

La Programación Orientada a Objetos (OOP) es un paradigma de programación que organiza el código en objetos que contienen datos (atributos) y comportamientos (métodos). Los cuatro pilares de OOP son:

1. **Abstracción**: Ocultar los detalles de implementación y mostrar solo la interfaz.
2. **Encapsulamiento**: Agrupar datos y métodos que operan en esos datos.
3. **Herencia**: Crear nuevas clases basadas en clases existentes.
4. **Polimorfismo**: Permite que objetos de diferentes tipos respondan al mismo mensaje de manera diferente.

### Clases y Objetos

#### Definición de una clase

```java
public class Persona {
    // 1. Atributos (datos)
    private String nombre;
    private int edad;
    private String telefono;
    private static int contadorPersonas = 0; // Atributo estático

    // 2. Constructor(es)
    public Persona() {
        this.nombre = "Sin nombre";
        this.edad = 0;
        contadorPersonas++;
    }

    public Persona(String nombre, int edad) {
        this.nombre = nombre;
        this.edad = edad;
        contadorPersonas++;
    }

    // 3. Métodos (comportamiento)
    public void saludar() {
        System.out.println("Hola, soy " + nombre + " y tengo " + edad + " años");
    }

    public void cumplirAnios() {
        edad++;
    }

    // 4. Getters y Setters
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getEdad() {
        return edad;
    }

    public void setEdad(int edad) {
        if (edad >= 0 && edad <= 150) {
            this.edad = edad;
        } else {
            throw new IllegalArgumentException("Edad inválida");
        }
    }

    // Método estático
    public static int getContadorPersonas() {
        return contadorPersonas;
    }

    // Sobrescribir toString()
    @Override
    public String toString() {
        return String.format("Persona{nombre='%s', edad=%d}", nombre, edad);
    }
}
```

#### Uso de la clase

```java
public class Main {
    public static void main(String[] args) {
        // Crear objetos (instancias)
        Persona persona1 = new Persona(); // Constructor vacío
        Persona persona2 = new Persona("Ana", 25); // Constructor con parámetros

        // Usar métodos
        persona1.saludar(); // "Hola, soy Sin nombre y tengo 0 años"
        persona2.saludar(); // "Hola, soy Ana y tengo 25 años"

        // Modificar atributos
        persona1.setNombre("Juan");
        persona1.setEdad(30);
        persona1.saludar(); // "Hola, soy Juan y tengo 30 años"

        // Usar atributos estáticos
        System.out.println("Total personas: " + Persona.getContadorPersonas()); // 2

        // Imprimir objeto (usa toString)
        System.out.println(persona2); // Persona{nombre='Ana', edad=25}
    }
}
```

### Encapsulamiento

El encapsulamiento oculta los detalles internos de una clase y expone solo lo necesario.

```java
public class CuentaBancaria {
    private String titular;
    private double saldo;
    private String numeroCuenta;
    private static final double LIMITE_RETIRO = 1000.0;

    public CuentaBancaria(String titular, String numeroCuenta) {
        this.titular = titular;
        this.numeroCuenta = numeroCuenta;
        this.saldo = 0.0;
    }

    // Métodos públicos que exponen funcionalidad controlada
    public void depositar(double cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("Cantidad debe ser positiva");
        }
        saldo += cantidad;
        System.out.println("Depósito exitoso. Nuevo saldo: " + saldo);
    }

    public boolean retirar(double cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("Cantidad debe ser positiva");
        }
        if (cantidad > LIMITE_RETIRO) {
            System.out.println("Límite de retiro excedido (máx " + LIMITE_RETIRO + ")");
            return false;
        }
        if (saldo < cantidad) {
            System.out.println("Saldo insuficiente");
            return false;
        }
        saldo -= cantidad;
        System.out.println("Retiro exitoso. Nuevo saldo: " + saldo);
        return true;
    }

    // Solo lectura (sin setter)
    public double getSaldo() {
        return saldo;
    }

    public String getTitular() {
        return titular;
    }

    // Acceso controlado
    public String getNumeroCuenta() {
        // Mostrar solo últimos 4 dígitos por seguridad
        return "****" + numeroCuenta.substring(numeroCuenta.length() - 4);
    }
}
```

### Herencia

La herencia permite crear una nueva clase basada en una existente.

```java
// Clase padre (superclase)
public class Animal {
    private String nombre;
    private int edad;

    public Animal(String nombre, int edad) {
        this.nombre = nombre;
        this.edad = edad;
    }

    public void comer() {
        System.out.println(nombre + " está comiendo");
    }

    public void dormir() {
        System.out.println(nombre + " está durmiendo");
    }

    public void hacerSonido() {
        System.out.println("El animal hace un sonido");
    }

    public String getNombre() {
        return nombre;
    }
}

// Clase hija (subclase)
public class Perro extends Animal {
    private String raza;

    public Perro(String nombre, int edad, String raza) {
        super(nombre, edad); // Llamar al constructor del padre
        this.raza = raza;
    }

    // Sobrescritura de método (Override)
    @Override
    public void hacerSonido() {
        System.out.println("¡Guau! ¡Guau!");
    }

    // Método específico de Perro
    public void ladrar() {
        System.out.println("¡Guau, guau, guau!");
    }

    public void correr() {
        System.out.println("El perro está corriendo");
    }
}
```

### Polimorfismo

El polimorfismo permite que objetos de diferentes clases respondan al mismo mensaje.

```java
public class Main {
    public static void main(String[] args) {
        // Polimorfismo: una variable de tipo Animal puede referenciar un Perro
        Animal miAnimal = new Perro("Max", 3, "Labrador");
        miAnimal.hacerSonido(); // "¡Guau! ¡Guau!" (método de Perro)
        miAnimal.comer(); // "Max está comiendo" (método de Animal)
        // miAnimal.ladrar(); // ERROR: Animal no tiene el método ladrar

        // Arreglo polimórfico
        Animal[] animales = new Animal[3];
        animales[0] = new Animal("Genérico", 2);
        animales[1] = new Perro("Rex", 4, "Pastor Alemán");
        animales[2] = new Animal("Otro", 3);

        for (Animal a : animales) {
            a.hacerSonido(); // Cada uno hace su sonido
        }
    }
}
```

### Clases Abstractas

Una clase abstracta no puede ser instanciada y sirve como base para otras clases.

```java
public abstract class Figura {
    protected String color;

    public Figura(String color) {
        this.color = color;
    }

    // Método abstracto: las subclases deben implementarlo
    public abstract double calcularArea();

    // Método concreto: las subclases lo heredan
    public void mostrarColor() {
        System.out.println("Color: " + color);
    }
}

public class Circulo extends Figura {
    private double radio;

    public Circulo(String color, double radio) {
        super(color);
        this.radio = radio;
    }

    @Override
    public double calcularArea() {
        return Math.PI * radio * radio;
    }
}

public class Rectangulo extends Figura {
    private double base;
    private double altura;

    public Rectangulo(String color, double base, double altura) {
        super(color);
        this.base = base;
        this.altura = altura;
    }

    @Override
    public double calcularArea() {
        return base * altura;
    }
}
```

### Interfaces

Las interfaces definen un contrato que las clases deben cumplir.

```java
// Interfaz (contrato)
public interface Reproducible {
    void reproducir();
    void pausar();
    void detener();

    // Métodos default (Java 8+)
    default void mostrarInfo() {
        System.out.println("Reproduciendo contenido");
    }

    // Métodos estáticos (Java 8+)
    static void mostrarMensaje() {
        System.out.println("Interfaz Reproducible");
    }
}

public interface Descargable {
    void descargar();
    double getProgresoDescarga();
}

// Clase que implementa múltiples interfaces
public class Cancion implements Reproducible, Descargable {
    private String titulo;
    private String artista;
    private double progresoDescarga = 0;

    public Cancion(String titulo, String artista) {
        this.titulo = titulo;
        this.artista = artista;
    }

    @Override
    public void reproducir() {
        System.out.println("Reproduciendo '" + titulo + "' de " + artista);
    }

    @Override
    public void pausar() {
        System.out.println("Pausando '" + titulo + "'");
    }

    @Override
    public void detener() {
        System.out.println("Deteniendo '" + titulo + "'");
    }

    @Override
    public void descargar() {
        System.out.println("Descargando '" + titulo + "'");
        progresoDescarga = 100;
    }

    @Override
    public double getProgresoDescarga() {
        return progresoDescarga;
    }
}
```

### Composición sobre Herencia

La composición es una alternativa a la herencia donde una clase contiene instancias de otras clases.

```java
// Composición en lugar de herencia
public class Motor {
    private int potencia;
    private String tipo;

    public Motor(int potencia, String tipo) {
        this.potencia = potencia;
        this.tipo = tipo;
    }

    public void encender() {
        System.out.println("Motor " + tipo + " encendido (" + potencia + "HP)");
    }

    public void apagar() {
        System.out.println("Motor apagado");
    }
}

public class Coche {
    private String marca;
    private String modelo;
    private Motor motor; // Composición

    public Coche(String marca, String modelo, Motor motor) {
        this.marca = marca;
        this.modelo = modelo;
        this.motor = motor;
    }

    public void arrancar() {
        System.out.println("Arrancando " + marca + " " + modelo);
        motor.encender();
    }

    public void apagar() {
        System.out.println("Apagando " + marca + " " + modelo);
        motor.apagar();
    }
}
```

### Patrón Builder

El patrón Builder ayuda a crear objetos complejos paso a paso. (Ejemplo independiente —
usa una clase `PersonaBuilder` distinta a la `Persona` de la sección anterior para
evitar colisión de nombres.)

```java
public class PersonaConBuilder {
    // Atributos obligatorios
    private final String nombre;
    private final int edad;

    // Atributos opcionales
    private final String telefono;
    private final String email;
    private final String direccion;

    // Constructor privado (solo para el Builder)
    private PersonaConBuilder(Builder builder) {
        this.nombre = builder.nombre;
        this.edad = builder.edad;
        this.telefono = builder.telefono;
        this.email = builder.email;
        this.direccion = builder.direccion;
    }

    public String getNombre() { return nombre; }
    public int getEdad() { return edad; }
    public String getTelefono() { return telefono; }
    public String getEmail() { return email; }
    public String getDireccion() { return direccion; }

    // Builder
    public static class Builder {
        // Atributos obligatorios
        private final String nombre;
        private final int edad;

        // Atributos opcionales (con valores por defecto)
        private String telefono = "Sin teléfono";
        private String email = "Sin email";
        private String direccion = "Sin dirección";

        public Builder(String nombre, int edad) {
            this.nombre = nombre;
            this.edad = edad;
        }

        public Builder telefono(String telefono) {
            this.telefono = telefono;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder direccion(String direccion) {
            this.direccion = direccion;
            return this;
        }

        public PersonaConBuilder build() {
            return new PersonaConBuilder(this);
        }
    }
}

// Uso del Builder
public class Main {
    public static void main(String[] args) {
        PersonaConBuilder persona = new PersonaConBuilder.Builder("Ana", 25)
            .telefono("123456789")
            .email("ana@email.com")
            .build();

        System.out.println(persona.getNombre() + " - " + persona.getEmail());
    }
}
```

### Errores Comunes en OOP

| Error | Causa | Solución |
|-------|-------|----------|
| `Cannot make a static reference to non-static field` | Usar variable de instancia desde contexto estático | Hacer el método/atributo estático o usar instancia |
| `ClassCastException` | Cast incorrecto de tipos | Usar `instanceof` antes del cast |
| `AbstractMethodError` (en tiempo de ejecución, con bytecode desactualizado) | No implementar métodos abstractos | Implementar todos los métodos abstractos e imponer esto en compilación |
| `Missing constructor` | No llamar al constructor del padre correctamente | Usar `super(...)` como primera línea del constructor |
| `No default constructor available` | No hay constructor sin parámetros | Crear constructor vacío o usar constructor con parámetros explícitamente |

## Ejemplos de Código

### Ejemplo 1: Sistema de Gestión de Empleados

```java
package com.ejemplo;

import java.util.ArrayList;
import java.util.List;

// Clase abstracta
public abstract class Empleado {
    private String nombre;
    private String id;
    private double salarioBase;

    public Empleado(String nombre, String id, double salarioBase) {
        this.nombre = nombre;
        this.id = id;
        this.salarioBase = salarioBase;
    }

    // Método abstracto
    public abstract double calcularSalario();

    // Métodos concretos
    public String getNombre() { return nombre; }
    public String getId() { return id; }
    public double getSalarioBase() { return salarioBase; }

    @Override
    public String toString() {
        return String.format("Empleado{nombre='%s', id='%s', salario=%.2f}",
                           nombre, id, calcularSalario());
    }
}

// Subclase concreta
public class EmpleadoFijo extends Empleado {
    private double bono;

    public EmpleadoFijo(String nombre, String id, double salarioBase, double bono) {
        super(nombre, id, salarioBase);
        this.bono = bono;
    }

    @Override
    public double calcularSalario() {
        return getSalarioBase() + bono;
    }
}

public class EmpleadoPorHora extends Empleado {
    private int horasTrabajadas;
    private double tarifaPorHora;

    public EmpleadoPorHora(String nombre, String id, double tarifaPorHora, int horasTrabajadas) {
        super(nombre, id, 0);
        this.tarifaPorHora = tarifaPorHora;
        this.horasTrabajadas = horasTrabajadas;
    }

    @Override
    public double calcularSalario() {
        return tarifaPorHora * horasTrabajadas;
    }
}

public class Empresa {
    private String nombre;
    private List<Empleado> empleados = new ArrayList<>();

    public Empresa(String nombre) {
        this.nombre = nombre;
    }

    public void agregarEmpleado(Empleado empleado) {
        empleados.add(empleado);
    }

    public double calcularTotalSalarios() {
        double total = 0;
        for (Empleado e : empleados) {
            total += e.calcularSalario();
        }
        return total;
    }

    public void mostrarTodosEmpleados() {
        System.out.println("Empleados de " + nombre + ":");
        for (Empleado e : empleados) {
            System.out.println("  - " + e);
        }
    }
}
```

### Ejemplo 2: Sistema de Notificaciones con Interfaces

```java
package com.ejemplo;

import java.util.ArrayList;
import java.util.List;

// Interfaces
public interface Notificable {
    void enviar(String mensaje);
    String getTipo();
}

public interface Canal {
    boolean estaDisponible();
    void conectar();
    void desconectar();
}

// Implementaciones
public class EmailNotificador implements Notificable, Canal {
    private String email;
    private boolean conectado;

    public EmailNotificador(String email) {
        this.email = email;
    }

    @Override
    public void enviar(String mensaje) {
        if (!estaDisponible()) {
            System.out.println("No se puede enviar email: no conectado");
            return;
        }
        System.out.println("Enviando email a " + email + ": " + mensaje);
    }

    @Override
    public String getTipo() {
        return "EMAIL";
    }

    @Override
    public boolean estaDisponible() {
        return conectado;
    }

    @Override
    public void conectar() {
        conectado = true;
        System.out.println("Email conectado");
    }

    @Override
    public void desconectar() {
        conectado = false;
        System.out.println("Email desconectado");
    }
}

public class SMSNotificador implements Notificable, Canal {
    private String telefono;
    private boolean conectado;

    public SMSNotificador(String telefono) {
        this.telefono = telefono;
    }

    @Override
    public void enviar(String mensaje) {
        if (!estaDisponible()) {
            System.out.println("No se puede enviar SMS: no conectado");
            return;
        }
        System.out.println("Enviando SMS a " + telefono + ": " + mensaje);
    }

    @Override
    public String getTipo() {
        return "SMS";
    }

    @Override
    public boolean estaDisponible() {
        return conectado;
    }

    @Override
    public void conectar() {
        conectado = true;
        System.out.println("SMS conectado");
    }

    @Override
    public void desconectar() {
        conectado = false;
        System.out.println("SMS desconectado");
    }
}

public class SistemaNotificaciones {
    private List<Notificable> canales = new ArrayList<>();

    public void agregarCanal(Notificable canal) {
        if (canal instanceof Canal c) {
            c.conectar();
            canales.add(canal);
        }
    }

    public void enviarATodos(String mensaje) {
        for (Notificable canal : canales) {
            canal.enviar(mensaje);
        }
    }

    public void mostrarCanales() {
        System.out.println("Canales disponibles:");
        for (Notificable canal : canales) {
            System.out.println("  - " + canal.getTipo());
        }
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 07: Métodos](./ejercicios/nivel-02-basico/ejercicio-01-metodos/)
- [Ejercicio 08: Clases y Objetos](./ejercicios/nivel-02-basico/ejercicio-02-clases-y-objetos/)
- [Ejercicio 09: Encapsulamiento](./ejercicios/nivel-02-basico/ejercicio-03-encapsulamiento/)
- [Ejercicio 13: Herencia y Polimorfismo](./ejercicios/nivel-03-intermedio/ejercicio-01-herencia-y-polimorfismo/)
- [Ejercicio 14: Interfaces](./ejercicios/nivel-03-intermedio/ejercicio-02-interfaces/)
- [Ejercicio 24: Patrón Builder](./ejercicios/nivel-04-avanzado/ejercicio-06-patron-builder/)

## Recursos

- [Oracle Java OOP Tutorial](https://docs.oracle.com/javase/tutorial/java/concepts/)
- [Effective Java (Joshua Bloch)](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/)
- [Java Design Patterns](https://www.javatpoint.com/design-patterns-in-java)