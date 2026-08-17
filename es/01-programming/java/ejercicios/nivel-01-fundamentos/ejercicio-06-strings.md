# Ejercicio 06 — Strings

- **Nivel:** 1/5
- **Tema:** métodos de `String`, `equals`, concatenación, `StringBuilder`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `Strings.java` que:

1. Declare `String texto = "  Programacion en Java  ";`.
2. Imprima la longitud del texto y la longitud tras `trim()`.
3. Imprima el texto en mayúsculas y en minúsculas.
4. Compruebe si el texto contiene la palabra `Java` (usa `toLowerCase()` y `contains` para que no dependa de mayúsculas) e imprima el resultado.
5. Invierta el texto con un bucle (o con `StringBuilder.reverse()`) e imprima el resultado.
6. Cuente cuántas veces aparece la letra `a` (ignorando mayúsculas).

Salida esperada (resumen):

```
Longitud: 24, Longitud sin espacios: 20
Mayúsculas: PROGRAMACION EN JAVA
Minúsculas: programacion en java
Contiene "java": true
Texto invertido: avaJ ne noicamargorP
La letra 'a' aparece 4 veces
```

## Requisitos

- [ ] Usar `trim()`, `toUpperCase()`, `toLowerCase()` y `contains()`.
- [ ] Comparar/contener sin distinguir mayúsculas (con `toLowerCase()` o `equalsIgnoreCase`).
- [ ] Invertir el texto con un bucle manual o `StringBuilder`.
- [ ] Contar apariciones de una letra con un bucle.
- [ ] Compilarlo localmente con `javac Strings.java` y ejecutarlo con `java Strings` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `texto.trim()` elimina espacios al inicio y al final.
- Para buscar sin distinguir mayúsculas: `texto.toLowerCase().contains("java")`.
- Invertir con bucle: recorre de atrás hacia adelante con `charAt(i)`.
- Contar letras: compara `texto.toLowerCase().charAt(i)` con `'a'`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Strings {
    public static void main(String[] args) {
        String texto = "  Programacion en Java  ";

        System.out.println("Longitud: " + texto.length()
                + ", Longitud sin espacios: " + texto.trim().length());
        System.out.println("Mayúsculas: " + texto.toUpperCase());
        System.out.println("Minúsculas: " + texto.toLowerCase());

        boolean contiene = texto.toLowerCase().contains("java");
        System.out.println("Contiene \"java\": " + contiene);

        String invertido = new StringBuilder(texto.trim()).reverse().toString();
        System.out.println("Texto invertido: " + invertido);

        String enMinusculas = texto.toLowerCase();
        int contador = 0;
        for (int i = 0; i < enMinusculas.length(); i++) {
            if (enMinusculas.charAt(i) == 'a') {
                contador++;
            }
        }
        System.out.println("La letra 'a' aparece " + contador + " veces");
    }
}
````

</details>