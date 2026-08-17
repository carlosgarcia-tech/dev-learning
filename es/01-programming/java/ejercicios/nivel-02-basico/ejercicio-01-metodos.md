# Ejercicio 01 — Métodos

- **Nivel:** 2/5
- **Tema:** definición de métodos, parámetros, retorno, sobrecarga
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `Metodos.java` con la clase `Metodos` y los siguientes métodos **estáticos**:

1. `esPar(int n)` — devuelve `true` si `n` es par.
2. `areaRectangulo(double base, double alto)` — devuelve base × alto.
3. `mayor(int a, int b)` — devuelve el mayor de dos enteros.
4. Sobrecarga de `saludar(String nombre)` y `saludar(String nombre, String idioma)` — la primera imprime `Hola, <nombre>`, la segunda imprime un saludo según el idioma (`es`, `en`).
5. En `main`, llama a todos los métodos e imprime sus resultados.

Salida esperada:

```
¿5 es par? false
Área rectángulo 4x3 = 12.0
Mayor entre 7 y 3 = 7
Hola, Ana
Hello, Ana
```

## Requisitos

- [ ] Definir al menos 4 métodos estáticos con parámetros y retorno.
- [ ] Incluir un ejemplo de sobrecarga (mismo nombre, distintos parámetros).
- [ ] Llamar a todos los métodos desde `main`.
- [ ] Compilarlo localmente con `javac Metodos.java` y ejecutarlo con `java Metodos` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Firma: `public static boolean esPar(int n) { return n % 2 == 0; }`.
- La sobrecarga se resuelve por los argumentos: `saludar("Ana")` y `saludar("Ana", "en")`.
- Usa `if/else` o `switch` dentro de `saludar` según el idioma.
- `static` permite llamarlos desde `main` sin crear un objeto.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Metodos {
    public static boolean esPar(int n) {
        return n % 2 == 0;
    }

    public static double areaRectangulo(double base, double alto) {
        return base * alto;
    }

    public static int mayor(int a, int b) {
        return a > b ? a : b;
    }

    public static void saludar(String nombre) {
        System.out.println("Hola, " + nombre);
    }

    public static void saludar(String nombre, String idioma) {
        if ("en".equals(idioma)) {
            System.out.println("Hello, " + nombre);
        } else {
            System.out.println("Hola, " + nombre);
        }
    }

    public static void main(String[] args) {
        System.out.println("¿5 es par? " + esPar(5));
        System.out.println("Área rectángulo 4x3 = " + areaRectangulo(4, 3));
        System.out.println("Mayor entre 7 y 3 = " + mayor(7, 3));
        saludar("Ana");
        saludar("Ana", "en");
    }
}
````

</details>